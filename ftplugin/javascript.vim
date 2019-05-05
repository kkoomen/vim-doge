" ==============================================================================
" Filename: javascript.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_func_expr = []

""
" Matches regular and typed functions with default parameters.
"
" {match}: Should match at least the following scenarios:
"     - function myFunction(...) {
"
"   Regex explanation
"     \m
"       Use magic notation.
"
"     ^
"       Matches the position before the first character in the string.
"
"     function \([^(]\+\)\s*(\(.\{-}\))\s*{
"       Match two groups where group #1 is the function name,
"       denoted as: 'function \([^(]\+\)'
"
"       Followed by 0 or more spaces, denoted as '\s*'.
"
"       Followed by group #2 which contains the parameters,
"       denoted as: '(\(.\{-}\))'. We use \{-} to ensure it will match as few
"       matches as possible, which prevents wrong parsing when the input
"       contains nested functions.
"
"       Followed by 0 or more spaces and then an opening curly brace,
"       denoted as '\s*{'.
"
" {parameters.match}: Should match at least the following scenarios:
"   - arg1
"   - arg1 = 5
"   - arg1 = 'string'
"   - arg1: bool
"   - arg1: bool = 5
"   - arg1: Person = false
"   - arg1: string = 'string'
"
"   Regex explanation
"     \m
"       Use magic notation.
"
"     ^
"       Matches the position before the first character in the string.
"
"     \([^,:]\+\)
"       Matches a group which may contain every character besides ',' or ':'.
"       This group should match the parameter name.
"
"     \%(\%(\s*:\s*\([a-zA-Z_]\+\)\)\)\?
"       Matches an optional non-capturing group containing 1 sub-group which may
"       contain 1 or more of the following characters: [a-zA-Z_].
"
"     \%(\s*=\s*.\+\)\?
"       Matches an optional and non-capturing group
"       where it should match the format ' = VALUE'.
"       This group should match the parameter default value.
"
"     $
"       Matches right after the last character in the string.
call add(b:doge_func_expr, {
      \   'match': '\m^function \([^(]\+\)\s*(\(.\{-}\))\s*{',
      \   'match_group_names': ['funcName', 'params'],
      \   'parameters': {
      \     'parent_match_group_name': 'params',
      \     'match': '\m^\([^,:]\+\)\%(\%(\s*:\s*\([a-zA-Z_]\+\)\)\)\?\%(\s*=\s*.\+\)\?$',
      \     'match_group_names': ['name', 'type'],
      \     'format': ['@param', '!{{type|*}}', '{name}', 'TODO'],
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
