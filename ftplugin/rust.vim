let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'rust'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['rustdoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('rs')

let &cpoptions = s:save_cpo
unlet s:save_cpo
