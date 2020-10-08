" ==============================================================================
" The Java documentation should follow the 'JavaDoc' conventions.
" see https://www.oracle.com/technetwork/articles/javase/index-137868.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'java'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['javadoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('java')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================
let s:class_method_pattern = {
\  'nodeTypes': ['method_declaration'],
\  'parameters': {
\    'format': '@param {name} !description',
\  },
\  'exceptions': {
\    'format': '@throws {name} !description',
\  },
\}

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('javadoc', [
\  doge#helpers#deepextend(s:class_method_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parameters| *)%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| *)%',
\      '%(returnType| * @return !description)%',
\      '%(exceptions| *)%',
\      '%(exceptions| * {exceptions})%',
\      ' */',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
