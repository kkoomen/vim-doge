" ==============================================================================
" The Ruby documentation should follow the 'YARD' conventions.
" see https://www.rubydoc.info/gems/yard/file/docs/Tags.md
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'ruby'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['YARD']
let b:doge_doc_standard = doge#buffer#get_doc_standard('ruby')

let &cpoptions = s:save_cpo
unlet s:save_cpo
