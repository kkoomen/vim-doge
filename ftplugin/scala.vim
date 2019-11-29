" ==============================================================================
" The Scala documentation should follow the 'ScalaDoc' conventions.
" see https://docs.scala-lang.org/style/scaladoc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['scaladoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('scala')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
" The parameters.match describes the following pattern:
"   <param-name>: <param-type> = <param-default-value>
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\%(\%(val\s\+\)\?\([[:alnum:]_]\+\)\)\%(\s*:\s*\([^,(\)=]\+\)\)\?\%(\s*=\s*[^,(\)]\+\)\?',
\    'tokens': ['name', 'type'],
\    'format': '@param {name} {type} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions.
" ------------------------------------------------------------------------------
" (x: Int) => x + 1
" val getTheAnswer = () => 42
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(val\s\+\%([[:alnum:]_]\+\)\s*=\s*\)\?(\(.\{-}\))\s*=>\s*',
\  'tokens': ['parameters'],
\})

" ------------------------------------------------------------------------------
" Matches class methods.
" ------------------------------------------------------------------------------
" def urlBuilder(ssl: Boolean = true, domainName: String = 'some domain value'): (String, String) => String = {}
"
" def main(args: Array[String]): Unit =
"   println("Hello, Scala developer!")
"
" def move(dx: Int, dy: Int): Unit = {}
" ------------------------------------------------------------------------------
let s:class_method_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|override\)\s\+\)*def\s\+\%([[:alnum:]_]\+\)\%(\[.*\]\)\?\%(\s*=\s*\)\?(\(.\{-}\)):',
\  'tokens': ['parameters'],
\})

" ------------------------------------------------------------------------------
" Matches classes.
" ------------------------------------------------------------------------------
" class Cat(val name: String) extends Pet
" class IntIterator(to: Int) extends Iterator[Int] {}
" protected case class LoremIpsum(name: String, age: Int) extends B with C with D {}
" ------------------------------------------------------------------------------
let s:class_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\|package\|case\)\s\+\)*class\s\+\%([[:alnum:]_]\+\)\%(\[.*\]\)\?(\(.\{-}\))\([^{]\+{\)\?',
\  'tokens': ['parameters'],
\})

" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('scaladoc', [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/** !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      ' * @return !description',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:class_method_pattern, {
\    'template': [
\      '/** !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      ' * @return !description',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/** !description',
\      ' *',
\      '%(parameters| * {parameters})%',
\      ' */',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
