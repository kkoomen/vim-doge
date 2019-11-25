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

let b:doge_patterns = []

" ==============================================================================
" Matches regular functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   function test {}
"
"   test() {}
call add(b:doge_patterns, {
\  'match': '\m^\(function\s\+[[:alnum:]_-]\+\|[[:alnum:]_-]\+\s*(.\{-})\)\s*{',
\  'match_group_names': [],
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'google': [
\        '################################################################################',
\        '# !description',
\        '# Globals:',
\        '# \t!var-name',
\        '# Arguments:',
\        '# \t$1: !description',
\        '# Returns:',
\        '# \t!description',
\        '################################################################################',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
