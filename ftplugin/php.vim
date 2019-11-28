" ==============================================================================
" The PHP documentation should follow the 'phpdoc' conventions.
" see https://www.phpdoc.org
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = ['phpdoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_php', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid PHP doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = {}

" ==============================================================================
" Define our base for every pattern.
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\%(\([[:alnum:]_\\]\+\)\s\+\)\?&\?\(\$[[:alnum:]_]\+\)\%(\s*=\s*\([[:alnum:]_]\+(.\{-})\|[^,]\+\)\+\)\?',
\    'match_group_names': ['type', 'name', 'default'],
\    'format': '@param {type|!type} {name}%(default| (optional))% !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
" Define the pattern types.
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
\  'match_group_names': ['propertyName'],
\  'parameters': v:false,
\})

" ------------------------------------------------------------------------------
" Matches a constructor function.
" ------------------------------------------------------------------------------
" public function __construct(...) {}
" ------------------------------------------------------------------------------
let s:constructor_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s\+\)*function\s\+__construct\s*(\(.\{-}\))\s*{',
\  'match_group_names': ['parameters'],
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
\  'match': '\m^\%(\%(public\|private\|protected\|static\|final\)\s\+\)*function\s*\%([^(]\+\)\s*(\(.\{-}\))\s*{',
\  'match_group_names': ['parameters'],
\})

" ==============================================================================
" Define the doc standards.
"
" s:class_property_pattern
"   The {type} will be added by the doge#preprocess#php#tokens() function.
"   See doge#preprocessors#php#tokens().
" ==============================================================================
let b:doge_patterns.phpdoc = [
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
\      ' * @return !type !description',
\      ' */',
\    ],
\  }),
\]

let &cpoptions = s:save_cpo
unlet s:save_cpo
