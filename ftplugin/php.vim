let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_func_expr = [
      \ {
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
      \ },
      \ ]

let &cpoptions = s:save_cpo
unlet s:save_cpo
