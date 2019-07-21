" ==============================================================================
" The Ruby documentation should follow the 'YARD' conventions.
" see https://www.rubydoc.info/gems/yard/file/docs/Tags.md
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#.\{-}$'
let b:doge_pattern_multi_line_comment = '\m\(=begin.\{-}=end\|<<-DOC.\{-}DOC\)'

let b:doge_supported_doc_standards = ['YARD']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_ruby', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Ruby doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

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
\    'format': {
\      'YARD': '@param {name} [!type] !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'YARD': [
\        '# !description',
\        '#(parameters|# {parameters})',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
