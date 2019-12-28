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

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards([
      \ 'doxygen_javadoc',
      \ 'doxygen_javadoc_no_asterisk',
      \ 'doxygen_javadoc_banner',
      \ 'doxygen_qt',
      \ 'doxygen_qt_no_asterisk',
      \ 'kernel_doc'
      \ ])
let b:doge_doc_standard = doge#buffer#get_doc_standard('c')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
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
"
" Define the pattern types.
"
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
\  'template': [
\    '/**',
\    ' * @{name} !description',
\    ' */',
\  ],
\})
unlet s:field_pattern['parameters']

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('doxygen_javadoc', [
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
\])

call doge#buffer#register_doc_standard('doxygen_javadoc_no_asterisk', [
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
\])

call doge#buffer#register_doc_standard('doxygen_javadoc_banner', [
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
\])

call doge#buffer#register_doc_standard('doxygen_qt', [
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
\])

call doge#buffer#register_doc_standard('doxygen_qt_no_asterisk', [
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
\])

let s:kernel_doc_pattern_base = {'parameters': {'format': '@{name}: !description'}}
call doge#buffer#register_doc_standard('kernel_doc', [
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
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
