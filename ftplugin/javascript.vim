" ==============================================================================
" The JavaScript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

" let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
" let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_parser = 'typescript'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['jsdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('javascript')
let b:doge_patterns = doge#buffer#get_patterns()

" let s:object_functions_pattern = doge#helpers#deepextend(s:pattern_base, {
" \  'match': '\m^[[:punct:]]\?\([[:alnum:]_-]\+\)[[:punct:]]\?\s*:\s*\(async\)\?\s*\%(function\)\?\s*\%([[:alnum:]_]\+\)\?(\(.\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\%(\s*=>\s*\)\?\s*[({]',
" \  'tokens': ['funcName', 'async', 'parameters', 'return_type'],
" \})

" let s:class_pattern = doge#helpers#deepextend(s:pattern_base, {
" \  'match': '\m^\%(\%(export\|export\s\+default\)\s\+\)\?class\s\+\%([[:alnum:]_$]\+\)\%(\s\+extends\s\+\([[:alnum:]_$.]\+\)\)\?\%(\s\+implements\s\+\([[:alnum:]_$.]\+\)\)\?\s*{',
" \  'tokens': ['parentClassName', 'interfaceName'],
" \})
" unlet s:class_pattern['parameters']

" let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
" \  'match': '\m^\%(\%(export\|export\s\+default\|public\|private\|protected\)\s\+\)*\(static\s\+\)\?\(async\s\+\)\?\%(function\(\*\)\?\s*\)\?\%([[:alnum:]_$]\+\)\?\s*\%(<[[:alnum:][:space:]_,=]*>\)\?\s*(\s*\(\%(\%(@[[:alnum:]_]\+(\s*.\{-})\)\s\+\)\?.\{-}\)\s*)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>&]\+\))\?\)\?\s*[{(]',
" \  'tokens': ['static', 'async', 'generator', 'parameters', 'return_type'],
" \})

" let s:prototype_pattern = doge#helpers#deepextend(s:pattern_base, {
" \  'match': '\m^\([[:alnum:]_$]\+\)\.prototype\.\([[:alnum:]_$]\+\)\s*=\s*\(async\s\+\)\?\%(function\(\*\)\?\s*\)\?({\?\([^>]\{-}\)}\?)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\(=>\s*\)\?[{(]',
" \  'tokens': ['className', 'funcName', 'async', 'generator', 'parameters', 'return_type'],
" \})

" let s:fat_arrow_function_pattern = doge#helpers#deepextend(s:pattern_base, {
" \  'match': '\m^\%(\%(export\|export\s\+default\)\s\+\)\?\%(\%(\%(var\|const\|let\)\s\+\)\?\%(\(static\)\s\+\)\?\([[:alnum:]_$]\+\)\)\?\s*=\s*\(static\s\+\)\?\(async\s\+\)\?\%(function\(\*\)\?\s*\)\?\(({\?[^>]\{-}}\?)\|[[:alnum:]_$]\+\)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\%(=>\s*\)\?[^ ]\{-}',
" \  'tokens': ['static', 'funcName', 'static', 'async', 'generator', 'parameters', 'return_type'],
" \})

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================

call doge#buffer#register_doc_standard('jsdoc', [
\  {
\    'node_types': ['class_declaration'],
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parentName| * @extends {parentName})%',
\      '%(interfaceName| * @implements {interfaceName})%',
\      ' */',
\    ],
\  },
\  {
\    'node_types': ['arrow_function', 'function', 'function_declaration', 'method_definition', 'generator_function_declaration'],
\    'parameters': {
\      'format': '@param {{type|!type}} %(default|[)%{name}%(default|])% - !description',
\    },
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(static| * @static)%',
\      '%(async| * @async)%',
\      '%(generator| * @generator)%',
\      '%(parameters| * {parameters})%',
\      '%(return_type| * @return {{return_type|!type}} !description)%',
\      ' */',
\    ],
\  },
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
