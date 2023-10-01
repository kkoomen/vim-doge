let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'svelte'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['jsdoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('svelte')

let &cpoptions = s:save_cpo
unlet s:save_cpo
