let s:save_cpo = &cpoptions
set cpoptions&vim

if v:version < 800 || (v:version == 800 && !has('patch1630'))
  echohl WarningMsg
  echo '[DoGe] Unsupported version. Vim v8.0.1630+ is required.'
  echohl None
  finish
endif

" section Introduction, intro {{{

""
" @section Introduction, intro
" We all love documentation because it makes our codebases easier to understand,
" yet no one has time to write it in a good and proper way or some might not
" even like to write it.
"
" DoGe is a [Do]cumentation [Ge]nerator which will generate instant
" proper documentation based on the function declaration. You can simply put
" your cursor on a function, press `<C-d>`, add brief descriptions and go on
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
"   doge#preprocessors#<filetype>#parameter_tokens(tokens)
"
"   doge#preprocessors#<filetype>#insert_position(lnum_insert_pos)

" }}}

if exists('g:loaded_doge')
  finish
endif
let g:loaded_doge = 1

if !exists('g:doge_mapping')
  ""
  " (Default: '<C-d>')
  "
  " The mapping to trigger DoGe.
  let g:doge_mapping = '<C-d>'
endif

if !exists('g:doge_mapping_comment_jump_forward')
  ""
  " (Default: '<TAB>')
  "
  " The mapping to jump forward to the next TODO item in a comment.
  " Required @settings(g:doge_comment_interactive) to be enabled.
  let g:doge_mapping_comment_jump_forward = '<TAB>'
endif

if !exists('g:doge_mapping_comment_jump_backward')
  ""
  " (Default: '<S-TAB>')
  "
  " The mapping to jump backward to the previous TODO item in a comment.
  " Required @settings(g:doge_comment_interactive) to be enabled.
  let g:doge_mapping_comment_jump_backward = '<S-TAB>'
endif

if !exists('g:doge_comment_todo_suffix')
  ""
  " (Default: 1)
  "
  " Adds the TODO suffix after every generated parameter.
  let g:doge_comment_todo_suffix = 1
endif

if !exists('g:doge_comment_interactive')
  ""
  " (Default: 1)
  "
  " Jumps interactively through all TODO items.
  let g:doge_comment_interactive = 1
endif

nnoremap <Plug>(doge-generate) :call doge#generate()<CR>
execute(printf('nmap %s <Plug>(doge-generate)', g:doge_mapping))

nnoremap <Plug>(doge-comment-jump-forward) :call doge#comment#jump_forward()<CR>
inoremap <Plug>(doge-comment-jump-forward) <C-R>=doge#comment#jump_forward()<CR>
snoremap <Plug>(doge-comment-jump-forward) <ESC>:call doge#comment#jump_forward()<CR>
nnoremap <Plug>(doge-comment-jump-backward) :call doge#comment#jump_backward()<CR>
inoremap <Plug>(doge-comment-jump-backward) <C-R>=doge#comment#jump_backward()<CR>
snoremap <Plug>(doge-comment-jump-backward) <ESC>:call doge#comment#jump_backward()<CR>

execute(printf('nmap <silent> <unique> %s <Plug>(doge-comment-jump-forward)', g:doge_mapping_comment_jump_forward))
execute(printf('imap <silent> <unique> %s <Plug>(doge-comment-jump-forward)', g:doge_mapping_comment_jump_forward))
execute(printf('smap <silent> <unique> %s <Plug>(doge-comment-jump-forward)', g:doge_mapping_comment_jump_forward))
execute(printf('nmap <silent> <unique> %s <Plug>(doge-comment-jump-backward)', g:doge_mapping_comment_jump_backward))
execute(printf('imap <silent> <unique> %s <Plug>(doge-comment-jump-backward)', g:doge_mapping_comment_jump_backward))
execute(printf('smap <silent> <unique> %s <Plug>(doge-comment-jump-backward)', g:doge_mapping_comment_jump_backward))

augroup doge
  autocmd TextChangedI * call doge#comment#update_interactive_comment_info()
augroup END

let &cpoptions = s:save_cpo
unlet s:save_cpo
