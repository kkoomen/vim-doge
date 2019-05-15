" ==============================================================================
" Filename: comment.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#comment#has_changed(old_comment, new_comment) abort
  if len(a:old_comment) != len(a:new_comment)
    return 1
  endif

  for l:old_line in a:old_comment
    let l:old_line_idx = index(a:old_comment, l:old_line)
    let l:new_line = get(a:new_comment, l:old_line_idx)
    if trim(l:old_line) !=# trim(l:new_line)
      return 1
    endif
  endfor

  return 0
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
