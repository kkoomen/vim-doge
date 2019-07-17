" ==============================================================================
" The Lua documentation should follow the 'LDoc' conventions.
" see https://github.com/stevedonovan/LDoc
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m--\+\([[\)\@!.\{-}$'
let b:doge_pattern_multi_line_comment = '\m--\+[[.\{-}]]--\+'

let b:doge_supported_doc_standards = ['ldoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_lua', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Lua doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

let s:parameters_match_pattern = '\m\([^,]\+\)'

" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" Matches the following scenarios:
"
"   function new_function(p1, p2, p3, p4)
"
"   local function new_function(p1, p2, p3)
"
"   function BotDetectionHandler:access(p1, p2, p3)
"
"   function a.b:c (p1, p2) body end
"
"   a.b.c = function (self, p1, p2) body end
call add(b:doge_patterns, {
\  'match': '\m^\%(local\s*\)\?function\s*\%([[:alnum:]_:.]\+[:.]\)\?\%([[:alnum:]_]\+\)\s*(\(.\{-}\))',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'ldoc': '@param {name} ' . g:doge_comment_placeholder,
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'ldoc': [
\        '-- ' . g:doge_comment_placeholder,
\        '#(parameters|-- {parameters})',
\      ],
\    },
\  },
\})

""
" ==============================================================================
" Matches regular function expressions as a variable value.
" ==============================================================================
"
" Matches the following scenarios:
"
"   myprint = function(p1, p2)
"
"   local myprint = function(p1, p2, p3, p4, p5)
call add(b:doge_patterns, {
\  'match': '\m^\%(local\s*\)\?\%([[:alnum:]_:.]\+[:.]\)\?\([[:alnum:]_]\+\)\s*=\s*\%(\s*function\s*\)\?(\(.\{-}\))',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'ldoc': '@param {name} ' . g:doge_comment_placeholder,
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'ldoc': [
\        '-- ' . g:doge_comment_placeholder,
\        '#(parameters|-- {parameters})',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
