let s:save_cpo = &cpoptions
set cpoptions&vim

" Alter the insert position for Java functions.
function! doge#preprocessors#python#insert_position(lnum_insert_pos) abort
  " Python can be declared multiline and since the code will be inserted 'below'
  " the declaration we we have to adjust the lnum.

  " We will search for the pattern: ')<return-type>?:' to find out the end of
  " the declaration.
  let l:match_pos = searchpos(')\%(\s*->\s*.\{-}\)\?\s*:', 'nWe')
  if l:match_pos[0] > 0
    return l:match_pos[0]
  endif

  return a:lnum_insert_pos
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
