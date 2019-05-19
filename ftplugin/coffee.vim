" ==============================================================================
" The coffeescript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

""
" ==============================================================================
" Matches regular and typed functions with default parameters.
" ==============================================================================
"
" {match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   ^
"     Matches the position before the first character in the string.
"
"   \([[:alnum:]_$]\+\)\?
"     This should match the function name.
"     --------------------------------------------------------------------------
"     Matches a capturing group, denoted as '\( ... \)', which should contain 1
"     or more of the following characters: '[[:alnum:]_$]'.
"
"   \%(<[[:alnum:][:space:]_,]*>\)\?
"     This should match additional type hinting for the parameters. For example:
"     '<T, K extends keyof T>'.
"     --------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?',
"     which may contain 0 or more of the following characters:
"     '[[:alnum:][:space:]_,]', which should be surrounded by the characters '<'
"     and '>'.
"
"   (\([^>]\{-}\))
"     This should match the function parameters.
"     --------------------------------------------------------------------------
"     Matches parenthesis, denoted as '( ... )' which contains a captured group,
"     denoted as '\( ... \)' which should contain as few as possible
"     of the following characters: '[^>]', denoted as '[^>]\{-}'.
"
"   \s*[:=]\?\s*
"     This will allow the pattern to match functions defined with ':' or '='.
"     Example(s):
"       - square = (x) -> x * x
"       - square: (x) -> x * x
"     --------------------------------------------------------------------------
"     Matches 0 or more spaces, denoted as '\s*', followed by 0 or 1 of the
"     following characters: '[:=]', followed by 0 more spaces, denoted as '\s*'.
"
"   \%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?
"     This should match the return type of the function.
"     --------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?'
"     which should start with 0 or more spaces, followed by a colon, followed by
"     0 or more spaces, denoted as '\s*:\s*', followed by the group that
"     contains the return type.
"
"     The group containing the return type is surrounded by optional
"     parenthesis, denoted as '( ... )', which will match the situation where 2
"     or more possible return types are given, for example:
"
"       function rollTheDice(...): (1 | 2 | 3 | 4 | 5 | 6) { ... }
"
"     The group may contain 1 or more of the following characters:
"     '[[:alnum:][:space:]_[\].,|<>]'.
"
"   \s*->
"     This should match the opening of the function.
"     --------------------------------------------------------------------------
"     Matches 0 or more spaces, denoted as '\s*' followed by the character '->'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   \([[:alnum:]_]\+\)
"     This should match the parameter name.
"     --------------------------------------------------------------------------
"     Matches a captured group, denoted as '\( ... \)', which may contain 1 or
"     more of the following characters '[[:alnum:]_$]'.
"
"   \%(\s*:\s*\([[:alnum:][:space:]._|]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\)\)\?
"     This should match the parameter type in the format ': <TYPE>' where we try
"     to match the following scenarios: 'string', 'string[]' and 'T[K][]'.
"     --------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?',
"     which should begin with 0 or more spaces, followed by a colon, followed by
"     0 or more spaces, denoted as '\s*:\s*', followed by the captured group
"     being responsive for capturing the type itself, denoted as '\( ... \)'.
"
"     The group for the type itself should contain at least 1 or more of the
"     following characters: '[[:alnum:][:space:]._|]', followed by an optional
"     and non-captured group, denoted as '\%( ... \)\?', which should contain 0
"     or more of the following characters: '[[:alnum:][:space:]_[\],]',
"     surrounded by square brackets, denoted as '[ ... ]'. This will match the
"     scenarios such as: 'T[K][]' or 'string[]'.
"
"   \%(\s*=\s*\([^,]\+\)\+\)\?
"     This should match the parameter default value in the format ' = <VALUE>'.
"     --------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?',
"     which should start with 0 or more white-spaces, followed by an equal sign,
"     followed by 0 or more white-spaces, followed by the group containing the
"     actual parameter default value, denoted as '\([^,]\+\)'.
"
"     The group for the default value is a capturing group which may contain 1
"     or more of the following characters: '[^,]'.
call add(b:doge_patterns, {
      \   'match': '\m^\([[:alnum:]_$]\+\)\%(<[[:alnum:][:space:]_,]*>\)\?\s*[:=]\?\s*(\([^>]\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*->',
      \   'match_group_names': ['funcName', 'parameters', 'returnType'],
      \   'parameters': {
      \     'match': '\m\([[:alnum:]_$]\+\)\%(\s*:\s*\([[:alnum:][:space:]._|]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\+\)\?',
      \     'match_group_names': ['name', 'type', 'default'],
      \     'format': ['@param', '!{{type|*}}', '{name}', '- TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'opener': '###',
      \     'closer': '###',
      \     'trim_comparision_check': 0,
      \     'template': [
      \       '###',
      \       '@function {funcName|}',
      \       '@description TODO',
      \       '{parameters}',
      \       '!@return {{returnType}} TODO',
      \       '###',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
