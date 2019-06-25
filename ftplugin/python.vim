" ==============================================================================
" The python documentation should follow the 'Sphinx reST' conventions.
" see: http://daouzli.com/blog/docstring.html#restructuredtext
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" Matches the following scenarios:
"
"   def __init__(self: MyClass):
"
"   def myMethod(self: MyClass, p1: Sequence[T]) -> Generator[int, float, str]:
"
"   def call(self, *args: str, **kwargs: str) -> str:
"
"   def myFunc(p1: Callable[[int], None] = False, p2: Callable[[int, Exception], None]) -> Sequence[T]:
call add(b:doge_patterns, {
\  'match': '\m^def\s\+\%([^(]\+\)\s*(\(.\{-}\))\%(\s*->\s*\(.\{-}\)\)\?\s*:',
\  'match_group_names': ['parameters', 'returnType'],
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\)\%(:\s*\([[:alnum:]_]\+\%(\[[[:alnum:]_[\],[:space:]]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\)\?',
\    'match_group_names': ['name', 'type', 'default'],
\    'format': [':param', '{name}', '{type|any}:', 'TODO'],
\  },
\  'comment': {
\    'insert': 'below',
\    'template': [
\      '"""',
\      'TODO',
\      '',
\      '!{parameters}',
\      '!:rtype {returnType}: TODO',
\      '"""',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
