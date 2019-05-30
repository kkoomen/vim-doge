let s:save_cpo = &cpoptions
set cpoptions&vim

" A callback function being called after the parameter tokens have been
" extracted. This function will adjust the input if needed.
function! doge#preprocessors#php#parameter_tokens(params) abort
  for l:param in a:params
    let param_idx = index(a:params, l:param)
    " Convert class type hints to their FQN.
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

let &cpoptions = s:save_cpo
unlet s:save_cpo
