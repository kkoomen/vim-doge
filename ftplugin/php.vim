let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_func_expr = []

""
" Matches regular function expressions and class methods.
"
" {match}: Should match at least the following scenarios:
"     - function myFunction(...)
"     - public myFunction(...)
"     - public static myFunction(...)
"     - public final myFunction(...)
"     - public static final myFunction(...)
"
"   Regex explanation
"     ^
"       Require that the line starts with a function expression.
"
"     \%(\%(public\|private\|protected\)\s\)\?
"       Match an optional and non-captured group that may
"       contain the keywords: 'public', 'private' or 'protected'.
"
"     \%(static\s\)\?
"       Match an optional and non-captured group that may
"       contain the keyword: 'static'.
"
"     \%(final\s\)\?
"       Match an optional and non-captured group that may
"       contain the keyword: 'final'.
"
"     function \([^(]\+\)\s*(\([^)]\+\))
"       Match two groups where group #1 is the function name,
"       denoted as: 'function \([^(]\+\)'
"
"       Followed by 0 or more spaces, denoted as '\s*'.
"
"       Followed by group #2 which contains the parameters,
"       denoted as: '(\([^)]\+\))'
"
" {parameters.match}: Should match at least the following scenarios:
"   - $arg1
"   - $arg1 = FALSE
"   - string $arg1
"   - string $arg1 = TRUE
"   - \Lorem\Ipsum\Dor\Sit\Amet $arg1 = NULL
"
"   Regex explanation
"     ^
"       Requires the pattern to match from the beginning of the parameter.
"
"     \([a-zA-Z0-9_\\]\+\s*\)\?
"       Matches an optional group containing 1 or more of the following
"       characters: [a-zA-Z0-9_\\] followed by 0 or more spaces.
"       This group should match the typing in a parameter.
"
"     \($[a-zA-Z0-9_]\+\)
"       Matches a group containing the character '$' followed by 1 or more
"       characters of the following: [a-zA-Z0-9_].
"       This group should match the parameter name.
"
"     \%(\s*=\s*[a-zA-Z0-9_']\+\)\?
"       Matches an optional and non-capturing group
"       where it should match the format ' = VALUE'.
"       This group should match the parameter default value.
"
"     $
"       Requires the pattern to match till the end of the parameter.
call add(b:doge_func_expr, {
      \   'match': '^\%(\%(public\|private\|protected\)\s\)\?\%(static\s\)\?\%(final\s\)\?function \([^(]\+\)\s*(\([^)]\+\))',
      \   'match_group_names': ['funcName', 'params'],
      \   'parameters': {
      \     'parent_match_group_name': 'params',
      \     'match': '^\([a-zA-Z0-9_\\]\+\s*\)\?\($[a-zA-Z0-9_]\+\)\%(\s*=\s*.\+\)\?$',
      \     'match_group_names': ['type', 'name'],
      \     'format': '@param {type|mixed} {name} TODO',
      \   },
      \   'comment': {
      \     'opener': '/**',
      \     'closer': '*/',
      \     'template': [
      \       '/**',
      \       ' * {params}',
      \       ' */',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
