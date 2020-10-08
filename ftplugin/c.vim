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

let b:doge_parser = 'c'
let b:doge_insert = 'above'

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
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions.
" ------------------------------------------------------------------------------
let s:function_pattern = {
\  'nodeTypes': ['function_definition', 'declaration'],
\  'parameters': {
\    'format': '@param {name} !description',
\  },
\}

" ------------------------------------------------------------------------------
" Matches structs.
" ------------------------------------------------------------------------------
let s:struct_pattern = {
\  'nodeTypes': ['struct_specifier'],
\}

" ------------------------------------------------------------------------------
" Matches field declarations inside structs.
" ------------------------------------------------------------------------------
let s:field_pattern = {
\  'nodeTypes': ['field_declaration'],
\  'template': [
\    '/**',
\    ' * @{name} !description',
\    ' */',
\  ],
\}

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
\      ' */',
\    ],
\  }),
\  s:field_pattern,
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
