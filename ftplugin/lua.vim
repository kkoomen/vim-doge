" ==============================================================================
" The Lua documentation should follow the 'LDoc' conventions.
" see https://github.com/stevedonovan/LDoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

let s:parameters_match_pattern = '\m\([^,]\+\)'

" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" Matches the following scenarios:
"
"   function new_function(arg1, arg2, arg3, arg4)
"
"   local function new_function(arg1, arg2, arg3)
"
"   function BotDetectionHandler:access(arg1, arg2, arg3)
"
"   function a.b:c (arg1, arg2) body end
"
"   a.b.c = function (self, arg1, arg2) body end
call add(b:doge_patterns, {
\  'match': '\m^\%(local\s*\)\?function\s*\%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*(\(.\{-}\))',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': ['@param', '{name}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '-- TODO',
\      '-- {parameters}',
\    ],
\  },
\})

""
" ==============================================================================
" Matches regular function expressions as a variable value.
" ==============================================================================
"
" Matches the following scenarios:
"
"   myprint = function(arg1, arg2)
"
"   local myprint = function(arg1, arg2, arg3, arg4, arg5)
call add(b:doge_patterns, {
\  'match': '\m^\%(local\s*\)\?\%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*=\s*\%(\s*function\s*\)\?(\(.\{-}\))',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': ['@param', '{name}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '-- TODO',
\      '-- {parameters}',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
