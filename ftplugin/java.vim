" ==============================================================================
" The Java documentation should follow the 'JavaDoc' conventions.
" see https://www.oracle.com/technetwork/articles/javase/index-137868.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['javadoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('java')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'format': '@param {name} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================
let s:class_method_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s*\)*\%(\%(\([[:alnum:]_]\+\)\?\s*\%(<[[:alnum:][:space:]_,]*>\)\?\)\?\s\+\)\?\%([[:alnum:]_]\+\)(\(.\{-}\))\s*[;{]',
\  'tokens': ['returnType', 'parameters'],
\  'parameters': {
\    'match': '\m\%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]\+>\)\?\)\%(\s\+[.]\{3}\s\+\|\s\+[.]\{3}\|[.]\{3}\s\+\|\s\+\)\([[:alnum:]_]\+\)',
\    'tokens': ['type', 'name'],
\  },
\})

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
\      '%(returnType| * @return !description)%',
\      ' */',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
