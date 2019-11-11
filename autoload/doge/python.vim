let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#python#file(path) abort
  if has('python3')
    let l:python = 'py3file'
  elseif has('python')
    let l:python = 'pyfile'
  else
    echoerr 'Vim is not compiled with Python3 or Python.'
  endif

  return doge#helpers#trim(execute(l:python . ' ' . a:path))
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
