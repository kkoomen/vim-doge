" ==============================================================================
" The JavaScript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'typescript'
let b:doge_insert = 'above'

if !exists('g:doge_javascript_settings')
  let g:doge_javascript_settings = {
  \  'destructuring_props': 1,
  \  'omit_redundant_param_types': 0,
  \}
endif

let b:doge_supported_doc_standards = ['jsdoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('javascript')

let &cpoptions = s:save_cpo
unlet s:save_cpo
