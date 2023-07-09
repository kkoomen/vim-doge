let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#preprocessors#php#alter_parser_args(parser_args) abort
  let l:args = deepcopy(a:parser_args)
  let l:settings = get(g:, 'doge_php_settings', {})

  if l:settings['resolve_fqn']
    let l:args += ['--php-resolve-fqn']
  endif

  return l:args
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
