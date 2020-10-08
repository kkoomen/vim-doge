let s:save_cpo = &cpoptions
set cpoptions&vim

" The testing framework Vader is running everything inside a single buffer, so
" we disable the inheritance of some buffer-local variables to prevent extra
" work and/or failing tests.

""
" @public
" Returns a bool whether the current buffer is a supported filetype.
function! doge#buffer#initialized() abort
  return exists('b:doge_supported_doc_standards') == v:true
endfunction

""
" @public
" 'defaults': A list of supported doc standards that should be allowed.
" Returns a list of accepted doc standards.
function! doge#buffer#get_supported_doc_standards(defaults) abort
  " We sort them so that we can use uniq() on it.
  let l:docs = uniq(sort(extend(copy(get(b:, 'doge_supported_doc_standards', [])), a:defaults)))

  " After sorted it, we will remove the defaults and prepend the defaults so
  " that we can reset the order as we defined it in the ftplugin/{ft}.vim.
  for l:default in a:defaults
    call remove(l:docs, index(l:docs, l:default))
  endfor

  " Prepend the defaults to the filtered docs list.
  return extend(a:defaults, l:docs)
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

""
" @public
" Returns the b:doge_patterns variable value.
function! doge#buffer#get_patterns() abort
  return get(g:, 'doge_test_env', 0)
    \ ? {}
    \ : get(b:, 'doge_patterns', {})
endfunction

""
" @public
" Add a doc standard to the b:doge_patterns variable.
function! doge#buffer#register_doc_standard(doc_standard, patterns) abort
  let b:doge_patterns[a:doc_standard] = a:patterns
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
