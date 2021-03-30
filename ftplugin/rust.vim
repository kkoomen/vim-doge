" ==============================================================================
" The Rust documentation should follow the 'rustdoc' conventions.
" see https://doc.rust-lang.org/rust-by-example/meta/doc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'rust'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['rustdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('rs')
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
\  'nodeTypes': ['function_item'],
\  'parameters': {
\    'format': '* `{name}` - !description'
\  },
\}

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================

call doge#buffer#register_doc_standard('rustdoc', [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/// !description',
\      '%(parameters|///)%',
\      '%(parameters|/// # Arguments)%',
\      '%(parameters|///)%',
\      '%(parameters|/// {parameters})%',
\      '%(unsafe|///)%',
\      '%(unsafe|/// # Safety)%',
\      '%(unsafe|///)%',
\      '%(unsafe|/// !description)%',
\      '%(errors|///)%',
\      '%(errors|/// # Errors)%',
\      '%(errors|///)%',
\      '%(errors|/// !description)%',
\      '///',
\      '/// # Examples',
\      '///',
\      '/// ```',
\      '/// !example',
\      '/// ```',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
