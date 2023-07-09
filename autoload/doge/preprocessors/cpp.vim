let s:save_cpo = &cpoptions
set cpoptions&vim

function! doge#preprocessors#cpp#alter_parser_args(parser_args) abort
  let l:args = deepcopy(a:parser_args)
  let l:settings = get(g:, 'doge_doxygen_settings', {})

  if l:settings['char'] ==# '\'
    let l:args += ['--doxygen-use-slash-char']
  endif

  return l:args
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
