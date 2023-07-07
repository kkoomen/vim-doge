" ==============================================================================
" The Java documentation should follow the 'JavaDoc' conventions.
" see https://www.oracle.com/technetwork/articles/javase/index-137868.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'java'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['javadoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('java')

let &cpoptions = s:save_cpo
unlet s:save_cpo
