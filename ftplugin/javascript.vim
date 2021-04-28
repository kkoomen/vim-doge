" ==============================================================================
" The JavaScript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'typescript'
let b:doge_insert = 'above'

if !exists('g:doge_javascript_settings')
  let g:doge_javascript_settings = {
  \  'destructuring_props': 1,
  \  'omit_redundant_param_types': 0,
  \}
endif

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['jsdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('javascript')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================

call doge#buffer#register_doc_standard('jsdoc', [
\  {
\    'nodeTypes': ['class_declaration', 'class'],
\    'typeParameters': {
\      'format': '@template {name|!name} - !description',
\    },
\    'template': [
\      '/**',
\      ' * !description',
\      '%(typeParameters| * {typeParameters})%',
\      '%(parentName| * @extends {parentName})%',
\      '%(interfaceName| * @implements {interfaceName})%',
\      ' */',
\    ],
\  },
\  {
\    'nodeTypes': ['member_expression'],
\    'parameters': {
\      'format': '@param %(showType|{{type|!type}})% %(default|[)%{name|!name}%(default|])% - !description',
\    },
\    'exceptions': {
\      'format': '@throws {{name|!name}} - !description',
\    },
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      ' * @function {functionName}#{propertyName}',
\      '%(async| * @async)%',
\      '%(generator| * @generator)%',
\      '%(typeParameters| * {typeParameters})%',
\      '%(parameters| * {parameters})%',
\      '%(exceptions| * {exceptions})%',
\      '%(returnType| * @return {{returnType|!type}} !description)%',
\      ' */',
\    ],
\  },
\  {
\    'nodeTypes': [
\      'arrow_function',
\      'function',
\      'function_declaration',
\      'function_signature',
\      'method_definition',
\      'generator_function',
\      'generator_function_declaration',
\    ],
\    'parameters': {
\      'format': '@param %(showType|{{type|!type}})% %(optional|[)%{name|!name}%(optional|])% - !description',
\    },
\    'typeParameters': {
\      'format': '@template {name|!name} - !description',
\    },
\    'exceptions': {
\      'format': '@throws {{name|!name}} - !description',
\    },
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(static| * @static)%',
\      '%(async| * @async)%',
\      '%(generator| * @generator)%',
\      '%(typeParameters| * {typeParameters})%',
\      '%(parameters| * {parameters})%',
\      '%(exceptions| * {exceptions})%',
\      '%(returnType| * @return)% %(showReturnType|{{returnType|!type}})% %(returnType|!description)%',
\      ' */',
\    ],
\  },
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
