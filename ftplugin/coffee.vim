" ==============================================================================
" The coffeescript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" ==============================================================================
" Matches prototype functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   Person::greet = (name) ->
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_$]\+\)::\([[:alnum:]_$]\+\)\s*=\s*[-=]>',
\  'match_group_names': ['className', 'funcName'],
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '###',
\      '@description TODO',
\      '@function {className}#{funcName}',
\      '!@return {{returnType}} TODO',
\      '###',
\    ],
\  },
\})

" ==============================================================================
" Matches regular functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   myFunc = (x) -> x * x
"
"   myFunc = (arg1, arg2, arg3) ->
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_$]\+\)\s*=\s*(\(.\{-}\))\s*[-=]>',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\([^,]\+\)',
\    'match_group_names': ['name'],
\    'format': ['@param {*}', '{name}', '- TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '###',
\      '@description TODO',
\      '@function {funcName|}',
\      '{parameters}',
\      '!@return {{returnType}} TODO',
\      '###',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
