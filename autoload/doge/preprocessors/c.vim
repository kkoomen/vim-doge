let s:save_cpo = &cpoptions
set cpoptions&vim

" A callback function being called after the tokens have been extracted. This
" function will adjust the input if needed.
function! doge#preprocessors#c#tokens(tokens) abort
  " Unset the returnType when the type is 'void'.
  " See https://github.com/kkoomen/vim-doge/issues/5
  if has_key(a:tokens, 'returnType') && !empty(a:tokens['returnType']) && a:tokens['returnType'] ==# 'void'
    let a:tokens['returnType'] = ''
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
