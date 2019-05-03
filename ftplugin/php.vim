let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_func_expr = []

""
" Matches regular function expressions and class methods.
"
" [match]: should match atleast the following scenarios:
"   - function myFunction(...)
"   - public myFunction(...)
"   - public static myFunction(...)
"   - public final myFunction(...)
"   - public static final myFunction(...)
"
" [parameters.match]: Should match atleast the following scenarios:
"   - $arg1
"   - $arg1 = FALSE
"   - string $arg1
"   - string $arg1 = TRUE
"   - \Lorem\Ipsum\Dor\Sit\Amet $arg1 = NULL
call add(b:doge_func_expr, {
      \   'match': '^\%(\%(public\|private\|protected\)\s\)\?\%(static\s\)\?\%(final\s\)\?function \([^(]\+\)\s*(\([^)]\+\))',
      \   'match_group_names': ['funcName', 'params'],
      \   'parameters': {
      \     'parent_match_group_name': 'params',
      \     'match': '^\([a-zA-Z\\]\+\s*\)\?\($[a-zA-Z0-9_]\+\)\%(\%(\s*=\s*\)\([a-zA-Z0-9_]\+\)\)\?$',
      \     'match_group_names': ['type', 'name', 'default'],
      \     'format': ['@param', '{type|mixed}', '{name}', 'TODO'],
      \   },
      \   'comment_template': [
      \     '/**',
      \     ' * {params}',
      \     ' */',
      \   ],
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
