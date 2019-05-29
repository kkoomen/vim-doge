let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Check whether two comments differ from each other by comparing them.
function! doge#comment#has_changed(old_comment, new_comment, should_trim) abort
  " Return immediately if the lenght is already differnt.
  if len(a:old_comment) isnot len(a:new_comment)
    return 1
  endif

  " If the length is the same we want to check whether all the values are equal.
  for l:old_line in a:old_comment
    let l:old_line_idx = index(a:old_comment, l:old_line)
    let l:new_line = get(a:new_comment, l:old_line_idx)
    if a:should_trim is 1
      if trim(l:old_line) !=# trim(l:new_line)
        return 1
      endif
    else
      if l:old_line !=# l:new_line
        return 1
      endif
    endif
  endfor

  return 0
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
