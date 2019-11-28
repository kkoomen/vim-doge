let s:save_cpo = &cpoptions
set cpoptions&vim

" The testing framework Vader is running everything inside a single buffer, so
" we disable the inheritance of the b:doge_supported_doc_standards variable to
" prevent extra work and/or failing tests.

""
" @public
" 'defaults': A list of supported doc standards that should be allowed.
" Returns a list of accepted doc standards.
function! doge#buffer#get_supported_doc_standards(defaults) abort
  return get(g:, 'doge_test_env', 0)
    \ ? a:defaults
    \ : uniq(extend(get(b:, 'doge_supported_doc_standards', []), a:defaults))
endfunction

""
" @public
" 'filetype': The filetype where we initialized the b:doge_doc_standard.
" Returns the current active doc standard.
function! doge#buffer#get_doc_standard(filetype) abort
  return get(g:, 'doge_test_env', 0)
    \ ? b:doge_supported_doc_standards[0]
    \ : get(b:, 'doge_doc_standard', get(g:, 'doge_doc_standard_' . a:filetype, b:doge_supported_doc_standards[0]))
endfunction

function! doge#buffer#get_patterns() abort
  return get(g:, 'doge_test_env', 0)
    \ ? {}
    \ : get(b:, 'doge_patterns', {})
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
