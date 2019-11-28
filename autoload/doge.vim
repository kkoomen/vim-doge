let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Generates documentation based on available patterns in b:doge_patterns.
"
" arg: Either a count (0 by default) or a string (empty by default).
function! doge#generate(arg) abort
  let l:success = 0

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
    elseif type(a:arg) ==# type('') && a:arg !=# ''
      if index(b:doge_supported_doc_standards, a:arg) >= 0
        let b:doge_doc_standard = a:arg
      endif
    endif
  endif

  if exists('b:doge_patterns')
    for l:pattern in get(b:doge_patterns, b:doge_doc_standard)
      if doge#generate#pattern(l:pattern) == v:false
        continue
      else
        let l:success = v:true
      endif
      if l:success == v:true
        call doge#activate()
      endif
      return l:success
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
    execute(printf('%smap <nowait> <silent> <buffer> %s <Plug>(doge-comment-jump-forward)', l:mode, l:f))
    execute(printf('%smap <nowait> <silent> <buffer> %s <Plug>(doge-comment-jump-backward)', l:mode, l:b))
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
    execute(printf('%sunmap <buffer> %s', l:mode, l:f))
    execute(printf('%sunmap <buffer> %s', l:mode, l:b))
  endfor
endfunction

""
" @public
" Return a list of supported doc standards for the current buffer.
function! doge#command_complete(...) abort
  return filter(copy(get(b:, 'doge_supported_doc_standards', [])), "v:val =~ '^'.a:1")
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
