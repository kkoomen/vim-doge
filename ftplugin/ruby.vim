" ==============================================================================
" The Ruby documentation should follow the 'YARD' conventions.
" see https://www.rubydoc.info/gems/yard/file/docs/Tags.md
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'ruby'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['YARD'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('ruby')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular function expressions and class methods.
" ------------------------------------------------------------------------------
let s:function_and_class_method_pattern = {
\  'nodeTypes': ['method', 'singleton_method'],
\  'parameters': {
\    'format': '@param {name} [!type] !description',
\  },
\}

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('YARD', [
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'template': [
\      '# !description',
\      '%(parameters|# {parameters})%',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
