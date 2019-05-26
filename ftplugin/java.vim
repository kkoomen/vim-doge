" ==============================================================================
" The Java documentation should follow the 'JavaDoc' conventions.
" see https://www.oracle.com/technetwork/articles/javase/index-137868.html
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
"   \%(public\|private\|protected\)\?\s*
"     This should match the keyword(s): 'public', 'private' or 'protected'.
"     ------------------------------------------------------------------------
"     Match an optional and non-captured group that may contain the keywords:
"     'public', 'private' or 'protected', followed by 0 or more white-spaces,
"     denoted as '\s*'.
"
"   \%(static\)\?\s*
"     This should match the keyword: 'static'.
"     ------------------------------------------------------------------------
"     Match an optional and non-captured group that may
"     contain the keyword: 'static', followed by 0 or more white-spaces,
"     denoted as '\s*'.
"
"   \%(final\)\?\s*
"     This should match the keyword: 'final'.
"     ------------------------------------------------------------------------
"     Match an optional and non-captured group that may
"     contain the keyword: 'final', followed by 0 or more white-spaces, denoted
"     as '\s*'.
"
"   \%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]*>\)\?\)\s*
"     This should match the function return type.
"     ------------------------------------------------------------------------
"     Matches a non-capturing group, denoted as '\%( ... \)', which contains two
"     subgroups where the first one contains the return type we want to grab,
"     denoted as '\( ... \)' which may contain 1 or more of the following
"     characters '[[:alnum:]_]', followed by an optional and non-capturing group
"     that may contain 0 or more of the following characters
"     '[[:alnum:][:space:]_,]' grouped in '< ... >'.
"
"   \([[:alnum:]_]\+\)\s*(\(.\{-}\))\s*{
"     This should match the function name and parameters.
"     ------------------------------------------------------------------------
"     Matches two groups where the first group matches the function name. The
"     first group is a captured group, denoted as '\( ... \)', which may contain
"     1 or more of the following characters '[[:alnum:]_]', followed by 0 or
"     more spaces, denoted as '\s*'.
"
"     The second group matches the function parameters which is a captured
"     group, denoted as '\( ... \)', that is surrounded by parenthesis, denoted
"     as '( ... )', which will match as few matches as possible of any
"     character, denoted as '.\{-}'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.

"   \%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]*>\)\?\)\s*
"     This should match the function return type.
"     ------------------------------------------------------------------------
"     Matches a non-capturing group, denoted as '\%( ... \)', which contains two
"     subgroups where the first one contains the return type we want to grab,
"     denoted as '\( ... \)' which may contain 1 or more of the following
"     characters '[[:alnum:]_]', followed by an optional and non-capturing group
"     that may contain 0 or more of the following characters
"     '[[:alnum:][:space:]_,]' grouped in '< ... >'.
"
"   \%(\s\+[.]\{3}\s\+\|\s\+[.]\{3}\|[.]\{3}\s\+\|\s\+\)
"     This should match the 'varargs'.
"     It should match the following scenarios:
"       - ' ... '
"       - ' ...'
"       - '...'
"       - ' '
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)', 1 or
"     more spaces, denoted as '\s\+', or 3 dots, denoted as '...', which may
"     have as suffix and/or prefix 1 or more spaces as well.
"
"   \([[:alnum:]_]\+\)
"     This should match the parameter name.
"     ------------------------------------------------------------------------
"     Matches a captured group, denoted as '\( ... \)', which may contain 1 or
"     more of the following characters '[[:alnum:]_]'.
call add(b:doge_patterns, {
      \   'match': '\m^\%(public\|private\|protected\)\?\s*\%(static\)\?\s*\%(final\)\?\s*\%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]*>\)\?\)\s*\([[:alnum:]_]\+\)\s*(\(.\{-}\))\s*{',
      \   'match_group_names': ['returnType', 'funcName', 'parameters'],
      \   'parameters': {
      \     'match': '\m\%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]\+>\)\?\)\%(\s\+[.]\{3}\s\+\|\s\+[.]\{3}\|[.]\{3}\s\+\|\s\+\)\([[:alnum:]_]\+\)',
      \     'match_group_names': ['type', 'name'],
      \     'format': ['@param', '{type}', '{name}', 'TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'opener': '/**',
      \     'closer': '*/',
      \     'trim_comparision_check': 0,
      \     'template': [
      \       '/**',
      \       ' * TODO',
      \       ' * {parameters}',
      \       '! * @return {returnType} TODO',
      \       ' */',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
