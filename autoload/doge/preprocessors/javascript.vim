let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#preprocessors#javascript#alter_parser_args(parser_args) abort
  let l:args = deepcopy(a:parser_args)
  let l:settings = get(g:, 'doge_javascript_settings', {})

  if l:settings['destructuring_props']
    let l:args += ['--js-destructuring-props']
  endif

  if l:settings['omit_redundant_param_types']
    let l:args += ['--js-omit-redundant-param-types']
  endif

  return l:args
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
