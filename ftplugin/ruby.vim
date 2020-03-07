" ==============================================================================
" The Ruby documentation should follow the 'YARD' conventions.
" see https://www.rubydoc.info/gems/yard/file/docs/Tags.md
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#.\{-}$'
let b:doge_pattern_multi_line_comment = '\m\(=begin.\{-}=end\|<<-DOC.\{-}DOC\)'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['YARD'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('ruby')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\)\%(\s*[=:]\s*[^,]\+\)\?',
\    'tokens': ['name'],
\    'format': '@param {name} [!type] !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular function expressions and class methods.
" ------------------------------------------------------------------------------
" def myFunc(p1, p_2 = some_default_value)
" def parameters (p1,p2=4, *p3)
" def parameters p1, p2 = 4, *p3
" def where(attribute, type = nil, **options)
" def each(&block)
" def self.class_method(attribute)
" def self.class_parameters p1,p2=4, *p3
" ------------------------------------------------------------------------------
let s:function_and_class_method_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'normalize': 0,
\  'match': '\m^def\s\+\%([^=(!\n ]\+\)[=!]\?\s*\((\_.\{-})\|[^\n]\+\)\?',
\  'tokens': ['parameters'],
\})

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('YARD', [
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'template': [
\      '# !description',
\      '%(parameters|# {parameters})%',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
