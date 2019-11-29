" ==============================================================================
" The Lua documentation should follow the 'LDoc' conventions.
" see https://github.com/stevedonovan/LDoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m--\+\([[\)\@!.\{-}$'
let b:doge_pattern_multi_line_comment = '\m--\+[[.\{-}]]--\+'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['ldoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('lua')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\([^,]\+\)',
\    'tokens': ['name'],
\    'format': '@param {name} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular function expressions and class methods.
" ------------------------------------------------------------------------------
" function new_function(p1, p2, p3, p4)
" local function new_function(p1, p2, p3)
" function BotDetectionHandler:access(p1, p2, p3)
" function a.b:c (p1, p2) body end
" a.b.c = function (self, p1, p2) body end
" ------------------------------------------------------------------------------
let s:function_and_class_method_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(local\s*\)\?function\s*\%([[:alnum:]_:.]\+[:.]\)\?\%([[:alnum:]_]\+\)\s*(\(.\{-}\))',
\  'tokens': ['parameters'],
\})

" ------------------------------------------------------------------------------
" Matches regular function expressions as a variable value.
" ------------------------------------------------------------------------------
" myprint = function(p1, p2)
" local myprint = function(p1, p2, p3, p4, p5)
" ------------------------------------------------------------------------------
let s:variable_function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(local\s*\)\?\%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*=\s*\%(\s*function\s*\)\?(\(.\{-}\))',
\  'tokens': ['funcName', 'parameters'],
\})

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
\  doge#helpers#deepextend(s:variable_function_pattern, {
\    'template': [
\      '-- !summary',
\      '-- !description',
\      '%(parameters|-- {parameters})%',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
