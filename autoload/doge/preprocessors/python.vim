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

" Alter the template for Python functions.
function! doge#preprocessors#python#template(template) abort
  if get(g:doge_python_settings, 'single_quotes')
    for l:line in a:template
      let l:line_idx = index(a:template, l:line)
      let a:template[l:line_idx] = substitute(l:line, '\m"', "'", 'g')
    endfor
  endif
endfunction

function! doge#preprocessors#python#tokens(tokens) abort
  if has_key(a:tokens, 'parameters') && !empty(a:tokens['parameters'])
    " omit redundant param types
    for l:param in a:tokens['parameters']
      let l:param['showType'] = v:true
      if get(g:doge_python_settings, 'omit_redundant_param_types') == v:true &&
            \ has_key(l:param, 'type') == v:true &&
            \ !empty(l:param['type'])
        let l:param['showType'] = v:false
        let l:param['default'] = ''
      endif
    endfor
  endif

  " Show the return type based on the 'omit_redundant_param_types' setting.
  let a:tokens['showReturnType'] = v:false
  if (has_key(a:tokens, 'returnType') == v:true && !empty(a:tokens['returnType']))
        \ && get(g:doge_python_settings, 'omit_redundant_param_types') == v:false
    let a:tokens['showReturnType'] = v:true
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
