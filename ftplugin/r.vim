let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'r'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['roxygen2']
let b:doge_doc_standard = doge#buffer#get_doc_standard('r')

let &cpoptions = s:save_cpo
unlet s:save_cpo
