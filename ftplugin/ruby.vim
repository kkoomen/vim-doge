" ==============================================================================
" The Ruby documentation should follow the 'RDoc' conventions.
" see https://ruby.github.io/rdoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

""
" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" {match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   ^
"     Matches the position before the first character in the string.
"
"   def\s\+\([^=(!]\+\)[=!]\?\s*
"     This should match the function name.
"     ------------------------------------------------------------------------
"     Matches the keyword 'def' followed by 1 or more spaces, denoted as '\s\+',
"     followed by a captured group, denoted as '\( ... \)', which may contain 1
"     more of the following characters '[^=(!]', followed by an optional single
"     character '=' or '!', denoted as '[=!]\?', followed by 0 or more spaces,
"     denoted as '\s*'.
"
"   (\(.\{-}\))
"     This should match the function parameters.
"     ------------------------------------------------------------------------
"     Matches parenthesis, denoted as '( ... )' which contains a captured group,
"     denoted as '\( ... \)', which will match as few matches as possible of any
"     character, denoted as '.\{-}'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   \([[:alnum:]_]\+\)
"     This should match the parameter name.
"     ------------------------------------------------------------------------
"     Matches a captured group that may contain 1 or more of the following
"     characters: '[[:alnum:]_]'.
"
"   \%(\s*=\s*[^,]\+\)\?
"     This should match the parameter default value.
"     ------------------------------------------------------------------------
"     Matches an optional and non-captured group, denoted as \(% ... \), which
"     should contain the pattern ' = <VALUE>' where '<VALUE>' may contain 1 or
"     more of the following characters '[^,]'.
call add(b:doge_patterns, {
\  'match': '\m^def\s\+\([^=(!]\+\)[=!]\?\s*(\(.\{-}\))',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\)\%(\s*=\s*[^,]\+\)\?',
\    'match_group_names': ['name'],
\    'format': ['@param {name} [type] TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '# TODO',
\      '# {parameters}',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
