" ==============================================================================
" The C documentation should follow the 'Doxygen' conventions.
" - Doxygen: http://www.doxygen.nl/manual/docblocks.html
" - KernelDoc: https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

" The C filetype also gets triggerred for C++, so we want to ignore this.
if &filetype !=? 'c'
  finish
endif

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

let b:doge_patterns = {}

" ==============================================================================
" Define our base for every pattern.
" ==============================================================================
let s:pattern_base = {
\  'generator': {
\    'file': 'libclang.py',
\  },
\  'parameters': {
\    'format': '@{param-type|param} {name} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
" Define the pattern types.
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions.
" ------------------------------------------------------------------------------
" int add(int x, int y) {}
" template<class...T> void h(int i = 0, T... args) {}
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'generator': {
\    'args': ['FUNCTION_DECL'],
\  },
\})

" ------------------------------------------------------------------------------
" Matches structs.
" ------------------------------------------------------------------------------
" struct foo {  };
" ------------------------------------------------------------------------------
let s:struct_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'generator': {
\    'args': ['STRUCT_DECL'],
\  },
\})

" ------------------------------------------------------------------------------
" Matches field declarations inside structs.
" ------------------------------------------------------------------------------
" struct foo {
"   int bar;
" };
" ------------------------------------------------------------------------------
let s:field_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'generator': {
\    'args': ['FIELD_DECL'],
\  },
\  'parameters': v:false,
\  'template': [
\    '/**',
\    ' * @{name} !description',
\    ' */',
\  ],
\})

" ==============================================================================
" Define the doc standards.
" ==============================================================================
let b:doge_patterns.doxygen_javadoc = [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/**',
\      ' * @brief !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/**',
\      ' * struct {name} - !description',
\      '%(parameters| *)%',
\      '%(parameters| * {parameters})%',
\      ' */',
\    ],
\  }),
\  s:field_pattern,
\]

let b:doge_patterns.doxygen_javadoc_no_asterisk = [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/**',
\      '@brief !description',
\      '',
\      '%(parameters|{parameters})%',
\      '%(returnType|@return !description)%',
\      '*/',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/**',
\      'struct {name} - !description',
\      '%(parameters|)%',
\      '%(parameters|{parameters})%',
\      '*/',
\    ],
\  }),
\  s:field_pattern,
\]

let b:doge_patterns.doxygen_javadoc_banner = [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/*******************************************************************************',
\      ' * @brief !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return !description)%',
\      ' ******************************************************************************/',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/*******************************************************************************',
\      ' * struct {name} - !description',
\      '%(parameters| *)%',
\      '%(parameters| * {parameters})%',
\      ' ******************************************************************************/',
\    ],
\  }),
\  s:field_pattern,
\]

let b:doge_patterns.doxygen_qt = [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/*!',
\      ' * @brief !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/*!',
\      ' * struct {name} - !description',
\      '%(parameters| *)%',
\      '%(parameters| * {parameters})%',
\      ' */',
\    ],
\  }),
\  s:field_pattern,
\]

let b:doge_patterns.doxygen_qt_no_asterisk = [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/*!',
\      '@brief !description',
\      '',
\      '%(parameters|{parameters})%',
\      '%(returnType|@return !description)%',
\      '*/',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/*!',
\      'struct {name} - !description',
\      '%(parameters|)%',
\      '%(parameters|{parameters})%',
\      '*/',
\    ],
\  }),
\  s:field_pattern,
\]

let s:kernel_doc_pattern_base = {'parameters': {'format': '@{name}: !description'}}
let b:doge_patterns.kernel_doc = [
\  doge#helpers#deepextend(s:function_pattern, s:kernel_doc_pattern_base, {
\    'template': [
\      '/**',
\      ' * {name}(): !description',
\      '%(parameters| * {parameters})%',
\      ' *',
\      ' * !description',
\      '%(returnType| *)%',
\      '%(returnType| * Return: !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, s:kernel_doc_pattern_base, {
\    'template': [
\      '/**',
\      ' * struct {name} - !description',
\      '%(parameters|)%',
\      '%(parameters| * {parameters})%',
\      ' */',
\    ],
\  }),
\  s:field_pattern,
\]

let &cpoptions = s:save_cpo
unlet s:save_cpo
