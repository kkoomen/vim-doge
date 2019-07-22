" ==============================================================================
" The C++ documentation should follow the 'Doxygen' conventions.
" see http://www.doxygen.nl/manual/docblocks.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = ['doxygen']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_cpp', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Kotlin doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

" Matches the following pattern:
"   const? <param-type> <param-name>
let s:parameters_match_pattern = '\m\%(\%(const\)\s\+\)\?\%(\%([[:alnum:]_]\+(.\{-})\|[[:alnum:]_:&*.]\+\%(<[[:alnum:][:space:]_(),]\+>\%([[:alnum:]_:&*.]\+\)*\)*\)\s\+\)&\?\([[:alnum:]_]\+\)'

" ==============================================================================
" Matches regular functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   void Emitter::append_token(const std::string& text, const AST_Node* node) {}

"   template<typename T>
"   Vector(std::enable_if<is_foreach_iterator<T>, T>::type& it_begin, T& _end) {}
"
"   template <class T>
"   T GetMax (T a, T b) {}
"
"   template<typename T, typename... Args>
"   static T* create(Args&& ... args) {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\(\(static\|extern\|[[:alnum:]_]\+\)[[:space:]_]\?\)\+\**\)(\%([[:print:]_]*\))[[:space:]_]*{',
\  'match_group_names': ['returnType', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'doxygen': '@param {name} [TODO:description]',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'doxygen': [
\        '/**',
\        ' * [TODO:description]',
\        '#(parameters| *)',
\        '#(parameters| * {parameters})',
\        '#(returnType| * @return [TODO:description])',
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
