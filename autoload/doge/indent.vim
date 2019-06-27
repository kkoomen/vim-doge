let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Indent a string based on a given line its indent, based on the user setting.
function! doge#indent#add(lnum, text) abort
  if &expandtab
    return repeat(' ', indent(a:lnum)) . a:text
  else
    return repeat("\t", indent(a:lnum) / shiftwidth()) . a:text
  endif
endfunction

""
" @public
" Convert spaces to tabs and tabs to spaces based on the user setting.
function! doge#indent#convert(text) abort
  if &expandtab
    return substitute(a:text, "\t", repeat(' ', shiftwidth()), 'g')
  else
    return substitute(a:text, repeat(' ', shiftwidth()), "\t", 'g')
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
