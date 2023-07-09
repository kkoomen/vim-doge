let s:save_cpo = &cpoptions
set cpoptions&vim

" The C filetype also gets triggerred for C++, so we want to ignore this.
if &filetype !=? 'c'
  finish
endif

let b:doge_parser = 'c'
let b:doge_insert = 'above'
let b:char = get(g:, 'doge_doxygen_settings')['char']

let b:doge_supported_doc_standards = [
      \ 'doxygen_javadoc',
      \ 'doxygen_javadoc_no_asterisk',
      \ 'doxygen_javadoc_banner',
      \ 'doxygen_qt',
      \ 'doxygen_qt_no_asterisk',
      \ 'kernel_doc',
      \ 'doxygen_cpp_comment_slash',
      \ 'doxygen_cpp_comment_exclamation',
      \ 'doxygen_cpp_comment_slash_banner',
      \ ]
let b:doge_doc_standard = doge#buffer#get_doc_standard('c')

let &cpoptions = s:save_cpo
unlet s:save_cpo
