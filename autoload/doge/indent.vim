let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Indent a string based on a given line its indent.
function! doge#indent#add(lnum, text) abort
  if &expandtab
    return repeat(' ', indent(a:lnum)) . a:text
  else
    return repeat("\t", indent(a:lnum) / shiftwidth()) . a:text
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
