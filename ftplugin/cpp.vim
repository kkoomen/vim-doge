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
  \ '[DoGe] %s is not a valid C++ doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

" Matches the following pattern:
"   const? <param-type> <param-name> = <param-default-value>
let s:parameters_match_pattern = '\m\%(\%(const\)\s\+\)\?\%(\%([[:alnum:]_]\+(.\{-})\|[[:alnum:]_:&*.]\+\%(<[[:alnum:][:space:]_(),]\+>\%([[:alnum:]_:&*.]\+\)*\)*\)\s\+\)&\?\([[:alnum:]_]\+\)\%(\s*=\s*\%([[:alnum:]_]\+(.\{-})\|[^,]\+\)\+\)\?'

" ==============================================================================
" Matches PTS-functions (placeholder type specifiers)
" ==============================================================================
"
" Matches the following scenarios:
"
"   template<auto n>
"   auto f() -> std::pair<decltype(n), decltype(n)> {}
"
"   template<class F, class... Args>
"   decltype(auto) PerfectForward(F fun, Args&&... args) {}
call add(b:doge_patterns, {
\  'match': '\m^\%(template\s*<[[:alnum:][:space:]_<>.,]*>\s\+\)\?\%(static\s\+\)\?\%(decltype(auto[&*]*)\|auto[&*]*\)\s\+\%([[:alnum:]_:]\+\)\s*(\(.\{-}\))\s*\%(\%([[:alnum:]_:]\+\s*(\%(.\{-}\))\)*\s\+\)\?\s*->\s*\([[:alnum:]_:&*.]\+\%(<[[:alnum:][:space:]_(),]\+>\%([[:alnum:]_:&*.]\+\)*\)*\)\s*[;{]',
\  'match_group_names': ['parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'doxygen': '@param {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'doxygen': [
\        '/**',
\        ' * !description',
\        '#(parameters| *)',
\        '#(parameters| * {parameters})',
\        '#(returnType| * @return !description)',
\        ' */',
\      ],
\    },
\  },
\})

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
\  'match': '\m^\%(\%(template\s*<[[:alnum:][:space:]_<>.,]*>\|const\|inline\)\s\+\)*\%(static\s\+\)\?\([[:alnum:]_:&*]\+\s*\%(<[[:alnum:][:space:]_<>.,:]\+>\)\?\|[[:alnum:]_]\+(.\{-})\)\s\+\%([[:alnum:]_:]\+\)\s*(\(.\{-}\))\s*[;{]',
\  'match_group_names': ['returnType', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'doxygen': '@param {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'doxygen': [
\        '/**',
\        ' * !description',
\        '#(parameters| *)',
\        '#(parameters| * {parameters})',
\        '#(returnType| * @return !description)',
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
