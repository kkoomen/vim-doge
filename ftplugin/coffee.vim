" ==============================================================================
" The coffeescript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" ==============================================================================
" Matches regular and typed functions with default parameters.
" ==============================================================================
"
" Matches the following scenarios:
"
"   myFunc = (x) -> x * x
"
"   myFunc = (x: int): int -> x * x
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_$]\+\)\%(<[[:alnum:][:space:]_,]*>\)\?\s*[:=]\?\s*(\([^>]\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*->',
\  'match_group_names': ['funcName', 'parameters', 'returnType'],
\  'parameters': {
\    'match': '\m\([[:alnum:]_$]\+\)\%(\s*:\s*\([[:alnum:][:space:]._|]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\+\)\?',
\    'match_group_names': ['name', 'type'],
\    'format': ['@param', '!{{type|*}}', '{name}', '- TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '###',
\      '@function {funcName|}',
\      '@description TODO',
\      '{parameters}',
\      '!@return {{returnType}} TODO',
\      '###',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
