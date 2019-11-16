" ==============================================================================
" The C documentation should follow the 'Doxygen' conventions.
" - Doxygen: http://www.doxygen.nl/manual/docblocks.html
" - KernelDoc: https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html
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
      \ 'kernel_doc'
      \ ]
let b:doge_doc_standard = get(g:, 'doge_doc_standard_c', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid C doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

" ==============================================================================
" Functions and methods.
" ==============================================================================
call add(b:doge_patterns, {
\  'generator': {
\    'file': 'libclang.py',
\    'args': [
\      'CONSTRUCTOR',
\      'CXX_METHOD',
\      'FUNCTION_DECL',
\      'FUNCTION_TEMPLATE',
\      'CLASS_TEMPLATE'
\    ],
\  },
\  'parameters': {
\    'format': {
\      'doxygen_javadoc': '@{param-type|param} {name} !description',
\      'kernel_doc': '@{name}: !description',
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
\      'kernel_doc': [
\        '/**',
\        ' * {name}(): !description',
\        '%(parameters| * {parameters})%',
\        ' *',
\        ' * !description',
\        '%(returnType| *)%',
\        '%(returnType| * Return: !description)%',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Struct declarations.
" ==============================================================================
call add(b:doge_patterns, {
\  'generator': {
\    'file': 'libclang.py',
\    'args': ['STRUCT_DECL'],
\  },
\  'parameters': {
\    'format': {
\      'doxygen_javadoc': '@{name}: !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'doxygen_javadoc': [
\        '/**',
\        ' * struct {name} - !description',
\        '%(parameters| *)%',
\        '%(parameters| * {parameters})%',
\        ' */',
\      ],
\      'doxygen_javadoc_no_asterisk': [
\        '/**',
\        'struct {name} - !description',
\        '%(parameters|)%',
\        '%(parameters|{parameters})%',
\        '*/',
\      ],
\      'doxygen_javadoc_banner': [
\        '/*******************************************************************************',
\        ' * struct {name} - !description',
\        '%(parameters| *)%',
\        '%(parameters| * {parameters})%',
\        ' ******************************************************************************/',
\      ],
\      'doxygen_qt': [
\        '/*!',
\        ' * struct {name} - !description',
\        '%(parameters| *)%',
\        '%(parameters| * {parameters})%',
\        ' */',
\      ],
\      'doxygen_qt_no_asterisk': [
\        '/*!',
\        'struct {name} - !description',
\        '%(parameters|)%',
\        '%(parameters|{parameters})%',
\        '*/',
\      ],
\      'kernel_doc': [
\        '/**',
\        ' * struct {name} - !description',
\        '%(parameters|)%',
\        '%(parameters| * {parameters})%',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Field declarations.
" ==============================================================================
call add(b:doge_patterns, {
\  'generator': {
\    'file': 'libclang.py',
\    'args': ['FIELD_DECL'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'doxygen_javadoc': [
\        '/**',
\        ' * @{name} !description',
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
