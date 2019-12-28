let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Run a python file using the py[3]file command.
function! doge#python#file(path, args) abort
  if has('python3')
    let l:python = 'python3'
    let l:pyfile = 'py3file'
  elseif has('python')
    let l:python = 'python'
    let l:pyfile = 'pyfile'
  else
    echoerr 'Vim is not compiled with Python3 or Python.'
  endif

  call execute(l:python . ' ' . 'sys.argv = [' . join(map(copy(a:args), { key, value -> '"' . value . '"' }), ', ') . ']', 'silent!')
  return doge#helpers#trim(execute(l:pyfile . ' ' . a:path, 'silent!'))
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
