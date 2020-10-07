" ==============================================================================
" The Lua documentation should follow the 'LDoc' conventions.
" see https://github.com/stevedonovan/LDoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'lua'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['ldoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('lua')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular function expressions, definitions and class methods.
" ------------------------------------------------------------------------------
let s:function_and_class_method_pattern = {
\  'nodeTypes': ['function', 'function_definition'],
\  'parameters': {
\    'format': '@param {name} !description',
\  },
\}

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('ldoc', [
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'template': [
\      '-- !summary',
\      '-- !description',
\      '%(parameters|-- {parameters})%',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
