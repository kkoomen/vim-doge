" ==============================================================================
" The Python documentation should follow one of the following conventions:
" - reST: http://daouzli.com/blog/docstring.html#restructuredtext
" - Numpy: http://daouzli.com/blog/docstring.html#numpydoc
" - Google: https://github.com/google/styleguide/blob/gh-pages/pyguide.md
" - Sphinx: https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m#.\{-}$'
let b:doge_pattern_multi_line_comment = '\m\(""".\{-}"""\|' . "'''.\\{-}'''" . '\)'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards([
      \ 'reST',
      \ 'numpy',
      \ 'google',
      \ 'sphinx',
      \ ])
let b:doge_doc_standard = doge#buffer#get_doc_standard('python')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\([[:alnum:]_]\+\)\%(\s*:\s*\([[:alnum:]_.]\+\%(\[[[:alnum:]_[\],[:space:]]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\)\?',
\    'tokens': ['name', 'type', 'default'],
\  },
\  'insert': 'below',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular function expressions and class methods.
" ------------------------------------------------------------------------------
" def __init__(self: MyClass):
" def myMethod(self: MyClass, p1: Sequence[T]) -> Generator[int, float, str]:
" def call(self, *args: str, **kwargs: str) -> str:
" def myFunc(p1: Callable[[int], None] = False, p2: Callable[[int, Exception], None]) -> Sequence[T]:
" ------------------------------------------------------------------------------
let s:function_and_class_method_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^def\s\+\%([^(]\+\)\s*(\(.\{-}\))\%(\s*->\s*\(.\{-}\)\)\?\s*:',
\  'tokens': ['parameters', 'returnType'],
\})

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('reST', [
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'parameters': {
\      'format': ':param {name} {type|!type}: !description',
\    },
\    'template': [
\      '"""',
\      '!description',
\      '',
\      '%(parameters|{parameters})%',
\      '%(returnType|:rtype {returnType}: !description)%',
\      '"""',
\    ],
\  }),
\])

call doge#buffer#register_doc_standard('sphinx', [
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'parameters': {
\      'format': [
\        ':param {name}: !description%(default|, defaults to {default})%',
\        ':type {name}: {type|!type}%(default|, optional)%',
\      ],
\    },
\    'template': [
\      '"""',
\      '!description',
\      '',
\      '%(parameters|{parameters})%',
\      '%(returnType|:return: !description)%',
\      '%(returnType|:rtype: {returnType})%',
\      '"""',
\    ],
\  }),
\])

call doge#buffer#register_doc_standard('numpy', [
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'parameters': {
\      'format': [
\        '{name} : {type|!type}',
\        '\t!description',
\      ],
\    },
\    'template': [
\      '"""',
\      '!summary',
\      '',
\      '!description',
\      '%(parameters|)%',
\      '%(parameters|Parameters)%',
\      '%(parameters|----------)%',
\      '%(parameters|{parameters})%',
\      '%(returnType|)%',
\      '%(returnType|Returns)%',
\      '%(returnType|-------)%',
\      '%(returnType|{returnType}:)%',
\      '%(returnType|\t!description)%',
\      '"""',
\    ],
\  }),
\])

call doge#buffer#register_doc_standard('google', [
\  doge#helpers#deepextend(s:function_and_class_method_pattern, {
\    'parameters': {
\      'format': '{name} ({type|!type}%(default|, optional)%): !description',
\    },
\    'template': [
\      '"""!summary',
\      '',
\      '!description',
\      '%(parameters|)%',
\      '%(parameters|Args:)%',
\      '%(parameters|\t{parameters})%',
\      '%(returnType|)%',
\      '%(returnType|Returns:)%',
\      '%(returnType|\t{returnType}: !description)%',
\      '"""',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
