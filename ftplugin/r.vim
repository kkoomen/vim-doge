" ==============================================================================
" The R documentation should follow the 'Roxygen2' conventions.
" see https://github.com/klutometis/roxygen
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#.\{-}$'
let b:doge_pattern_multi_line_comment = '\m#.\{-}$'

let b:doge_supported_doc_standards = ['roxygen2']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_r', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid R doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = {}

" ==============================================================================
" Define our base for every pattern.
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\%(.\%([[:alnum:]_]\+\)\)*\)\%(\s*=\s*\%([[:alnum:]_]\+(.\{-})\|[^,]\+\)\)\?',
\    'match_group_names': ['name'],
\    'format': '@param {name} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
" Define the pattern types.
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions.
" ------------------------------------------------------------------------------
" myFunc.default <- function(
"   p1,
"   p2.sub1 = FALSE,
"   p3.sub1 = 20,
"   p4.sub1 = 1/15,
"   ...
" ) {
"   # ...
" }

" myFunc = function(
"   p1 = TRUE, p2_sub1= TRUE, p3 = FALSE,
"   p4 = 'libs', p5 = NULL, ..., p7 = 'default',
"   p8 = c('lorem', 'ipsum+dor', 'sit', 'amet'),
"   p9 = TRUE, p10 = list(), p11 = TRUE
" ) {
"   # ...
" }
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%([[:alnum:]_.]\+\)\s*\%(=\|<-\)\s*function\s*(\(.\{-}\))\s*{',
\  'match_group_names': ['parameters'],
\})

" ==============================================================================
" Define the doc standards.
" ==============================================================================
let b:doge_patterns.roxygen2 = [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\        "#' !description",
\        "%(parameters|#')%",
\        "%(parameters|#' {parameters})%",
\        "#'",
\        "#' @return !description",
\        "#' @export",
\        "#'",
\        "#' @examples",
\        "#' !example",
\    ],
\  }),
\]

let &cpoptions = s:save_cpo
unlet s:save_cpo
