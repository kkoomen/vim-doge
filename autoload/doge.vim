let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Generates documentation based on available patterns in b:doge_patterns.
"
" arg: Either a count (0 by default) or a string (empty by default).
function! doge#generate(arg) abort
  if doge#buffer#initialized() == v:false
    return 0
  endif

  " Immediately validate if the doc standard is allowed.
  if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
    echoerr printf(
    \  '[DoGe] "%s" is not a valid %s doc standard, available doc standard are: %s',
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

  if exists('b:doge_patterns')
    for l:pattern in get(b:doge_patterns, b:doge_doc_standard)
      if doge#pattern#generate(l:pattern) == v:false
        continue
      endif

      call doge#activate()
      return 1
    endfor
  endif
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
" This function will be triggered on the FileType autocmd and will:
" - apply aliases
" - remove conflicting doc standards from the previous filetype.
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

  " Remove conflicting doc standards from the previous filetype.
  if !exists('b:doge_prev_supported_doc_standards')
    \ && exists('b:doge_supported_doc_standards')
    " Save the current supported doc standards
    let b:doge_prev_supported_doc_standards = copy(get(b:, 'doge_supported_doc_standards', []))
    let b:doge_prev_ft = &filetype
  elseif exists('b:doge_prev_supported_doc_standards')
    \ && exists('b:doge_supported_doc_standards')
    \ && get(b:, 'doge_prev_ft', '') != &filetype
    " Remove all the doc standards from the previous filetype.
    " If the current filetype is not an alias of the previous filetype then we
    " will remove the doc standard.
    for l:doc in get(b:, 'doge_prev_supported_doc_standards', [])
      let l:is_alias = 0

      if (has_key(g:doge_filetype_aliases, &filetype) && index(get(g:doge_filetype_aliases, &filetype, []), b:doge_prev_ft) >= 0)
            \ || (has_key(g:doge_filetype_aliases, b:doge_prev_ft) && index(get(g:doge_filetype_aliases, b:doge_prev_ft, []), &filetype) >= 0)
        let l:is_alias = 1
      endif

      if l:is_alias == v:false
        for [l:ft, l:aliases] in items(get(g:, 'doge_filetype_aliases'))
          if index(l:aliases, &filetype) >= 0 && index(l:aliases, b:doge_prev_ft) >= 0
            let l:is_alias = 1
            break
          endif
        endfor
      endif

      if l:is_alias == v:false
        let l:doc_idx = index(b:doge_supported_doc_standards, l:doc)
        if l:doc_idx >= 0 && b:doge_prev_supported_doc_standards != b:doge_supported_doc_standards
          call remove(b:doge_supported_doc_standards, l:doc_idx)
          if has_key(get(b:, 'doge_patterns', {}), l:doc)
            unlet b:doge_patterns[l:doc]
          endif
        endif
      endif
    endfor
    let b:doge_prev_supported_doc_standards = copy(b:doge_supported_doc_standards)
    let b:doge_prev_ft = &filetype
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
        echom '[DoGe] already using latest version, skipping binary download'
        return 0
      endif
    endif
  endfor

  function! s:report_result(exitcode) abort
    if a:exitcode == 0
      echom '[DoGe] installed sucessfully'
    else
      echohl ErrorMsg
      echom '[DoGe] installation failed ' . '(exit code: ' . a:exitcode . ')'
      echohl None
    endif
  endfunction

  if has('win32')
    let l:command = (executable('pwsh.exe') ? 'pwsh.exe' : 'powershell.exe')
    let l:command .= ' -Command ' . shellescape('Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force; & ' . shellescape(g:doge_dir . '/scripts/install.ps1'))
    let l:term_height = 8
  else
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
    exe (&splitbelow ? 'botright' : 'topleft') . " call term_start(l:command, {'term_rows': " . l:term_height . ", 'close_cb': function('s:callback')})"
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
