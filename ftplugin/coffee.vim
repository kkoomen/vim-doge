" ==============================================================================
" The CoffeeScript documentation should follow the 'jsdoc' conventions, since
" there is no official CoffeeScript documentation.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#\@<!##\@!.\+$'
let b:doge_pattern_multi_line_comment = '\m###.\{-}###'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['jsdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('coffee')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'format': '@param {!type} {name} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================
let s:prototype_function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\([[:alnum:]_$]\+\)::\([[:alnum:]_$]\+\)\s*=\s*[-=]>',
\  'tokens': ['className', 'funcName'],
\})

let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\([[:alnum:]_$]\+\)\s*=\s*(\(.\{-}\))\s*[-=]>',
\  'tokens': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\([^,]\+\)',
\    'tokens': ['name'],
\  },
\})

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('jsdoc', [
\  doge#helpers#deepextend(s:prototype_function_pattern, {
\    'template': [
\      '###',
\      '!description',
\      '',
\      '@function {className}#{funcName}',
\      '###',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '###',
\      '!description',
\      '',
\      '@function {funcName|}',
\      '%(parameters|{parameters})%',
\      '###',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
