" ==============================================================================
" The C++ documentation should follow the 'Doxygen' conventions.
" see http://www.doxygen.nl/manual/docblocks.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'cpp'
let b:doge_insert = 'above'

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
\  'parameters': {
\    'format': '@param {name} !description',
\  },
\  'typeParameters': {
\    'format': '@tparam {name} !description',
\  },
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches classes.
" ------------------------------------------------------------------------------
let s:class_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'nodeTypes': ['class_specifier', 'template_declaration'],
\})
unlet s:class_pattern['parameters']

" ------------------------------------------------------------------------------
" Matches (template) function- and class method declarations.
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'nodeTypes': [
\    'function_definition',
\    'declaration',
\    'template_declaration',
\    'function_declarator',
\  ],
\})

" ------------------------------------------------------------------------------
" Matches structs.
" ------------------------------------------------------------------------------
let s:struct_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'nodeTypes': ['struct_specifier', 'template_declaration'],
\})
unlet s:struct_pattern['parameters']

" ------------------------------------------------------------------------------
" Matches field declarations inside structs.
" ------------------------------------------------------------------------------
let s:field_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'nodeTypes': ['field_declaration'],
\  'template': [
\    '/**',
\    ' * @{name} !description',
\    ' */',
\  ],
\})
unlet s:field_pattern['parameters']
unlet s:field_pattern['typeParameters']

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================

call doge#buffer#register_doc_standard('doxygen_javadoc', [
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/**',
\      ' * @brief !description',
\      '%(typeParameters| *)%',
\      '%(typeParameters| * {typeParameters})%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/**',
\      ' * @brief !description',
\      ' *',
\      '%(typeParameters| * {typeParameters})%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/**',
\      ' * struct {name} - !description',
\      '%(typeParameters| *)%',
\      '%(typeParameters| * {typeParameters})%',
\      ' */',
\    ],
\  }),
\  s:field_pattern,
\])

call doge#buffer#register_doc_standard('doxygen_javadoc_no_asterisk', [
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/**',
\      '@brief !description',
\      '%(typeParameters|)%',
\      '%(typeParameters|{typeParameters})%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/**',
\      '@brief !description',
\      '',
\      '%(typeParameters|{typeParameters})%',
\      '%(parameters|{parameters})%',
\      '%(returnType|@return !description)%',
\      '*/',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/**',
\      'struct {name} - !description',
\      '%(typeParameters|)%',
\      '%(typeParameters|{typeParameters})%',
\      '*/',
\    ],
\  }),
\  s:field_pattern,
\])

call doge#buffer#register_doc_standard('doxygen_javadoc_banner', [
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/*******************************************************************************',
\      ' * @brief !description',
\      '%(typeParameters| *)%',
\      '%(typeParameters| * {typeParameters})%',
\      ' ******************************************************************************/',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/*******************************************************************************',
\      ' * @brief !description',
\      ' *',
\      '%(typeParameters| * {typeParameters})%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return !description)%',
\      ' ******************************************************************************/',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/*******************************************************************************',
\      ' * struct {name} - !description',
\      '%(typeParameters| *)%',
\      '%(typeParameters| * {typeParameters})%',
\      ' ******************************************************************************/',
\    ],
\  }),
\  s:field_pattern,
\])

call doge#buffer#register_doc_standard('doxygen_qt', [
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/*!',
\      ' * @brief !description',
\      '%(typeParameters| *)%',
\      '%(typeParameters| * {typeParameters})%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/*!',
\      ' * @brief !description',
\      ' *',
\      '%(typeParameters| * {typeParameters})%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/*!',
\      ' * struct {name} - !description',
\      '%(typeParameters| *)%',
\      '%(typeParameters| * {typeParameters})%',
\      ' */',
\    ],
\  }),
\  s:field_pattern,
\])

call doge#buffer#register_doc_standard('doxygen_qt_no_asterisk', [
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/*!',
\      '@brief !description',
\      '%(typeParameters|)%',
\      '%(typeParameters|{typeParameters})%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/*!',
\      '@brief !description',
\      '',
\      '%(typeParameters|{typeParameters})%',
\      '%(parameters|{parameters})%',
\      '%(returnType|@return !description)%',
\      '*/',
\    ],
\  }),
\  doge#helpers#deepextend(s:struct_pattern, {
\    'template': [
\      '/*!',
\      'struct {name} - !description',
\      '%(typeParameters|)%',
\      '%(typeParameters|{typeParameters})%',
\      '*/',
\    ],
\  }),
\  s:field_pattern,
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
