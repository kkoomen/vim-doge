" ==============================================================================
" The C++ documentation should follow the 'Doxygen' conventions.
" see http://www.doxygen.nl/manual/docblocks.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = [
      \ 'doxygen_javadoc',
      \ 'doxygen_javadoc_no_asterisk',
      \ 'doxygen_javadoc_banner',
      \ 'doxygen_qt',
      \ 'doxygen_qt_no_asterisk',
      \ ]
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
\      'doxygen_javadoc': '@{param-type|param} {name} !description',
\      'doxygen_javadoc_no_asterisk': '@{param-type|param} {name} !description',
\      'doxygen_javadoc_banner': '@{param-type|param} {name} !description',
\      'doxygen_qt': '@{param-type|param} {name} !description',
\      'doxygen_qt_no_asterisk': '@{param-type|param} {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'doxygen_javadoc': [
\        '/**',
\        ' * @brief !description',
\        ' *',
\        '%(parameters| * {parameters})%',
\        '%(returnType| * @return !description)%',
\        ' */',
\      ],
\      'doxygen_javadoc_no_asterisk': [
\        '/**',
\        '@brief !description',
\        '',
\        '%(parameters|{parameters})%',
\        '%(returnType|@return !description)%',
\        '*/',
\      ],
\      'doxygen_javadoc_banner': [
\        '/*******************************************************************************',
\        ' * @brief !description',
\        ' *',
\        '%(parameters| * {parameters})%',
\        '%(returnType| * @return !description)%',
\        ' ******************************************************************************/',
\      ],
\      'doxygen_qt': [
\        '/*!',
\        ' * @brief !description',
\        ' *',
\        '%(parameters| * {parameters})%',
\        '%(returnType| * @return !description)%',
\        ' */',
\      ],
\      'doxygen_qt_no_asterisk': [
\        '/*!',
\        '@brief !description',
\        '',
\        '%(parameters|{parameters})%',
\        '%(returnType|@return !description)%',
\        '*/',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
