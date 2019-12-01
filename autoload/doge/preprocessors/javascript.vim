let s:save_cpo = &cpoptions
set cpoptions&vim

" A callback function being called after the tokens have been extracted. This
" function will adjust the input if needed.
function! doge#preprocessors#javascript#tokens(tokens) abort
  if has_key(a:tokens, 'returnType')
    if a:tokens['returnType'] ==# 'void'
      let a:tokens['returnType'] = ''
    elseif a:tokens['returnType'] ==# ''
      let a:tokens['returnType'] = '!type'
    endif
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
