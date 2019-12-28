" ==============================================================================
" The PHP documentation should follow the 'phpdoc' conventions.
" see https://www.phpdoc.org
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['phpdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('php')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
" Define our base for every pattern.
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\%(\([?|[:alnum:]_\\]\+\)\s\+\)\?&\?\(\$[[:alnum:]_]\+\)\%(\s*=\s*\([[:alnum:]_]\+(.\{-})\|[^,]\+\)\+\)\?',
\    'tokens': ['type', 'name', 'default'],
\    'format': '@param {type|!type} {name}%(default| (optional))% !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches class properties.
" ------------------------------------------------------------------------------
" protected $myProtectedVar;
" public $myPublicVar;
" public $myVarWithDefaultValue = 'string';
" ------------------------------------------------------------------------------
let s:class_property_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|static\|var\|const\)\s\+\)*\$\([[:alnum:]_]\+\)',
\  'tokens': ['propertyName'],
\})
unlet s:class_property_pattern['parameters']

" ------------------------------------------------------------------------------
" Matches a constructor function.
" ------------------------------------------------------------------------------
" public function __construct(...) {}
" ------------------------------------------------------------------------------
let s:constructor_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s\+\)*function\s\+__construct\s*(\(.\{-}\))\s*{',
\  'tokens': ['parameters'],
\})

" ------------------------------------------------------------------------------
" Matches regular function expressions and class methods.
" ------------------------------------------------------------------------------
" function myFunction(array &$p1, string $p2, &$p3 = NULL, \Drupal\core\Entity\Node $p4) {}
"
" function myFunction(QueryFactory $p4) {}
"
" public function myPublicMethod(
"   array &$p1,
"   \Test\Namespacing\With\A\ClassInterface $p2,
"   int $p3,
"   $p4,
"   $p5 = NULL
" ) {}
" ------------------------------------------------------------------------------
let s:function_and_class_method_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s\+\)*function\s*\%([^(]\+\)\s*(\(.\{-}\))\%(\s*:\s*\([?[:alnum:]_|]\+\)\)\?\s*{',
\  'tokens': ['parameters', 'returnType'],
\})

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
" s:class_property_pattern
"   The {type} will be added by the doge#preprocess#php#tokens() function.
"   See doge#preprocessors#php#tokens().
" ==============================================================================
call doge#buffer#register_doc_standard('phpdoc', [
\  doge#helpers#deepextend(s:class_property_pattern, {
\    'template': [
\      '/**',
\      ' * @var {type|!type}',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:constructor_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      ' * @return {returnType|!type} !description',
\      ' */',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
