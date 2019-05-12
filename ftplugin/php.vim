" ==============================================================================
" Filename: php.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: GPL-3.0
" ==============================================================================
"
" The PHP documentation should follow the 'phpdoc' conventions.
" see https://www.phpdoc.org

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
"   \%(\%(public\|private\|protected\)\s*\)\?
"     This should match the keyword(s): 'public', 'private' or 'protected'.
"     ------------------------------------------------------------------------
"     Match an optional and non-captured group that may contain the keywords:
"     'public', 'private' or 'protected', followed by 0 or more white-spaces,
"     denoted as '\s*'.
"
"   \%(static\s*\)\?
"     This should match the keyword: 'static'.
"     ------------------------------------------------------------------------
"     Match an optional and non-captured group that may
"     contain the keyword: 'static', followed by 0 or more white-spaces,
"     denoted as '\s*'.
"
"   \%(final\s*\)\?
"     This should match the keyword: 'final'.
"     ------------------------------------------------------------------------
"     Match an optional and non-captured group that may
"     contain the keyword: 'final', followed by 0 or more white-spaces, denoted
"     as '\s*'.
"
"   function \([^(]\+\)\s*(\(.\{-}\))\s*{
"     This should match the function name and parameters,
"     declared as 'function <FUNC_NAME>(<PARAMETERS>) {'.
"     ------------------------------------------------------------------------
"     Match two groups where group #1 is the function name,
"     denoted as: 'function \([^(]\+\)'
"
"     Followed by 0 or more spaces, denoted as '\s*'.
"
"     Followed by group #2 which contains the parameters,
"     denoted as: '(\(.\{-}\))'. We use \{-} to ensure it will match as few
"     matches as possible, which prevents wrong parsing when the input
"     contains nested functions.
"
"     Followed by 0 or more spaces and then an opening curly brace,
"     denoted as '\s*{'.
"
" {parameters.match}: Regex explanation
"   \m
"     Interpret the pattern as a magic pattern.
"
"   \([a-zA-Z0-9_\\]\+\s*\)\?
"     This should match the parameter type.
"     ------------------------------------------------------------------------
"     Matches an optional group containing 1 or more of the following
"     characters: '[a-zA-Z0-9_\\]' followed by 0 or more spaces.
"
"   \($[a-zA-Z0-9_]\+\)
"     This should match the parameter name.
"     ------------------------------------------------------------------------
"     Matches a group containing the character '$' followed by 1 or more
"     characters of the following: '[a-zA-Z0-9_]'.
"
"   \%(\s*=\s*[^,]\+\)\?
"     This should match the parameter default value.
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group where it should match the
"     format ' = <VALUE>'. The '<VALUE>' should contain 1 or more of the
"     following characters: '[^,]'.
call add(b:doge_patterns, {
      \   'match': '\m^\%(\%(public\|private\|protected\)\s*\)\?\%(static\s*\)\?\%(final\s*\)\?function \([^(]\+\)\s*(\(.\{-}\))\s*{',
      \   'match_group_names': ['funcName', 'parameters'],
      \   'parameters': {
      \     'match': '\m\([a-zA-Z0-9_\\]\+\s*\)\?\($[a-zA-Z0-9_]\+\)\%(\s*=\s*[^,]\+\)\?',
      \     'match_group_names': ['type', 'name'],
      \     'format': ['@param', '{type|mixed}', '{name}', 'TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'opener': '/**',
      \     'closer': '*/',
      \     'template': [
      \       '/**',
      \       ' * {parameters}',
      \       ' */',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
