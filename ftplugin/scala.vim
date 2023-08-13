" ==============================================================================
" The Scala documentation should follow the 'ScalaDoc' conventions.
" see https://docs.scala-lang.org/style/scaladoc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_parser = 'scala'
let b:doge_insert = 'above'

let b:doge_supported_doc_standards = ['scaladoc']
let b:doge_doc_standard = doge#buffer#get_doc_standard('scala')

let &cpoptions = s:save_cpo
unlet s:save_cpo
