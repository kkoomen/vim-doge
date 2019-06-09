" ==============================================================================
" The typescript documentation should follow the 'jsdoc' conventions, since
" there is no official typescript documentation.
" see https://jsdoc.app
"
" This ftplugin should always reflect the logic of the ftplugin/javascript.vim.
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" Matches the following pattern:
"   <param-access> <param-name>: <param-type> = <param-default-value>
let s:parameters_match_pattern = '\m\%(\%(public\|private\|protected\)\?\s*\)\?\([[:alnum:]_$]\+\)\%(\s*:\s*\([[:alnum:][:space:]._|]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\+\)\?'

" ==============================================================================
" Matches class declarations.
" ==============================================================================
"
" Matches the following scenarios:
"
"   export class Child {}
"
"   class Child extends Parent {}
"
"   class Child implements CustomInterfaceName {}
"
"   export class Child extends Parent implements CustomInterfaceName {}
call add(b:doge_patterns, {
\  'match': '\m^\%(export\s*\)\?class\s\+\([[:alnum:]_$]\+\)\%(\s\+extends\s\+\([[:alnum:]_$]\+\)\)\?\%(\s\+implements\s\+\([[:alnum:]_$]\+\)\)\?\s*{',
\  'match_group_names': ['className', 'parentClassName', 'interfaceName'],
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * @description TODO',
\      '! * @extends {parentClassName}',
\      '! * @implements {interfaceName}',
\      ' */',
\    ],
\  },
\})

""
" ==============================================================================
" Matches regular and typed functions with default parameters.
" ==============================================================================
"
" Matches the following scenarios:
"
"   function add(one: any, two: any = 'default'): number {}

"   export function configureStore(history: History, initialState: object): Store<AppState> {}
"
"   function configureStore(history: History, initialState: object): Store {}
"
"   function rollDice(): 1 | 2 | 3 | 4 | 5 | 6 {}
"
"   function pluck<T, K extends keyof T>(o: T, names: K[]): T[K][] {}
call add(b:doge_patterns, {
\  'match': '\m^\%(export\s\+\)\?\%(function\s*\)\?\([[:alnum:]_$]\+\)\?\%(<[[:alnum:][:space:]_,]*>\)\?(\([^>]\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*[{(]',
\  'match_group_names': ['funcName', 'parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': ['@param', '!{{type|*}}', '{name}', '- TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * @description TODO',
\      ' * {parameters}',
\      '! * @return {{returnType}} TODO',
\      ' */',
\    ],
\  },
\})

" ==============================================================================
" Matches prototype functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   Person.prototype.greet = (arg1: string = 'default', arg2: Immutable.List = Immutable.List()) => {};
"
"   Person.prototype.greet = function (arg1: string = 'default', arg2: Immutable.List = Immutable.List()) {};
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_$]\+\)\.prototype\.\([[:alnum:]_$]\+\)\s*=\s*\%(function\s*\)\?({\?\([^>]\{-}\)}\?)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\(=>\s*\)\?[{(]',
\  'match_group_names': ['className', 'funcName', 'parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': ['@param', '!{{type|*}}', '{name}', '- TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * @description TODO',
\      ' * @function {className}#{funcName}',
\      ' * {parameters}',
\      '! * @return {{returnType}} TODO',
\      ' */',
\    ],
\  },
\})

" ==============================================================================
" Matches fat-arrow functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   ((window, document, $) => {
"     // ...
"   })(window, document, jQuery);
"
"   (arg1: array = []) => (arg2: string) => { console.log(5); }
"
"   const user = (arg1 = 'default') => (subarg1, subarg2 = 'default') => 5;
"
"   (arg1: string = 'default', arg2: int = 5, arg3, arg4: Immutable.List = [], arg5: string[] = [], arg6: float = 0.5): number[] => { };
"
"   var myFunc = function($arg1 = 'value', arg2 = [], arg3, arg4) {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(\%(var\|const\|let\)\s\+\)\?\([[:alnum:]_$]\+\)\s*=\s*\)\?\%(function\s*\)\?({\?\([^>]\{-}\)}\?)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\(=>\s*\)\?[{(]',
\  'match_group_names': ['funcName', 'parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': ['@param', '!{{type|*}}', '{name}', '- TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'template': [
\      '/**',
\      ' * @description TODO',
\      ' * @function {funcName|}',
\      ' * {parameters}',
\      '! * @return {{returnType}} TODO',
\      ' */',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
