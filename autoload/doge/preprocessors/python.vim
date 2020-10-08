let s:save_cpo = &cpoptions
set cpoptions&vim

" Alter the template for Python functions.
function! doge#preprocessors#python#template(template) abort
  if get(g:doge_python_settings, 'single_quotes')
    for l:line in a:template
      let l:line_idx = index(a:template, l:line)
      let a:template[l:line_idx] = substitute(l:line, '\m"', "'", 'g')
    endfor
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
