let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#comment#has_changed(old_comment, new_comment) abort
  " Return immediately if the lenght is already differnt.
  if len(a:old_comment) != len(a:new_comment)
    return 1
  endif

  " If the length is the same we want to check whether all the values are equal.
  for l:old_line in a:old_comment
    let l:old_line_idx = index(a:old_comment, l:old_line)
    let l:new_line = get(a:new_comment, l:old_line_idx)
    if l:old_line !=# l:new_line
      return 1
    endif
  endfor

  return 0
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
