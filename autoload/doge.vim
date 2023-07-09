let s:save_cpo = &cpoptions
set cpoptions&vim

let s:comment_placeholder = doge#helpers#placeholder()

""
" @public
" Run a parser which will produce all the parameters and return the output.
function! doge#run_parser() abort
  let l:executables = [
        \ '/helper/target/release/vim-doge-helper',
        \ '/bin/vim-doge-helper',
        \ ]

  for l:executable in l:executables
    let l:script_path = g:doge_dir . l:executable
    if filereadable(resolve(l:script_path))
      let l:cursor_pos = getpos('.')
      let l:current_line = l:cursor_pos[1]

      let l:tempfile = tempname()
      keepjumps call execute('%!tee ' . l:tempfile, 'silent!')

      let l:args = [
            \ '--filepath', l:tempfile,
            \ '--parser', b:doge_parser,
            \ '--doc-name', b:doge_doc_standard,
            \ '--line', l:current_line,
            \ ]

      if &expandtab == v:true
        let l:args += ['--indent', shiftwidth()]
      else
        let l:args += ['--tabs']
      endif

      " Call preprocessing function for the filetype, allowing it to add args.
      try
        let l:preprocess_fn = printf('doge#preprocessors#%s#alter_parser_args', doge#helpers#get_filetype())
        let l:new_args = function(l:preprocess_fn)(l:args)
        let l:args = l:new_args
      catch /^Vim\%((\a\+)\)\=:E117/
      endtry

      let l:result = system(l:script_path . ' ' . join(l:args, ' '))

      try
        if !empty(l:result)
          return json_decode(l:result)
        endif
      catch /.*/
        echo g:doge_prefix . ' ' . b:doge_parser . ' parser failed'
        echo g:doge_prefix . ' Exception: ' . v:exception
        echo l:result
      finally
        call setpos('.', l:cursor_pos)
        call delete(l:tempfile)
      endtry
    endif
  endfor

  return 0
endfunction

""
" @public
" Main function used for generating documentation.
"
" arg: Either a count (0 by default) or a string (empty by default).
function! doge#generate(arg) abort
  " Immediately validate if the doc standard is allowed.
  if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
    echoerr printf(
    \  '%s "%s" is not a valid %s doc standard, available doc standard are: %s',
    \  g:doge_prefix,
    \  b:doge_doc_standard,
    \  &filetype,
    \  string(b:doge_supported_doc_standards)
    \)
  endif

  " Store old search register.
  let s:oldsearch = @/

  " If the command is run with a count or a string as argument, the user is
  " requesting for a specific doc standard.
  " If no matching standards are found, or no arg (count or string) is given,
  " just use whatever is currently set.
  if exists('b:doge_supported_doc_standards')
    if type(a:arg) ==# type(0) && a:arg != 0
      if a:arg <= len(b:doge_supported_doc_standards)
        let b:doge_doc_standard = b:doge_supported_doc_standards[a:arg - 1]
      endif
    elseif type(a:arg) ==# type('') && !empty(a:arg)
      if index(b:doge_supported_doc_standards, a:arg) >= 0
        let b:doge_doc_standard = a:arg
      endif
    endif
  endif

  let l:parser_result = doge#run_parser()
  if type(l:parser_result) != v:t_dict
    return 0
  endif

  let l:comment = copy(l:parser_result['docblock'])
  let l:comment_lnum_insert_position = l:parser_result['line']

  " Determine the line num where to insert the comment.
  if b:doge_insert ==# 'below'
    let l:comment_indent = shiftwidth()
  else
    let l:comment_indent = 0
    let l:comment_lnum_insert_position = l:parser_result['line'] - 1
  endif

  " vint: next-line -ProhibitUnusedVariable
  let l:Indent = function('doge#indent#add', [l:comment_indent])

  " Indent the comment.
  let l:comment = map(l:comment, { k, line -> l:Indent(line) })

  " Write the comment.
  call append(l:comment_lnum_insert_position, l:comment)

  " Enable interactive mode.
  if g:doge_comment_interactive == v:true
    if b:doge_insert ==# 'below'
      let l:todo_match = search(s:comment_placeholder, 'nW', l:comment_lnum_insert_position + len(l:comment))
    else
      let l:todo_match = search(s:comment_placeholder, 'bnW', l:comment_lnum_insert_position + 1)
    endif
    if l:todo_match != 0
      let l:todo_count = doge#helpers#count(
            \ s:comment_placeholder,
            \ (l:comment_lnum_insert_position + 1),
            \ (l:comment_lnum_insert_position + len(l:comment))
            \ )
      if l:todo_count > 0
        let b:doge_interactive = {
              \ 'comment': l:comment,
              \ 'lnum_comment_start_pos': (l:comment_lnum_insert_position + 1),
              \ 'lnum_comment_end_pos': (l:comment_lnum_insert_position + len(l:comment)),
              \ }
        " Go to the top of the comment and select the first TODO.
        exe l:comment_lnum_insert_position + 1
        call search(s:comment_placeholder, 'W')
        call execute("normal! gno\<C-g>", 'silent!')
      endif
    endif
  endif

  " Activate doge buffer mappings.
  call doge#activate()

  return 1
endfunction

""
" @public
" Activate doge buffer mappings, if option is set.
function! doge#activate() abort
  " Ensure lazyredraw is enabled.
  if get(g:, 'doge_lazyredraw', 1) && &lazyredraw == v:false
    set lazyredraw
    let s:doge_lazyredraw = 1
  endif

  if g:doge_comment_interactive == v:false || g:doge_buffer_mappings == v:false
    return
  endif

  let [l:f, l:b] = [
        \ g:doge_mapping_comment_jump_forward,
        \ g:doge_mapping_comment_jump_backward,
        \ ]
  for l:mode in g:doge_comment_jump_modes
    call execute(printf('%smap <nowait> <silent> <buffer> %s <Plug>(doge-comment-jump-forward)', l:mode, l:f), 'silent!')
    call execute(printf('%smap <nowait> <silent> <buffer> %s <Plug>(doge-comment-jump-backward)', l:mode, l:b), 'silent!')
  endfor
endfunction

""
" @public
" Deactivate doge mappings and unlet buffer variable.
" Can print a message with the reason of deactivation/termination.
function! doge#deactivate() abort
  " Disable lazyredraw if it was previously enabled.
  if exists('s:doge_lazyredraw')
    set nolazyredraw
    unlet s:doge_lazyredraw
  endif
  unlet b:doge_interactive

  " Restore saved search register.
  let @/ = s:oldsearch

  if g:doge_comment_interactive == v:false || g:doge_buffer_mappings == v:false
    return
  endif

  let [l:f, l:b] = [
        \ g:doge_mapping_comment_jump_forward,
        \ g:doge_mapping_comment_jump_backward,
        \ ]
  for l:mode in g:doge_comment_jump_modes
    call execute(printf('%sunmap <buffer> %s', l:mode, l:f), 'silent!')
    call execute(printf('%sunmap <buffer> %s', l:mode, l:b), 'silent!')
  endfor
endfunction

""
" @public
" Return a list of supported doc standards for the current buffer.
function! doge#command_complete(...) abort
  return filter(copy(get(b:, 'doge_supported_doc_standards', [])), "v:val =~ '^'.a:1")
endfunction

""
" @public
" This function will be triggered on the FileType autocmd and will apply aliases
function! doge#on_filetype_change() abort
  " Check if the current filetype is an alias, if so, initialize that filetype.
  if get(g:, 'doge_ignore_on_filetype_change', 0) == v:true
    return 0
  else
    let l:orig_ft = &filetype
    for [l:ft, l:aliases] in items(get(g:, 'doge_filetype_aliases'))
      if index(l:aliases, l:orig_ft) >= 0
        let g:doge_ignore_on_filetype_change = 1
        execute('setlocal ft=' . l:ft)
        execute('setlocal ft=' . l:orig_ft)
        let g:doge_ignore_on_filetype_change = 0
        break
      endif
    endfor
  endif
endfunction

"" @public
" Install the necessary dependencies.
function! doge#install(...) abort
  for l:filename in ['vim-doge', 'vim-doge.exe']
    let l:filepath = g:doge_dir . '/bin/' . l:filename
    if filereadable(l:filepath)
      let l:binary_version = doge#helpers#trim(system(shellescape(l:filepath) . ' --version'))
      let l:local_version = doge#helpers#trim(readfile(g:doge_dir . '/.version')[0])
      if l:binary_version ==# l:local_version
        echom g:doge_prefix . ' already using latest version, skipping binary download'
        return 0
      endif
    endif
  endfor

  function! s:report_result(exitcode) abort
    if a:exitcode == 0
      echom g:doge_prefix . ' installed sucessfully'
    else
      echohl ErrorMsg
      echom g:doge_prefix . ' installation failed ' . '(exit code: ' . a:exitcode . ')'
      echohl None
    endif
  endfunction

  if has('win32')
    let l:command = (executable('pwsh.exe') ? 'pwsh.exe' : 'powershell.exe')
    let l:command .= ' -Command ' . shellescape('Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force; & ' . shellescape(g:doge_dir . '/scripts/install.ps1'))
    let l:term_height = 8
  elseif has('osx') && trim(system('uname -m')) ==# 'arm64'
    echom g:doge_prefix . ' detected arm64 which requires manual install through NPM, installing now...'
    let l:command = 'cd ' . fnameescape(g:doge_dir) . ' && npm i --no-save && npm run build:binary:unix'
    let l:term_height = 10
  else
    " macos x64
    let l:command = fnameescape(g:doge_dir) . '/scripts/install.sh'
    let l:term_height = 4
  endif

  if len(a:000) > 0
    if get(a:000[0], 'headless', 0)
      call system(l:command)
      call s:report_result(v:shell_error)
      return
    endif
  endif

  if has('nvim') && exists(':terminal') == 2
    " neovim with :terminal support
    " vint: next-line -ProhibitUnusedVariable
    function! s:callback(...) abort
      if a:2 == 0 " exitcode
        " no errors to report, so delete buffer
        call execute(s:terminal_bufnr . 'bd!')
        unlet s:terminal_bufnr
      endif
      call s:report_result(a:2)
    endfun
    let l:winid = win_getid()
    exe (&splitbelow ? 'botright' : 'topleft') . l:term_height . 'sp'
    enew
    call termopen(l:command, {'on_exit': function('s:callback')})
    set nobuflisted
    let s:terminal_bufnr = bufnr()
    call win_gotoid(l:winid)
  elseif has('nvim')
    " Neovim does not show any stdout output if called with :call execute(),
    " therefore to show the download progress bar, we need to call execute() by
    " itself.
    execute('!' . l:command)
    call s:report_result(v:shell_error)
  elseif has('terminal')
    " vim with +terminal
    " vint: next-line -ProhibitUnusedVariable
    function! s:callback(channel) abort
      let l:exitcode = job_info(ch_getjob(a:channel)).exitval
      if l:exitcode == 0
      " no errors to report, so delete buffer
        execute(s:terminal_bufnr . 'bd!')
        unlet s:terminal_bufnr
      endif
      call s:report_result(l:exitcode)
    endfun
    let l:winid = win_getid()
    let s:term_buf = term_start(&shell, {'term_rows': l:term_height, 'close_cb': function('s:callback')})
    call term_sendkeys(s:term_buf, l:command . " && exit\<CR>")
    set nobuflisted
    let s:terminal_bufnr = bufnr()
    call win_gotoid(l:winid)

  else
    " vim without terminal support
    call execute('!' . l:command)
    call s:report_result(v:shell_error)
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
