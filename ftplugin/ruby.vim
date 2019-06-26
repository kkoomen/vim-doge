" ==============================================================================
" The Ruby documentation should follow the 'RDoc' conventions.
" see https://ruby.github.io/rdoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#.\{-}$'
let b:doge_pattern_multi_line_comment = '\m\(=begin.\{-}=end\|<<-DOC.\{-}DOC\)'
let b:doge_patterns = []

" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" Matches the following scenarios:
"
"   def myFunc(p1, p_2 = some_default_value)
"
"   def def parameters (p1,p2=4, p3*)
"
"   def where(attribute, type = nil, **options)
"
"   def each(&block)
call add(b:doge_patterns, {
\  'match': '\m^def\s\+\%([^=(!]\+\)[=!]\?\s*(\(.\{-}\))',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\)\%(\s*=\s*[^,]\+\)\?',
\    'match_group_names': ['name'],
\    'format': ['@param', '{name}', '[type] TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '# TODO',
\      '!# {parameters}',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
