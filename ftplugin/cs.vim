" ==============================================================================
" The PHP documentation should follow the 'phpdoc' conventions.
" see https://www.phpdoc.org
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'java'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['csxml'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('cs')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================

call doge#buffer#register_doc_standard('csxml', [
\  {
\    'nodeTypes': ['method_declaration'],
\    'parameters': {
\      'format': '<param name="{name}"> !description</param>'
\    },
\    'template': [
\      '/// <summary>',
\      '/// !description',
\      '/// </summary>',
\      '%(parameters|/// {parameters})%',
\      '%(isNoConstructorMethod|/// <retrurns>!description</returns>',
\    ],
\  },
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
