let s:save_cpo = &cpoptions
set cpoptions&vim

if !exists('g:doge_php_settings')
  let g:doge_php_settings = {
  \  'resolve_fqn': 1,
  \}
endif

let b:doge_parser = 'php'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['phpdoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('php')

let &cpoptions = s:save_cpo
unlet s:save_cpo
