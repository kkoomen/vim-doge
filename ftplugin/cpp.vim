" ==============================================================================
" The C++ documentation should follow the 'Doxygen' conventions.
" see http://www.doxygen.nl/manual/docblocks.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'
let b:doge_patterns = []

" Matches the following pattern:
"   const? <param-name> <param-type> = <param-default-value>
let s:parameters_match_pattern = '\m\%(\%(const\)\s\+\)\?\%(\%([[:alnum:]_:&*.]\+\%(<[[:alnum:][:space:]_(),]\+>\%([[:alnum:]_:&*.]\+\)*\)*\)\s\+\)\([[:alnum:]_]\+\)\%(\s*=\s*\%([[:alnum:]_]\+(.\{-})\|[^,]\+\)\+\)\?'

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
\  'match': '\m^\%(\%(template\s*<[[:alnum:][:space:]_<>.,]\+>\)\s\+\)\?\%(decltype(auto[&*]*)\|auto[&*]*\)\s\+\%([[:alnum:]_:]\+\)\s*(\(.\{-}\))\s*\%(\s*->\s*[[:alnum:]_:&*.]\+\%(<[[:alnum:][:space:]_(),]\+>\%([[:alnum:]_:&*.]\+\)*\)*\)\?\s*{',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': ['@param', '{name}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * TODO',
\      ' *',
\      '! * {parameters}',
\      ' * @return TODO',
\      ' */',
\    ],
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
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(template\s*<[[:alnum:][:space:]_<>.,]\+>\)\s\+\)\?\%([[:alnum:]_:]\+\s*\%(<[[:alnum:][:space:]_<>.,]\+>\)\?\)\s\+\%([[:alnum:]_:]\+\)\s*(\(.\{-}\))\s*{',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': ['@param', '{name}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * TODO',
\      ' *',
\      '! * {parameters}',
\      ' * @return TODO',
\      ' */',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
