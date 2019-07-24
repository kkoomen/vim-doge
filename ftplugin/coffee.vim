" ==============================================================================
" The CoffeeScript documentation should follow the 'jsdoc' conventions, since
" there is no official CoffeeScript documentation.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#\@<!##\@!.\+$'
let b:doge_pattern_multi_line_comment = '\m###.\{-}###'

let b:doge_supported_doc_standards = ['jsdoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_coffee', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid CoffeeScript doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

" ==============================================================================
" Matches prototype functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   Person::greet = (name) ->
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_$]\+\)::\([[:alnum:]_$]\+\)\s*=\s*[-=]>',
\  'match_group_names': ['className', 'funcName'],
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'jsdoc': [
\        '###',
\        '!description',
\        '',
\        '@function {className}#{funcName}',
\        '###',
\      ],
\    }
\  },
\})

" ==============================================================================
" Matches regular functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   myFunc = (x) -> x * x
"
"   myFunc = (p1, p2, p3) ->
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_$]\+\)\s*=\s*(\(.\{-}\))\s*[-=]>',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\([^,]\+\)',
\    'match_group_names': ['name'],
\    'format': {
\      'jsdoc': '@param {!type} {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'jsdoc': [
\        '###',
\        '!description',
\        '',
\        '@function {funcName|}',
\        '%(parameters|{parameters})%',
\        '###',
\      ],
\    }
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
