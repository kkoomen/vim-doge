" ==============================================================================
" The Groovy documentation should follow the 'JavaDoc' conventions.
" see https://www.oracle.com/technetwork/articles/javase/index-137868.html
"
" This ftplugin should always reflect the logic of the ftplugin/java.vim.
" ==============================================================================


let s:save_cpo = &cpoptions
set cpoptions&vim

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
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s*\)*\%(\%(\([[:alnum:]_]\+\)\?\s*\%(<[[:alnum:][:space:]_,]*>\)\?\)\?\s\+\)\?\([[:alnum:]_]\+\)(\(.\{-}\))\s*{',
\  'match_group_names': ['returnType', 'funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\%(\([[:alnum:]_]\+\)\%(<[[:alnum:][:space:]_,]\+>\)\?\)\%(\s\+[.]\{3}\s\+\|\s\+[.]\{3}\|[.]\{3}\s\+\|\s\+\)\([[:alnum:]_]\+\)',
\    'match_group_names': ['type', 'name'],
\    'format': ['@param', '{type}', '{name}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * TODO',
\      ' * {parameters}',
\      '! * @return {returnType|void} TODO',
\      ' */',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
