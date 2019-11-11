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

call add(b:doge_patterns, {
\  'generator': 'libclang.py',
\  'parameters': {
\    'format': {
\      'doxygen': '@param {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'doxygen': [
\        '/**',
\        ' * @brief !description',
\        ' *',
\        '%(parameters| * {parameters})%',
\        '%(returnType| * @return !description)%',
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
