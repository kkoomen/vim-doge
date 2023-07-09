let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#preprocessors#python#alter_parser_args(parser_args) abort
  let l:args = deepcopy(a:parser_args)
  let l:settings = get(g:, 'doge_python_settings', {})

  if l:settings['single_quotes']
    let l:args += ['--python-single-quotes']
  endif

  if l:settings['omit_redundant_param_types']
    let l:args += ['--python-omit-redundant-param-types']
  endif

  return l:args
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
