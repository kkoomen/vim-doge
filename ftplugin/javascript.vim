" ==============================================================================
" The JavaScript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = ['jsdoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_javascript', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid JavaScript doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

" Matches the following pattern:
"   <param-access> <param-name>: <param-type> = <param-default-value>
let s:parameters_match_pattern = '\m\%(\%(public\|private\|protected\)\?\s*\)\?\([[:alnum:]_$]\+\)\%(\s*:\s*\([[:alnum:]._| ]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\)\)\?\%(\s*=\s*\([[:alnum:]_.]\+(.\{-})\|[^,]\+\)\+\)\?'

" ==============================================================================
" Matches fat-arrow / functions inside objects.
" ==============================================================================
"
" Matches the following scenarios:
"
"   myKey: function myRealFunction(p1, p2) {}
"
"   myKey: async function myRealFunction(p1, p2) {}
"
"   myKey: (p1, p2) => {}
"
"   myKey: async (p1, p2) => {}
call add(b:doge_patterns, {
\  'match': '\m^[[:punct:]]\?\([[:alnum:]_-]\+\)[[:punct:]]\?\s*:\s*\(async\)\?\s*\%(function\)\?\s*\%([[:alnum:]_]\+\)\?(\(.\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\%(\s*=>\s*\)\?\s*[({]',
\  'match_group_names': ['funcName', 'async', 'parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': {
\      'jsdoc': '@param {{type|!type}} {name} - !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'jsdoc': [
\        '/**',
\        ' * !description',
\        '%(async| * @{async})%',
\        ' * @function {funcName|}',
\        '%(parameters| * {parameters})%',
\        ' * @return {{returnType|!type}} !description',
\        ' */',
\      ],
\    },
\  },
\})

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
\  'match': '\m^\%(export\s*\)\?class\s\+\%([[:alnum:]_$]\+\)\%(\s\+extends\s\+\([[:alnum:]_$.]\+\)\)\?\%(\s\+implements\s\+\([[:alnum:]_$.]\+\)\)\?\s*{',
\  'match_group_names': ['parentClassName', 'interfaceName'],
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'jsdoc': [
\        '/**',
\        ' * !description',
\        '%(parentClassName| * @extends {parentClassName})%',
\        '%(interfaceName| * @implements {interfaceName})%',
\        ' */',
\      ],
\    },
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
\  'match': '\m^\%(export\s\+\)\?\(static\s\+\)\?\(async\s\+\)\?\%(function\*\?\s*\)\?\%([[:alnum:]_$]\+\)\?\s*\%(<[[:alnum:][:space:]_,]*>\)\?\s*(\([^>]\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*[{(]',
\  'match_group_names': ['static', 'async', 'parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': {
\      'jsdoc': '@param {{type|!type}} {name} - !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'jsdoc': [
\        '/**',
\        ' * !description',
\        '%(static| * @static)%',
\        '%(async| * @async)%',
\        '%(parameters| * {parameters})%',
\        ' * @return {{returnType|!type}} !description',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Matches prototype functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   Person.prototype.greet = (p1: string = 'default', p2: Immutable.List = Immutable.List()) => {};
"
"   Person.prototype.greet = function (p1: string = 'default', p2: Immutable.List = Immutable.List()) {};
"
"   Person.prototype.greet = function*(p1: string = 'default', p2: Immutable.List = Immutable.List()) {};
call add(b:doge_patterns, {
\  'match': '\m^\([[:alnum:]_$]\+\)\.prototype\.\([[:alnum:]_$]\+\)\s*=\s*\(async\s\+\)\?\%(function\*\?\s*\)\?({\?\([^>]\{-}\)}\?)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\(=>\s*\)\?[{(]',
\  'match_group_names': ['className', 'funcName', 'async', 'parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': {
\      'jsdoc': '@param {{type|!type}} {name} - !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'jsdoc': [
\        '/**',
\        ' * !description',
\        '%(async| * @async)%',
\        ' * @function {className}#{funcName}',
\        '%(parameters| * {parameters})%',
\        ' * @return {{returnType|!type}} !description',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Matches fat-arrow functions.
" ==============================================================================
"
"   var myFunc = function($p1 = 'value', p2 = [], p3, p4) {}
"
"   var myFunc = function*($p1 = 'value', p2 = [], p3, p4) {}
"
"   var myFunc = async function*($p1 = 'value', p2 = [], p3, p4) {}
"
"   var myFunc = async ($p1 = 'value', p2 = [], p3, p4) => {}
"
"   (p1: array = []) => (p2: string) => { console.log(5); }
"
"   (p1: array = []) => (p2: string) => { console.log(5); }
"
"   static myMethod({ b: number }): number {}
"
"   static async myMethod({ b: number }): number {}
"
"   const user = (p1 = 'default') => (subp1, subp2 = 'default') => 5;
"
"   const foo = bar => baz
"
"   export const foo = bar => baz
"
"   (p1: string = 'default', p2: int = 5, p3, p4: Immutable.List = [], p5: string[] = [], p6: float = 0.5): number[] => { };
call add(b:doge_patterns, {
\  'match': '\m^\%(export\s\+\)\?\%(\%(\%(var\|const\|let\)\s\+\)\?\%(\(static\)\s\+\)\?\([[:alnum:]_$]\+\)\)\?\s*=\s*\(static\s\+\)\?\(async\s\+\)\?\%(function\*\?\s*\)\?\(({\?[^>]\{-}}\?)\|[[:alnum:]_$]\+\)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\%(=>\s*\)\?[^ ]\{-}',
\  'match_group_names': ['static', 'funcName', 'static', 'async',  'parameters', 'returnType'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': {
\      'jsdoc': '@param {{type|!type}} {name} - !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'jsdoc': [
\        '/**',
\        ' * !description',
\        '%(static| * @static)%',
\        '%(async| * @async)%',
\        ' * @function {funcName|}',
\        '%(parameters| * {parameters})%',
\        ' * @return {{returnType|!type}} !description',
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
