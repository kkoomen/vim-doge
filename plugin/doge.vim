let s:save_cpo = &cpoptions
set cpoptions&vim

let s:unsupported_msg = '[DoGe] Unsupported version. %s is required.'

if !has('nvim') && (v:version < 700 || !has('patch-7.4.2119'))
  echohl WarningMsg
  echo printf(s:unsupported_msg, 'Vim v7.4.2119+')
  echohl None
  finish
endif

if has('nvim') && !has('nvim-0.3.2')
  echohl WarningMsg
  echo printf(s:unsupported_msg, 'NeoVim v0.3.2+')
  echohl None
  finish
endif

" section Introduction, intro {{{

""
" @section Introduction, intro
" We all love documentation because it makes our codebases easier to understand,
" yet no one has time to write it in a good and proper way.
"
" DoGe is a (Do)cumentation (Ge)nerator which will generate a proper
" documentation skeleton based on certain expressions (mainly functions).
" Simply put your cursor on a function, press `<Leader>d`, jump quickly through TODO
" items using `<Tab>` and `<S-Tab>` to quickly add descriptions and go on
" coding!

" }}}
" section Preprocessors, preprocessors {{{

""
" @section Preprocessors, preprocessors
" @parentsection functions
" Preprocess functions are called for specific filetypes when @plugin(name) is
" generating a comment. The following preprocess functions are available:
"
"   doge#preprocessors#<filetype>#tokens(tokens)
"
"   doge#preprocessors#<filetype>#parameters_tokens(tokens)
"
"   doge#preprocessors#<filetype>#type_parameters_tokens(tokens)
"
"   doge#preprocessors#<filetype>#exceptions_tokens(tokens)
"
"   doge#preprocessors#<filetype>#insert_position(lnum_insert_pos)
"
"   doge#preprocessors#<filetype>#template(template)

" }}}

if exists('g:loaded_doge')
  finish
endif
let g:loaded_doge = 1

if !exists('g:doge_enable_mappings')
  ""
  " (Default: 1)
  "
  " Whether or not to enable built-in mappings.
  let g:doge_enable_mappings = 1
endif

if !exists('g:doge_mapping')
  ""
  " (Default: '<Leader>d')
  "
  " The mapping to trigger DoGe. The mapping accepts a count, to select a
  " specific doc standard, if more than one is defined.
  let g:doge_mapping = '<Leader>d'
endif

""
" (Default: {
"   'javascript': [
"     'javascript.jsx',
"     'javascriptreact',
"     'javascript.tsx',
"     'typescriptreact',
"     'typescript',
"   ],
"   'java': ['groovy'],
" })

" Set filetypes as an alias for other filetypes.
" The key should be the filetype that is defined in ftplugin/<key>.vim.
" The value must be a list of 1 or more filetypes that will be aliases.
"
" Example:
" let g:doge_filetype_aliases = {
" \  'javascript': ['vue']
" \}
"
" If you use the above settings and you open `myfile.vue` then it will behave
" like you're opening a javascript filetype.
let g:doge_filetype_aliases = doge#helpers#deepextend({
\  'javascript': [
\    'javascript.jsx',
\    'javascriptreact',
\    'javascript.tsx',
\    'typescriptreact',
\    'typescript',
\    'typescript.tsx',
\  ],
\  'java': ['groovy'],
\}, get(g:, 'doge_filetype_aliases', {}), 1)

if !exists('g:doge_buffer_mappings')
  ""
  " (Default: 1)
  "
  " Mappings to jump forward/backward are applied as buffer mappings when
  " interactive mode starts and removed when it ends.
  let g:doge_buffer_mappings = 1
endif

if !exists('g:doge_mapping_comment_jump_forward')
  ""
  " (Default: '<Tab>')
  "
  " The mapping to jump forward to the next TODO item in a comment.
  " Requires @setting(g:doge_comment_interactive) to be enabled.
  let g:doge_mapping_comment_jump_forward = '<Tab>'
endif

if !exists('g:doge_mapping_comment_jump_backward')
  ""
  " (Default: '<S-Tab>')
  "
  " The mapping to jump backward to the previous TODO item in a comment.
  " Requires @setting(g:doge_comment_interactive) to be enabled.
  let g:doge_mapping_comment_jump_backward = '<S-Tab>'
endif

if !exists('g:doge_comment_interactive')
  ""
  " (Default: 1)
  "
  " Jumps interactively through all TODO items in the generated comment.
  let g:doge_comment_interactive = 1
endif

if !exists('g:doge_comment_jump_wrap')
  ""
  " (Default: 1)
  "
  " Continue to cycle among placeholders when reaching the start or end.
  let g:doge_comment_jump_wrap = 1
endif

if !exists('g:doge_comment_jump_modes')
  ""
  " (Default: ['n', 'i', 's'])
  "
  " Defines the modes in which doge will jump forward and backward when
  " interactive mode is active. For example: removing 'i' would allow you to use
  " <Tab> for autocompletion in insert mode.
  let g:doge_comment_jump_modes = ['n', 'i', 's']
endif

" Register all the <Plug> mappings.

nnoremap <Plug>(doge-generate) :<C-u>call doge#generate(v:count)<CR>
for s:mode in g:doge_comment_jump_modes
  call execute(printf('%snoremap <expr> <Plug>(doge-comment-jump-forward) doge#comment#jump("forward")', s:mode), 'silent!')
  call execute(printf('%snoremap <expr> <Plug>(doge-comment-jump-backward) doge#comment#jump("backward")', s:mode), 'silent!')
endfor

if g:doge_enable_mappings == v:true
  call execute(printf('nmap <silent> %s <Plug>(doge-generate)', g:doge_mapping), 'silent!')
  if g:doge_buffer_mappings == v:false
    for s:mode in g:doge_comment_jump_modes
      call execute(printf('%smap <silent> %s <Plug>(doge-comment-jump-forward)', s:mode, g:doge_mapping_comment_jump_forward), 'silent!')
      call execute(printf('%smap <silent> %s <Plug>(doge-comment-jump-backward)', s:mode, g:doge_mapping_comment_jump_backward), 'silent!')
    endfor
  endif
endif
unlet s:mode

if has('win32') && &shellslash
  set noshellslash
  let g:doge_dir = resolve(expand('<sfile>:p:h:h'))
  set shellslash
else
  let g:doge_dir = resolve(expand('<sfile>:p:h:h'))
endif

""
" @command DogeGenerate {doc_standard}
" Command to generate documentation. The `{doc_standard}` accepts a count or a
" string as argument, and it can complete the available doc standards for the
" current buffer.
"
" The numeric value should point to an index key from the
" `b:doge_supported_doc_standards` variable.
"
" The string value should point to a doc standard name listed in the
" `b:doge_supported_doc_standards` variable.
command -count -nargs=? -complete=customlist,doge#command_complete DogeGenerate call doge#generate(<count> ? <count> : <q-args>)

""
" @command DogeCreateDocStandard {doc_standard}
" Command to generate a custom doc standard template. The `{doc_standard}` is a
" mandatory argument which is the name of the new doc standard. If it exists,
" the existing doc standard with the same name will be used as base for the
" custom template.
"
" It can complete the available doc standards for the current buffer.
command -nargs=1 -complete=customlist,doge#command_complete DogeCreateDocStandard call doge#pattern#custom(<q-args>)

augroup doge
  autocmd!
  autocmd TextChangedI * call doge#comment#update_interactive_comment_info()
  autocmd InsertLeave  * call doge#comment#deactivate_when_done()
  autocmd TextChanged  * call doge#comment#deactivate_when_done()
  autocmd FileType     * call doge#on_filetype_change()
augroup END

let &cpoptions = s:save_cpo
unlet s:save_cpo
