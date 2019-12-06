" ==============================================================================
" The C++ documentation should follow the 'Doxygen' conventions.
" see http://www.doxygen.nl/manual/docblocks.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards([
      \ 'doxygen_javadoc',
      \ 'doxygen_javadoc_no_asterisk',
      \ 'doxygen_javadoc_banner',
      \ 'doxygen_qt',
      \ 'doxygen_qt_no_asterisk',
      \ ])
let b:doge_doc_standard = doge#buffer#get_doc_standard('cpp')
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
" Matches (template) function- and class method declarations.
" ------------------------------------------------------------------------------
" int add(int x, int y) {}
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'generator': {
\    'args': [
\      'CONSTRUCTOR',
\      'CXX_METHOD',
\      'FUNCTION_DECL',
\      'FUNCTION_TEMPLATE',
\      'CLASS_TEMPLATE'
\    ],
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

let &cpoptions = s:save_cpo
unlet s:save_cpo
