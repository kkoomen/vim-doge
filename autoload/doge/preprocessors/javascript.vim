let s:save_cpo = &cpoptions
set cpoptions&vim

" A callback function being called after the tokens have been extracted. This
" function will adjust the input if needed.
function! doge#preprocessors#javascript#tokens(tokens) abort
  if has_key(a:tokens, 'returnType')
    if a:tokens['returnType'] ==# 'void'
      let a:tokens['returnType'] = ''
    elseif empty(a:tokens['returnType'])
      let a:tokens['returnType'] = '!type'

      " When we're dealing with an async function the return type is Promise<T>.
      " Only wrap the return type in a Promise when the type is not specified.
      if has_key(a:tokens, 'async') && !empty(a:tokens['async'])
        let a:tokens['returnType'] = 'Promise<' . a:tokens['returnType'] . '>'
      endif
    endif
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
