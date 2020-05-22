let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#preprocessors#typescript#tokens(tokens) abort
  if has_key(a:tokens, 'returnType')
    if a:tokens['returnType'] ==# 'void'
      let a:tokens['returnType'] = ''
    elseif empty(a:tokens['returnType'])
      let a:tokens['returnType'] = '!type'
    endif
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
