let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Indent a string based on a given line its indent.
function! doge#indent#add(text, lnum)
  if &expandtab
    return repeat(' ', indent(a:lnum)) . a:text
  else
    return repeat("\t", indent(a:lnum) / shiftwidth()) . a:text
  endif
endfunction

""
" @public
" Remove indent based on a given line its indent.
function! doge#indent#remove(text, lnum)
  if &expandtab
    return substitute(a:text, repeat(' ', indent(a:lnum)), '', '')
  else
    return substitute(a:text, repeat("\t", indent(a:lnum) / shiftwidth()), '', '')
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
