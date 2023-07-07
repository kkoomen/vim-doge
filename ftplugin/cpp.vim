" ==============================================================================
" The C++ documentation should follow the 'Doxygen' conventions.
" see http://www.doxygen.nl/manual/docblocks.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'cpp'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = [
      \ 'doxygen_javadoc',
      \ 'doxygen_javadoc_no_asterisk',
      \ 'doxygen_javadoc_banner',
      \ 'doxygen_qt',
      \ 'doxygen_qt_no_asterisk',
      \ 'doxygen_cpp_comment_slash',
      \ 'doxygen_cpp_comment_exclamation',
      \ 'doxygen_cpp_comment_slash_banner',
      \ ]
let b:doge_doc_standard = doge#buffer#get_doc_standard('cpp')

let &cpoptions = s:save_cpo
unlet s:save_cpo
