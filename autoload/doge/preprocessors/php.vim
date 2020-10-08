let s:save_cpo = &cpoptions
set cpoptions&vim

" A callback function being called after the tokens have been extracted. This
" function will adjust the input if needed.
function! doge#preprocessors#php#tokens(tokens) abort
  " Resolve the property types based on the constructor
  if has_key(a:tokens, 'type') && !empty(a:tokens['type'])
        \ && has_key(a:tokens, 'fqn') && !empty(a:tokens['fqn'])
        \ && get(g:doge_php_settings, 'resolve_fqn')
    let a:tokens['type'] = a:tokens['fqn']
  endif

  if has_key(a:tokens, 'returnType') && !empty(a:tokens['returnType'])
        \ && has_key(a:tokens, 'returnTypeFQN') && !empty(a:tokens['returnTypeFQN'])
        \ && get(g:doge_php_settings, 'resolve_fqn')
    let a:tokens['returnType'] = a:tokens['returnTypeFQN']
  endif
endfunction

" A callback function being called after the parameter tokens have been
" extracted. This function will adjust the input if needed.
function! doge#preprocessors#php#parameters_tokens(tokens) abort
  for l:token in a:tokens
    let l:token_idx = index(a:tokens, l:token)
    if has_key(l:token, 'type') && !empty(l:token['type'])
      if has_key(l:token, 'fqn') && !empty(l:token['fqn']) && get(g:doge_php_settings, 'resolve_fqn')
        let a:tokens[l:token_idx]['type'] = a:tokens[l:token_idx]['fqn']
      endif

      if l:token['type'][0] ==# '?' && l:token['type'] !~? 'null'
        let a:tokens[l:token_idx]['type'] = a:tokens[l:token_idx]['type'][1:] . '|null'
      endif
    endif
  endfor
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
