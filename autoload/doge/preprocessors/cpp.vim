let s:save_cpo = &cpoptions
set cpoptions&vim

" A callback function being called after the tokens have been extracted. This
" function will adjust the input if needed.
function! doge#preprocessors#cpp#tokens(tokens) abort
  " See https://github.com/kkoomen/vim-doge/issues/5
  if has_key(a:tokens, 'returnType') && !empty(a:tokens['returnType']) && a:tokens['returnType'] ==# 'void'
    let a:tokens['returnType'] = ''
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
