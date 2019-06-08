" ==============================================================================
" The Ruby documentation should follow the 'RDoc' conventions.
" see https://ruby.github.io/rdoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" Matches the following scenarios:
"
"   def myFunc(arg1, arg_2 = some_default_value)
"
"   def def parameters (arg1,arg2=4, arg3*)
"
"   def where(attribute, type = nil, **options)
"
"   def each(&block)
call add(b:doge_patterns, {
\  'match': '\m^def\s\+\([^=(!]\+\)[=!]\?\s*(\(.\{-}\))',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\)\%(\s*=\s*[^,]\+\)\?',
\    'match_group_names': ['name'],
\    'format': ['@param', '{name}', '[type] TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '# TODO',
\      '# {parameters}',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
