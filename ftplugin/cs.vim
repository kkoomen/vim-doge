let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'csharp'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['xmldoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('cs')

let &cpoptions = s:save_cpo
unlet s:save_cpo
