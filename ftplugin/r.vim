" ==============================================================================
" The R documentation should follow the 'Roxygen2' conventions.
" see https://github.com/klutometis/roxygen
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" ==============================================================================
" Matches regular functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   myFunc.default <- function(
"     p1,
"     p2.sub1 = FALSE,
"     p3.sub1 = 20,
"     p4.sub1 = 1/15,
"     ...
"   ) {
"     # ...
"   }

"   myFunc = function(
"     p1 = TRUE, p2_sub1= TRUE, p3 = FALSE,
"     p4 = 'libs', p5 = NULL, ..., p7 = 'default',
"     p8 = c('lorem', 'ipsum+dor', 'sit', 'amet'),
"     p9 = TRUE, p10 = list(), p11 = TRUE
"   ) {
"     # ...
"   }
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_.]\+\)\s*\%(=\|<-\)\s*function\s*(\(.\{-}\))\s*{',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\%(.\%([[:alnum:]_]\+\)\)*\)\%(\s*=\s*\%([[:alnum:]_]\+(.\{-})\|[^,]\+\)\)\?',
\    'match_group_names': ['name'],
\    'format': ['@param', '{name}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      "#' TODO",
\      "#'",
\      "#' {parameters}",
\      "#'",
\      "#' @export",
\      "#'",
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
