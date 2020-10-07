" ==============================================================================
" The PHP documentation should follow the 'phpdoc' conventions.
" see https://www.phpdoc.org
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

if !exists('g:doge_php_settings')
  let g:doge_php_settings = {
  \  'resolve_fqn': 1,
  \}
endif

let b:doge_parser = 'php'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['phpdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('php')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================

call doge#buffer#register_doc_standard('phpdoc', [
\  {
\    'nodeTypes': ['property_declaration'],
\    'template': [
\      '/**',
\      ' * @var {type|!type}',
\      ' */',
\    ],
\  },
\  {
\    'nodeTypes': ['method_declaration', 'function_definition'],
\    'parameters': {
\      'format': '@param {type|!type} {name}%(default| (optional))% !description'
\    },
\    'exceptions': {
\      'format': '@throws {name|!name} !description'
\    },
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parameters| *)%',
\      '%(parameters| * {parameters})%',
\      '%(exceptions| *)%',
\      '%(exceptions| * {exceptions})%',
\      '%(isNoConstructorMethod| *)%',
\      '%(isNoConstructorMethod| * @return {returnType|!type} !description)%',
\      ' */',
\    ],
\  },
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
