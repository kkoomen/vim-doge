" ==============================================================================
" The R documentation should follow the 'Roxygen2' conventions.
" see https://github.com/klutometis/roxygen
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#.\{-}$'
let b:doge_pattern_multi_line_comment = '\m#.\{-}$'

let b:doge_supported_doc_standards = ['google']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_sh', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Shell doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = {}

" ==============================================================================
" Define our base for every pattern.
" ==============================================================================
let s:pattern_base = {
\  'insert': 'above',
\}

" ==============================================================================
" Define the pattern types.
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions.
" ------------------------------------------------------------------------------
" function test {}
" test() {}
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\(function\s\+[[:alnum:]_-]\+\|[[:alnum:]_-]\+\s*(.\{-})\)\s*{',
\  'match_group_names': [],
\})

" ==============================================================================
" Define the doc standards.
" ==============================================================================
let b:doge_patterns.google = [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '################################################################################',
\      '# !description',
\      '# Globals:',
\      '# \t!var-name',
\      '# Arguments:',
\      '# \t$1: !description',
\      '# Returns:',
\      '# \t!description',
\      '################################################################################',
\    ],
\  }),
\]

let &cpoptions = s:save_cpo
unlet s:save_cpo
