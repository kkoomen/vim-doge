" ==============================================================================
" The Ruby documentation should follow the 'RDoc' conventions.
" see https://ruby.github.io/rdoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

call add(b:doge_patterns, {
      \   'match': '\m^def\s*\([^=(]\+\)[=!]\?\s*(\(.\{-}\))',
      \   'match_group_names': ['funcName', 'parameters'],
      \   'parameters': {
      \     'match': '\m\([[:alnum:]_]\+\)\%(\s*=\s*[^,]\+\)\?',
      \     'match_group_names': ['name'],
      \     'format': ['@param {name} [type] TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'trim_comparision_check': 0,
      \     'template': [
      \       '# TODO',
      \       '# {parameters}',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
