" ==============================================================================
" The Python documentation should follow one of the following conventions:
" - reST: http://daouzli.com/blog/docstring.html#restructuredtext
" - Numpy: http://daouzli.com/blog/docstring.html#numpydoc
" - Google: https://github.com/google/styleguide/blob/gh-pages/pyguide.md
" - Sphinx: https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

if !exists('g:doge_python_settings')
  let g:doge_python_settings = {
  \  'single_quotes': 0,
  \  'omit_redundant_param_types': 1,
  \}
endif

let b:doge_parser = 'python'
let b:doge_insert = 'below'

let b:doge_supported_doc_standards = [
      \ 'reST',
      \ 'numpy',
      \ 'google',
      \ 'sphinx',
      \ ]
let b:doge_doc_standard = doge#buffer#get_doc_standard('python')

let &cpoptions = s:save_cpo
unlet s:save_cpo
