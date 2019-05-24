" ==============================================================================
" The Lua documentation should follow the 'LDoc' conventions.
" see https://github.com/stevedonovan/LDoc
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
"   \%(local\s*\)\?
"     This should match the 'local' keyword.
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?',
"     that may contain the keyword 'local' followed by 0 or more spaces, denoted
"     as '\s*'.
"
"   function\s*\%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*
"     This should match the function name.
"     An example scenario it should match would be 'function a.b:c (arg1, arg2)'
"     where 'c' is the method name.
"     ------------------------------------------------------------------------
"     Matches the 'function' keyword followed by 0 or more spaces, denoted as
"     '\s*', followed by an optional and non-capturing group, denoted as
"     '\%( ... \)\?', that may contain 1 or more of the following characters
"     '[[:alnum:]_:.]', followed by one of the following characters '[:.]',
"     followed a captured group, denoted as '\( ... \)', which may contain the
"     characters '[[:alnum:]_]', which can finally be followed by 0 or more
"     spaces, denoted as '\s*'.
"
"
"   (\(.\{-}\))
"     This should match the function parameters.
"     ------------------------------------------------------------------------
"     Matches parenthesis, denoted as '( ... )' which contains a captured group,
"     denoted as '\( ... \)', which may contain as few as possible characters,
"     denoted as '.\{-}'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   \([^,]\+\)
"     This should match the parameter name.
"     ------------------------------------------------------------------------
"     Matches a captured group that may contain 1 or more of the following
"     characters: '[^,]'.
call add(b:doge_patterns, {
      \   'match': '\m^\%(local\s*\)\?function\s*\%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*(\(.\{-}\))',
      \   'match_group_names': ['funcName', 'parameters'],
      \   'parameters': {
      \     'match': '\([^,]\+\)',
      \     'match_group_names': ['name'],
      \     'format': ['@param', '{name}', 'TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'opener': '--[[',
      \     'closer': '--]]',
      \     'trim_comparision_check': 0,
      \     'template': [
      \       '---[[',
      \       '-- TODO',
      \       '-- {parameters}',
      \       '--]]',
      \     ],
      \   },
      \ })

""
" ==============================================================================
" Matches regular function expressions as a variable value.
" ==============================================================================
"
" {match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   ^
"     Matches the position before the first character in the string.
"
"   \%(local\s*\)\?
"     This should match the 'local' keyword.
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?',
"     that may contain the keyword 'local' followed by 0 or more spaces, denoted
"     as '\s*'.
"
"   \%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*=\s*
"     This should match the function name.
"     An example scenario it should match would be 'function a.b:c (arg1, arg2)'
"     where 'c' is the method name.
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?',
"     that may contain 1 or more of the following characters '[[:alnum:]_:.]',
"     followed by one of the following characters '[:.]', followed a captured
"     group, denoted as '\( ... \)', which may contain the characters
"     '[[:alnum:]_]', which can finally be followed by 0 or more spaces, an
"     equal sign, again followed by 0 or more spaces.
"
"   \%(\s*function\s*\)\?(\(.\{-}\))
"     This should match the function declaration with its parameters.
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group, denoted as '\%( ... \)\?',
"     that may contain the 'function' keyword, followed by 0 or more spaces,
"     denoted as '\s*', followed by parenthesis, denoted as '( ... )' which
"     contains a captured group, denoted as '\( ... \)', which should contain as
"     few characters as possible, denoted as '.\{-}'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   \([^,]\+\)
"     This should match the parameter name.
"     ------------------------------------------------------------------------
"     Matches a captured group that may contain 1 or more of the following
"     characters: '[^,]'.
call add(b:doge_patterns, {
      \   'match': '\m^\%(local\s*\)\?\%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*=\s*\%(\s*function\s*\)\?(\(.\{-}\))',
      \   'match_group_names': ['funcName', 'parameters'],
      \   'parameters': {
      \     'match': '\([^,]\+\)',
      \     'match_group_names': ['name'],
      \     'format': ['@param', '{name}', 'TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'opener': '--[[',
      \     'closer': '--]]',
      \     'trim_comparision_check': 0,
      \     'template': [
      \       '---[[',
      \       '-- TODO',
      \       '-- {parameters}',
      \       '--]]',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
