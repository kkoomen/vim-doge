" ==============================================================================
" The PHP documentation should follow the 'phpdoc' conventions.
" see https://www.phpdoc.org
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" ==============================================================================
" Matches class properties.
" ==============================================================================
"
" Matches the following scenarios:
"
"   protected $myProtectedVar;
"
"   public $myPublicVar;
"
"   public $myVarWithDefaultValue = 'string';
"
" The {type} will be added by the doge#preprocess#php#tokens() function.
" See doge#preprocessors#php#tokens().
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(public\|private\|protected\|var\)\s\+\)$\([[:alnum:]_]\+\)',
\  'match_group_names': ['propertyName'],
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * @var {type}',
\      ' */',
\    ],
\  },
\})

" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" Matches the following scenarios:
"
"   function myFunction(array &$arg1, string $arg2, &$arg3 = NULL, \Drupal\core\Entity\Node $arg4) {}
"
"   function myFunction(QueryFactory $arg4) {}
"
"   public function myPublicMethod(
"     array &$arg1,
"     \Test\Namespacing\With\A\ClassInterface $arg2,
"     int $arg3,
"     $arg4,
"     $arg5 = NULL
"   ) {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(public\|private\|protected\)\s\+\)\?\%(\%(static\)\s\+\)\?\%(\%(final\)\s\+\)\?function\s*\([^(]\+\)\s*(\(.\{-}\))\s*{',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': '\m\%(\([[:alnum:]_\\]\+\)\s\+\)\?&\?\($[[:alnum:]_]\+\)\%(\s*=\s*[^,]\+\)\?',
\    'match_group_names': ['type', 'name'],
\    'format': ['@param {type|mixed} {name} TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * TODO',
\      ' *',
\      ' * {parameters}',
\      ' */',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
