let s:save_cpo = &cpoptions
set cpoptions&vim

" The HTML filetype also gets triggerred for PHP files (and perhaps others).
if &filetype !=? 'html'
  finish
endif

let b:doge_parser = 'html'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['jsdoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('html')

let &cpoptions = s:save_cpo
unlet s:save_cpo
