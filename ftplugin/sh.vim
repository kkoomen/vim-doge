" ==============================================================================
" The R documentation should follow the 'Roxygen2' conventions.
" see https://github.com/klutometis/roxygen
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'bash'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['google'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('sh')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions.
" ------------------------------------------------------------------------------
let s:function_pattern = {
\  'nodeTypes': ['function_definition'],
\}

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================

call doge#buffer#register_doc_standard('google', [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '################################################################################',
\      '# !description',
\      '# Globals:',
\      '# \t!var-name',
\      '# Arguments:',
\      '# \t$1: !description',
\      '# Outputs:',
\      '# \t!description',
\      '# Returns:',
\      '# \t!description',
\      '################################################################################',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
