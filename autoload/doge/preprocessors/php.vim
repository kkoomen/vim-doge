let s:save_cpo = &cpoptions
set cpoptions&vim

" Convert class type hints to their FQN if the 'use' statement is defined in the
" file. Otherwise it will return the type as is.
"
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
function! s:get_parameter_type_fqn(type) abort
  let l:fqn = a:type
  let l:has_fqn_defined = 0

  if a:type !~# '\\'
    let l:use_statement_regex = printf('\m^use.\{-}\([[:alnum:]_\\]\+%s\)[;,].\{-}', a:type)
    let l:lnum_use_statement = search(l:use_statement_regex, 'n')
    if l:lnum_use_statement > 0
      let l:matches = matchlist(getline(l:lnum_use_statement), l:use_statement_regex)
      let l:fqn = '\' . substitute(get(l:matches, 1), '^\\\+', '', '')
    endif
  elseif l:fqn !~# '^\\'
    let l:fqn = '\' . l:fqn
  endif

  if l:fqn !~# '\\\\'
    return escape(l:fqn, '\')
  else
    return l:fqn
  endif
endfunction

" Look for the '$this->{propName} = {propValue}' pattern where {propName} will
" be equal to a:propertyName and {propValue} will be equal to the parameter
" passed via the __construct() function. We use the {propValue} to strip out the
" type hint of the {propValue} from the parameter list of the __construct()
" function.
function! s:get_property_type_via_constructor(propertyName) abort
  let l:type = ''

  " Search for the first class opener and closer around the cursor.
  let [l:class_opener_lnum, _] = searchpairpos('{', '', '}', 'bnrW')
  let [l:class_closer_lnum, _] = searchpairpos('{', '', '}', 'nrW')

  " Get the contents inside the class.
  let l:class_content = join(getline(l:class_opener_lnum, l:class_closer_lnum), ' ')

  " Search for the constructor function in that class.
  if match(l:class_content, '__construct(') isnot -1
    let l:constructor_func_match = filter(matchlist(l:class_content, '\m\(__construct(.\{-})\s*{.\{-}}\)'), 'v:val isnot# ""')
    let l:constructor_func_contents = get(l:constructor_func_match, 1)
    if l:constructor_func_contents isnot v:false
      " Constructor exists, grab the type hint and if it exists then set it.
      let l:property_type_hint_pattern = printf('\m\<\([[:alnum:]_\\]\+\)\s\+\($[[:alnum:]_]\+\)\>\ze\%(.\{-}$this->%s\s*=\s*\2\>\)', a:propertyName)
      let l:matches = matchlist(l:constructor_func_contents, l:property_type_hint_pattern)
      if len(l:matches) > 1
        let l:fqn = <SID>get_parameter_type_fqn(get(l:matches, 1))
        let l:type = l:fqn
      endif
    endif
  endif

  return l:type
endfunction

" A callback function being called after the tokens have been extracted. This
" function will adjust the input if needed.
function! doge#preprocessors#php#tokens(params) abort
  if has_key(a:params, 'propertyName') && !empty(a:params['propertyName'])
    let l:fqn = <SID>get_property_type_via_constructor(a:params['propertyName'])
    if !empty(l:fqn)
      let a:params['type'] = l:fqn
    endif
  endif
endfunction

" A callback function being called after the parameter tokens have been
" extracted. This function will adjust the input if needed.
function! doge#preprocessors#php#parameter_tokens(params) abort
  for l:param in a:params
    let param_idx = index(a:params, l:param)
    if has_key(l:param, 'type') && !empty(l:param['type'])
      let l:fqn = <SID>get_parameter_type_fqn(l:param['type'])
      let a:params[l:param_idx]['type'] = l:fqn
    endif
  endfor
  return a:params
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
