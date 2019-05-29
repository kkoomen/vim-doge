" ==============================================================================
" The PHP documentation should follow the 'phpdoc' conventions.
" see https://www.phpdoc.org
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

function! DogePreprocessParameterTokens(params) abort
  echoerr a:params
  for l:param in a:params
    let param_idx = index(a:params, l:param)
    " Convert class type hints to their FQN.
    " Example scenarios:
    "   1) Rewrite to FQN if it is not an alias.
    "     use Drupal\Core\Config\Entity\Query\QueryFactory;
    "     function queryAlter(QueryFactory $query_factory) { ... }
    "
    "     Expected output:
    "       /**
    "        * @param \Drupal\Core\Config\Entity\Query\QueryFactory $query_factory TODO
    "        */
    "   2) Do not rewrite since it is an alias.
    "     use Drupal\Core\Config\Entity\Query\QueryFactoryBase as QueryFactory;
    "     function queryAlter(QueryFactory $query_factory) { ... }
    "
    "     Expected output:
    "       /**
    "        * @param QueryFactory $query_factory TODO
    "        */
    if has_key(l:param, 'type') && !empty(l:param['type']) && l:param['type'] !~# '\\'
      let l:use_statement_regex = printf('\m^use \([[:alnum:]_\\]\+%s\);', l:param['type'])
      let l:lnum_use_statement = search(l:use_statement_regex, 'n')
      if l:lnum_use_statement > 0
        let l:matches = matchlist(getline(l:lnum_use_statement), l:use_statement_regex)
        let l:fqn = '\' . substitute(get(l:matches, 1), '^\\\+', '', '')
        let a:params[l:param_idx]['type'] = escape(l:fqn , '\')
      endif
    endif
  endfor
  return a:params
endfunction

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
"   \([[:alnum:]_\\]\+\)\?\s*
"     This should match the parameter type.
"     ------------------------------------------------------------------------
"     Matches an optional group containing 1 or more of the following
"     characters: '[[:alnum:]_\\]' followed by 0 or more spaces.
"
"   \($[[:alnum:]_]\+\)
"     This should match the parameter name.
"     ------------------------------------------------------------------------
"     Matches a group containing the character '$' followed by 1 or more
"     characters of the following: '[[:alnum:]_]'.
"
"   \%(\s*=\s*[^,]\+\)\?
"     This should match the parameter default value.
"     ------------------------------------------------------------------------
"     Matches an optional and non-capturing group where it should match the
"     format ' = <VALUE>'. The '<VALUE>' should contain 1 or more of the
"     following characters: '[^,]'. We also presume that default parameters will
"     be '[]' or 'array()' rather then 'array(1, 2, 3, ...)', otherwise '[^,]'
"     will not work.
call add(b:doge_patterns, {
      \   'match': '\m^\%(public\|private\|protected\)\?\s*\%(static\)\?\s*\%(final\)\?\s*function\s*\([^(]\+\)\s*(\(.\{-}\))\s*{',
      \   'match_group_names': ['funcName', 'parameters'],
      \   'parameters': {
      \     'match': '\m\([[:alnum:]_\\]\+\)\?\s*&\?\($[[:alnum:]_]\+\)\%(\s*=\s*[^,]\+\)\?',
      \     'match_group_names': ['type', 'name'],
      \     'format': ['@param {type|mixed} {name} TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'trim_comparision_check': 0,
      \     'template': [
      \       '/**',
      \       ' * TODO',
      \       ' *',
      \       ' * {parameters}',
      \       ' */',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
