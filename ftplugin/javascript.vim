" ==============================================================================
" The javascript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

""
" ==============================================================================
" Matches class declarations.
" ==============================================================================
"
" {match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   ^
"     Matches the position before the first character in the string.
"
"   \%(export\s\+\)\?
"     This should match the keyword 'export'.
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group that should containing the
"     word 'export' followed by 1 or more spaces, denoted as '\s\+'.
"
"   class\s\+\([[:alnum:]_$]\+\)
"     This should match the pattern 'class <NAME>'
"     ------------------------------------------------------------------------
"     Matches the word 'class' followed by 1 or more spaces, followed by a
"     captured group, denoted as '\( ... \)' that may contain 1 or more of the
"     following characters '[[:alnum:]_$]'.
"
"   \%(\s\+extends\s\+\([[:alnum:]_$]\+\)\)\?
"     This should match the pattern 'extends <PARENT_CLASS_NAME>'.
"     ------------------------------------------------------------------------
"     Matches an optional and non-captured group, denoted as '\%( ... \)',
"     which should contain 1 or more spaces, followed by the word 'extends',
"     followed by 1 or more spaces and finally followed by a captured group,
"     denoted as '\( ... \)', that may contain 1 or more of the following
"     characters '[[:alnum:]_$]'.
"   \%(\s\+implements\s\+\([[:alnum:]_$]\+\)\)\?
"
"     This should match the pattern 'implements <INTERFACE>'.
"     ------------------------------------------------------------------------
"     Matches an optional and non-captured group, denoted as '\%( ... \)',
"     that should contain 1 or more spaces, followed by the word 'implements',
"     followed by 1 or more spaces, followed by a captured group, denoted as
"     '\( ... \)', that may contain 1 or more of the following characters:
"     '[[:alnum:]_$]'.
"
"   \s*{
"     This should match the opening of the function.
"     --------------------------------------------------------------------------
"     Matches 0 or more spaces, followed by the character '{'.
call add(b:doge_patterns, {
\  'match': '\m^\%(export\s*\)\?class\s\+\([[:alnum:]_$]\+\)\%(\s\+extends\s\+\([[:alnum:]_$]\+\)\)\?\%(\s\+implements\s\+\([[:alnum:]_$]\+\)\)\?\s*{',
\  'match_group_names': ['className', 'parentClassName', 'interfaceName'],
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '/**',
\      ' * TODO',
\      '! * @extends {parentClassName}',
\      '! * @implements {interfaceName}',
\      ' */',
\    ],
\  },
\})

""
" ==============================================================================
" Matches fat-arrow functions.
" ==============================================================================
"
" {match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   ^
"     Matches the position before the first character in the string.
"
"   \%(\%(\%(var\|const\|let\)\s\+\)\?\([[:alnum:]_$]\+\)\s*=\s*\)\?({\?\([^>]\{-}\)}\?)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*=>\s*[{(]
"     This should match the pattern
"     '(var|const|let) <FUNC_NAME> = (<PARAMETERS) => [{(]'
"     ------------------------------------------------------------------------
"
"     \%(\%(\%(var\|const\|let\)\s\+\)\?\([[:alnum:]_$]\+\)\s*=\s*\)\?
"       Matches the pattern '(var|const|let) <FUNC_NAME> = '.
"       ----------------------------------------------------------------------
"       The regex contains an optional non-captured group
"       '\%(\%(var\|const\|let\)\s\+\)\?' which matches the 3 keywords 'var',
"       'const' and 'let', followed by 1 or more spaces, denoted as '\s\+'.
"
"       Followed by a captured group, denoted as '\( ... \)', that may contain
"       1 or more of the following characters: '[[:alnum:]_$]'.
"
"       Followed by 0 or more spaces, followed by an equal sign, followed by 0
"       or more spaces.
"
"     ({\?\([^>]\{-}\)}\?)
"       Matches the pattern for the parameters.
"       ----------------------------------------------------------------------
"       Matches two parenthesis, denoted as '( ... )' that may contain
"       optional curly bracets on the inside, which can be used in projects
"       where destructuring is allowed. This notation is declared as '({  })'.
"       Inside the parenthesis it contains a group that should contain as few
"       as possible of the characters '[^>]', denoted as '[^>]\{-}'.
"
"     \%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?
"       Matches the pattern for the return type.
"       ----------------------------------------------------------------------
"       Matches an optional and non-captured group, denoted as '\%( ... \)',
"       that should start with 0 or more spaces, followed by a colon, followed
"       by 0 or more spaces, denoted as '\s*:\s*'.
"
"       Followed by the actual return type which is a captured group, denoted
"       as '\( ... \)', which may contain 1 or more of the following
"       characters '[[:alnum:][:space:]_[\].,|<>]' and is surrounded by optional
"       parenthesis wrapping the return type, denoted as '(\? ... )\?', which
"       may occur if 2 or more possible return types are given.
"
"     \s*=>\s*[{(]
"       Matches the pattern ' => {' or ' => ('.
"       ----------------------------------------------------------------------
"       Matches 0 or more spaces, follow by a thick-arrow notation, denoted as
"       '=>', followed by 0 or more spaces, followed by one of the following
"       allowed characters: '{' or '(', denoted as '[{(]'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   \%(\%(public\|private\|protected\)\?\s*\)\?
"     This should match the parameter access value.
"     --------------------------------------------------------------------------
"     Matches an optional an non-captured group, denoted as '\%( ... \)\?',
"     which may contain the 3 keywords: 'public', 'private' or 'public',
"     denoted as '\%(public\|private\|protected\)\?', followed by 0 or more
"     spaces, denoted as '\s*'.
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
\  'match': '\m^\%(\%(\%(var\|const\|let\)\s\+\)\?\([[:alnum:]_$]\+\)\s*=\s*\)\?({\?\([^>]\{-}\)}\?)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*=>\s*[{(]',
\  'match_group_names': ['funcName', 'parameters', 'returnType'],
\  'parameters': {
\    'match': '\m\%(\%(public\|private\|protected\)\?\s*\)\?\([[:alnum:]_$]\+\)\%(\s*:\s*\([[:alnum:][:space:]._|]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\+\)\?',
\    'match_group_names': ['name', 'type', 'default'],
\    'format': ['@param', '!{{type|*}}', '{name}', '- TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '/**',
\      ' * @function {funcName|}',
\      ' * @description TODO',
\      ' * {parameters}',
\      '! * @return {{returnType}} TODO',
\      ' */',
\    ],
\  },
\})

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
"   \%(export\s\+\)\?
"     This should match the keyword 'export'.
"     --------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)',
"     which should contain the word 'export' followed by 1 or more white-spaces,
"     denoted as '\s\+'.
"
"   \%(function\s*\)\?
"     This should match the keyword 'function'.
"     --------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)',
"     which should contain the word 'function', followed by 0 or more spaces,
"     denoted as '\s*'.
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
"     denoted as '\( ... \)' which may contain as few as possible of the
"     following characters: '[^>]', denoted as '[^>]\{-}'.
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
"   \s*[{(]
"     This should match the opening of the function.
"     --------------------------------------------------------------------------
"     Matches 0 or more spaces, denoted as '\s*', followed by one of the
"     following allowed characters: '{' or '(', denoted as '[{(]'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   \%(\%(public\|private\|protected\)\?\s*\)\?
"     This should match the parameter access value.
"     --------------------------------------------------------------------------
"     Matches an optional an non-captured group, denoted as '\%( ... \)\?',
"     which may contain the 3 keywords: 'public', 'private' or 'public',
"     denoted as '\%(public\|private\|protected\)\?', followed by 0 or more
"     spaces, denoted as '\s*'.
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
\  'match': '\m^\%(export\s\+\)\?\%(function\s*\)\?\([[:alnum:]_$]\+\)\?\%(<[[:alnum:][:space:]_,]*>\)\?(\([^>]\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*[{(]',
\  'match_group_names': ['funcName', 'parameters', 'returnType'],
\  'parameters': {
\    'match': '\m\%(\%(public\|private\|protected\)\?\s*\)\([[:alnum:]_$]\+\)\%(\s*:\s*\([[:alnum:][:space:]._|]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\+\)\?',
\    'match_group_names': ['name', 'type', 'default'],
\    'format': ['@param', '!{{type|*}}', '{name}', '- TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '/**',
\      ' * @function {funcName|}',
\      ' * @description TODO',
\      ' * {parameters}',
\      '! * @return {{returnType}} TODO',
\      ' */',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
