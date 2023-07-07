" ==============================================================================
" The Lua documentation should follow the 'LDoc' conventions.
" see https://github.com/stevedonovan/LDoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'lua'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['ldoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('lua')

let &cpoptions = s:save_cpo
unlet s:save_cpo
