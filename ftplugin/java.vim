" ==============================================================================
" The Java documentation should follow the 'JavaDoc' conventions.
" see https://www.oracle.com/technetwork/articles/javase/index-137868.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = ['javadoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_java', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Java doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

" ==============================================================================
" Matches class methods.
" ==============================================================================
"
" Matches the following scenarios:
"
"   private void setChildrenRecursively(ElementDto childDto, int childId) {}
"
"   private List<ElementDto> createSortedList(Map<Integer, ElementDto> map, int type) {}
"
"   void foo(Map<String, Object> parameters) {}
"
"   void MyParameterizedFunction(String p1, int p2, Boolean ...params) {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s*\)*\%(\%(\([[:alnum:]_]\+\)\?\s*\%(<[[:alnum:][:space:]_,]*>\)\?\)\?\s\+\)\?\%([[:alnum:]_]\+\)(\(.\{-}\))\s*{',
\  'match_group_names': ['returnType', 'parameters'],
\  'parameters': {
\    'match': '\m\%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]\+>\)\?\)\%(\s\+[.]\{3}\s\+\|\s\+[.]\{3}\|[.]\{3}\s\+\|\s\+\)\([[:alnum:]_]\+\)',
\    'match_group_names': ['type', 'name'],
\    'format': {
\      'javadoc': '@param {type} {name} ' . g:doge_comment_placeholder,
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'javadoc': [
\        '/**',
\        ' * ' . g:doge_comment_placeholder,
\        '#(parameters| * {parameters})',
\        ' * @return {returnType|void} ' . g:doge_comment_placeholder,
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
