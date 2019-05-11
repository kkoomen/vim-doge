" ==============================================================================
" Filename: php.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
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
" {match}: Should match at least the following scenarios:
"     - function myFunction(...) {
"     - public myFunction(...) {
"     - public static myFunction(...) {
"     - public final myFunction(...) {
"     - public static final myFunction(...) {
"
"   Regex explanation
"     \m
"       Use magic notation.
"
"     ^
"       Matches the position before the first character in the string.
"
"     \%(\%(public\|private\|protected\)\s*\)\?
"       Match an optional and non-captured group that may contain the keywords:
"       'public', 'private' or 'protected', followed by 0 or more whitespaces,
"       denoted as '\s*'.
"
"     \%(static\s*\)\?
"       Match an optional and non-captured group that may
"       contain the keyword: 'static', followed by 0 or more whitespaces,
"       denoted as '\s*'.
"
"     \%(final\s*\)\?
"       Match an optional and non-captured group that may
"       contain the keyword: 'final', followed by 0 or more whitespaces, denoted
"       as '\s*'.
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
"   - $param1
"   - $param1 = FALSE
"   - string $param1
"   - string $param1 = TRUE
"   - array $param1 = []
"   - array $param1 = array()
"   - \Lorem\Ipsum\Dor\Sit\Amet $param1 = NULL
"
" \m\([a-zA-Z0-9_\\]\+\s*\)\?
" \($[a-zA-Z0-9_]\+\)
"
" \%(\s*=\s*[^,]\+\)\?
"   Regex explanation
"     \m
"       Use magic notation.
"
"     \([a-zA-Z0-9_\\]\+\s*\)\?
"       This group should match the parameter type.
"       ------------------------------------------------------------------------
"       Matches an optional group containing 1 or more of the following
"       characters: '[a-zA-Z0-9_\\]' followed by 0 or more spaces.
"
"     \($[a-zA-Z0-9_]\+\)
"       This group should match the parameter name.
"       ------------------------------------------------------------------------
"       Matches a group containing the character '$' followed by 1 or more
"       characters of the following: '[a-zA-Z0-9_]'.
"
"     \%(\s*=\s*[^,]\+\)\?
"       This group should match the parameter default value.
"       ------------------------------------------------------------------------
"       Matches an optional and non-capturing group where it should match the
"       format ' = VALUE'. The 'VALUE' should contain 1 or more of the following
"       characters: '[^,]'.
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
