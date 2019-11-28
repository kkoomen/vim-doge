" ==============================================================================
" The Scala documentation should follow the 'ScalaDoc' conventions.
" see https://docs.scala-lang.org/style/scaladoc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = ['scaladoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_scala', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Scala doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = {}

" ==============================================================================
" Define our base for every pattern.
"
" The parameters.match describes the following pattern:
"   <param-name>: <param-type> = <param-default-value>
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\%(\%(val\s\+\)\?\([[:alnum:]_]\+\)\)\%(\s*:\s*\([^,(\)=]\+\)\)\?\%(\s*=\s*[^,(\)]\+\)\?',
\    'match_group_names': ['name', 'type'],
\    'format': '@param {name} {type} !description',
\  },
\  'insert': 'above',
\}

" ==============================================================================
" Define the pattern types.
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions.
" ------------------------------------------------------------------------------
" (x: Int) => x + 1
" val getTheAnswer = () => 42
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(val\s\+\%([[:alnum:]_]\+\)\s*=\s*\)\?(\(.\{-}\))\s*=>\s*',
\  'match_group_names': ['parameters'],
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
\  'match_group_names': ['parameters'],
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
\  'match_group_names': ['parameters'],
\})

" ==============================================================================
" Define the doc standards.
" ==============================================================================
let b:doge_patterns.scaladoc = [
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
\]

let &cpoptions = s:save_cpo
unlet s:save_cpo
