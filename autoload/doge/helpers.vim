let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#helpers#count(word, ...) abort
  let l:cursor_pos = getpos('.')
  let l:range = '%'
  if (type(a:1) == v:t_number && type(a:2) == v:t_number) && (a:1 < a:2)
    let l:range = printf('%s,%s', a:1, a:2)
  endif
  try
    let l:cnt = execute(l:range . 's/' . a:word . '//gn')
  catch /E486: Pattern not found/
    return 0
  endtry
  call setpos('.', l:cursor_pos)
  return trim(strpart(l:cnt, 0, stridx(l:cnt, ' ')))
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
