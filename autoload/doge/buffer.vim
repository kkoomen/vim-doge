let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" 'filetype': The filetype where we initialized the b:doge_doc_standard.
" Returns the current active doc standard.
function! doge#buffer#get_doc_standard(filetype) abort
  return get(g:, 'doge_test_env', 0)
    \ ? b:doge_supported_doc_standards[0]
    \ : get(b:, 'doge_doc_standard', get(g:, 'doge_doc_standard_' . a:filetype, b:doge_supported_doc_standards[0]))
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
