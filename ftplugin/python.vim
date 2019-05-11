" ==============================================================================
" Filename: python.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================
"
" The python documentation should follow the 'Sphinx reST' conventions.
" see: http://daouzli.com/blog/docstring.html#restructuredtext

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

""
" ==============================================================================
" Matches regular function expressions and class methods.
" ==============================================================================
"
" {match}: Should match at least the following scenarios:
"   - def myFunc(...):
"   - def myFunc(...) -> None:
"   - def myFunc(...) -> Sequence[T]:
"   - def myFunc(...) -> Generator[int, float, str]
"
"   Regex explanation
"     \m
"       Use magic notation.
"
"     ^
"       Matches the position before the first character in the string.
"
"     def \([^(]\+\)\s*
"       This group should match the function name.
"       ------------------------------------------------------------------------
"       Matches the word 'def', followed by a captured group, followed by some
"       additional whitespace. The group uses the pattern '[^(]\+' to allow any
"       character until a '(' character is found. Followed by 0 or more spaces,
"       denoted as '\s*'.
"
"     (\(.\{-}\))
"       This group should match the parameters.
"       ------------------------------------------------------------------------
"       Matches a single captured group which matches any character, but as few
"       as possible, denoted as '.\{-}'. We use \{-} to ensure it will match as
"       few matches as possible, which prevents wrong parsing when the input
"       contains nested functions.
"
"     \%(\s*->\s*\(.\{-}\)\)\?\s*:
"       The captured group should match the return type.
"       ------------------------------------------------------------------------
"       Matches a non-captured group containing a single captured group which
"       matches any character, but as few as possible, denoted as '.\{-}',
"       followed by 0 or more spaces and a colon, denoted as '\s*:'.
"
" {parameters.match}: Should match at least the following scenarios:
"   - param1
"   - param1: float
"   - param1 = None
"   - param1: str = 'string'
"   - param1: Callable[[int], None]
"   - param1: Callable[[int], None] = {}
"   - param1: Callable[[int], None] = True
"   - param1: Callable[[int], None] = False
"   - param1: Callable[[int, Exception], None]
"   - param1: Sequence[T]
"
"   Regex explanation
"     \m
"       Use magic notation.
"
"     \([a-zA-Z0-9_]\+\)
"       This group should match the parameter name.
"       ------------------------------------------------------------------------
"       Matches a captured group containing 1 or more of the following
"       characters: '[a-zA-Z0-9_]'.
"
"     \%(:\s*\([a-zA-Z0-9_]\+\%(\[[a-zA-Z0-9_\[\], ]\+\]\)\?\)\)\?
"       This group should match the parameter type.
"       ------------------------------------------------------------------------
"       Matches an optional and non-capturing group, denoted as \%( ... \)\?
"       which should start with the character ':' followed by 0 or more spaces,
"       followed by the type itself, which is denoted as:
"
"       \([a-zA-Z0-9_]\+\%(\[[a-zA-Z0-9_\[\], ]\+\]\)\?\)
"
"         [a-zA-Z0-9_]\+
"           This will match words as: 'str', 'int', etc.
"
"         \%(\[[a-zA-Z0-9_\[\], ]\+\]\)\?
"           This will match an optional and non-capturing group which is used
"           for typings like: 'Callable[[int, Exception], None]'.
"
"     \%(\s*=\s*\([^,]\+\)\)\?
"       This group should match the parameter default value.
"       ------------------------------------------------------------------------
"       Matches an optional and non-capturing group, denoted as \%( ... \)\?
"       which may contain the pattern ' = VALUE'. The 'VALUE' should contain 1
"       or more of the following characters: '[^,]'.
call add(b:doge_patterns, {
      \   'match': '\m^def \([^(]\+\)\s*(\(.\{-}\))\%(\s*->\s*\(.\{-}\)\)\?\s*:',
      \   'match_group_names': ['funcName', 'parameters', 'returnType'],
      \   'parameters': {
      \     'match': '\m\([a-zA-Z0-9_]\+\)\%(:\s*\([a-zA-Z0-9_]\+\%(\[[a-zA-Z0-9_\[\], ]\+\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\)\?',
      \     'match_group_names': ['name', 'type', 'default'],
      \     'format': [':param', '{name}', '{type|any}:', 'TODO'],
      \   },
      \   'comment': {
      \     'insert': 'below',
      \     'opener': '"""',
      \     'closer': '"""',
      \     'template': [
      \       '"""',
      \       'TODO',
      \       '',
      \       '{parameters}',
      \       '!:rtype {returnType}: TODO',
      \       '"""',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo
