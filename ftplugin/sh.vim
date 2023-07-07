" ==============================================================================
" The Shell documentation should follow the 'Google' conventions.
" see https://google.github.io/styleguide/shell.xml#Function_Comments
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'bash'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = 'google'
let b:doge_doc_standard = doge#buffer#get_doc_standard('sh')

let &cpoptions = s:save_cpo
unlet s:save_cpo
