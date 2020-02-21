" ==============================================================================
" The JavaScript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['jsdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('javascript')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
" The parameters.match describes the following pattern:
"   <param-access> <param-name>: <param-type> = <param-default-value>
" ==============================================================================

let s:pattern_base = {
\  'parameters': {
\    'match': '\m\%(\%(public\|private\|protected\)\?\s*\)\?\([[:alnum:]_$]\+\)?\?\%(\s*:\s*\([[:alnum:]._| ]\+\%(\[[[:alnum:][:space:]_[\],]*\]\)\?\|([[:alnum:].:_| ]\+)\s*=>\s*[[:alnum:]_.]\+\)\)\?\%(\s*=\s*\([[:alnum:]_.]\+(.\{-})\|[^,]\+\)\+\)\?',
\    'tokens': ['name', 'type', 'default'],
\    'format': '@param {{type|!type}} %(default|[)%{name}%(default|])% - !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches fat-arrow / functions inside objects.
" ------------------------------------------------------------------------------
" myKey: function myRealFunction(p1, p2) {}
" myKey: async function myRealFunction(p1, p2) {}
" myKey: (p1, p2) => {}
" myKey: async (p1, p2) => {}
" ------------------------------------------------------------------------------
let s:object_functions_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^[[:punct:]]\?\([[:alnum:]_-]\+\)[[:punct:]]\?\s*:\s*\(async\)\?\s*\%(function\)\?\s*\%([[:alnum:]_]\+\)\?(\(.\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\%(\s*=>\s*\)\?\s*[({]',
\  'tokens': ['funcName', 'async', 'parameters', 'returnType'],
\})

" ------------------------------------------------------------------------------
" Matches class declarations.
" ------------------------------------------------------------------------------
" export class Child {}
" class Child extends Parent {}
" class Child implements CustomInterfaceName {}
" export class Child extends Parent implements CustomInterfaceName {}
" ------------------------------------------------------------------------------
let s:class_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(export\s*\)\?class\s\+\%([[:alnum:]_$]\+\)\%(\s\+extends\s\+\([[:alnum:]_$.]\+\)\)\?\%(\s\+implements\s\+\([[:alnum:]_$.]\+\)\)\?\s*{',
\  'tokens': ['parentClassName', 'interfaceName'],
\})
unlet s:class_pattern['parameters']

" ------------------------------------------------------------------------------
" Matches regular and typed functions with default parameters.
" ------------------------------------------------------------------------------
" function add(one: any, two: any = 'default'): number {}
" export function configureStore(history: History, initialState: object): Store<AppState> {}
" function configureStore(history: History, initialState: object): Store {}
" function rollDice(): 1 | 2 | 3 | 4 | 5 | 6 {}
" function pluck<T, K extends keyof T>(o: T, names: K[]): T[K][] {}
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(export\|public\|private\|protected\)\s\+\)*\(static\s\+\)\?\(async\s\+\)\?\%(function\(\*\)\?\s*\)\?\%([[:alnum:]_$]\+\)\?\s*\%(<[[:alnum:][:space:]_,=]*>\)\?\s*(\(.\{-}\))\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*[{(]',
\  'tokens': ['static', 'async', 'generator', 'parameters', 'returnType'],
\})

" ------------------------------------------------------------------------------
" Matches prototype functions.
" ------------------------------------------------------------------------------
" Person.prototype.greet = (p1: string = 'default', p2: Immutable.List = Immutable.List()) => {};
" Person.prototype.greet = function (p1: string = 'default', p2: Immutable.List = Immutable.List()) {};
" Person.prototype.greet = function*(p1: string = 'default', p2: Immutable.List = Immutable.List()) {};
" ------------------------------------------------------------------------------
let s:prototype_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\([[:alnum:]_$]\+\)\.prototype\.\([[:alnum:]_$]\+\)\s*=\s*\(async\s\+\)\?\%(function\(\*\)\?\s*\)\?({\?\([^>]\{-}\)}\?)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\(=>\s*\)\?[{(]',
\  'tokens': ['className', 'funcName', 'async', 'generator', 'parameters', 'returnType'],
\})

" ------------------------------------------------------------------------------
" Matches fat-arrow functions.
" ------------------------------------------------------------------------------
" var myFunc = function($p1 = 'value', p2 = [], p3, p4) {}
" var myFunc = function*($p1 = 'value', p2 = [], p3, p4) {}
" var myFunc = async function*($p1 = 'value', p2 = [], p3, p4) {}
" var myFunc = async ($p1 = 'value', p2 = [], p3, p4) => {}
" (p1: array = []) => (p2: string) => { console.log(5); }
" (p1: array = []) => (p2: string) => { console.log(5); }
" static myMethod({ b: number }): number {}
" static async myMethod({ b: number }): number {}
" const user = (p1 = 'default') => (subp1, subp2 = 'default') => 5;
" const foo = bar => baz
" export const foo = bar => baz
" (p1: string = 'default', p2: int = 5, p3, p4: Immutable.List = [], p5: string[] = [], p6: float = 0.5): number[] => { };
" ------------------------------------------------------------------------------
let s:fat_arrow_function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(export\s\+\)\?\%(\%(\%(var\|const\|let\)\s\+\)\?\%(\(static\)\s\+\)\?\([[:alnum:]_$]\+\)\)\?\s*=\s*\(static\s\+\)\?\(async\s\+\)\?\%(function\(\*\)\?\s*\)\?\(({\?[^>]\{-}}\?)\|[[:alnum:]_$]\+\)\%(\s*:\s*(\?\([[:alnum:][:space:]_[\].,|<>]\+\))\?\)\?\s*\%(=>\s*\)\?[^ ]\{-}',
\  'tokens': ['static', 'funcName', 'static', 'async', 'generator', 'parameters', 'returnType'],
\})

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('jsdoc', [
\  doge#helpers#deepextend(s:object_functions_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(async| * @{async})%',
\      ' * @function {funcName|}',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return {{returnType|!type}} !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parentClassName| * @extends {parentClassName})%',
\      '%(interfaceName| * @implements {interfaceName})%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(static| * @static)%',
\      '%(async| * @async)%',
\      '%(generator| * @generator)%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return {{returnType|!type}} !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:prototype_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(async| * @async)%',
\      ' * @function {className}#{funcName}',
\      '%(generator| * @generator)%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return {{returnType|!type}} !description)%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:fat_arrow_function_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      ' *',
\      '%(static| * @static)%',
\      '%(async| * @async)%',
\      ' * @function {funcName|}',
\      '%(generator| * @generator)%',
\      '%(parameters| * {parameters})%',
\      '%(returnType| * @return {{returnType|!type}} !description)%',
\      ' */',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
