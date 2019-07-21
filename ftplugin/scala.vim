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

let b:doge_patterns = []

" Matches the following pattern:
"   <param-name>: <param-type> = <param-default-value>
let s:parameters_match_pattern = '\m\%(\%(val\s\+\)\?\([[:alnum:]_]\+\)\)\%(\s*:\s*\([^,(\)=]\+\)\)\?\%(\s*=\s*[^,(\)]\+\)\?'

" ==============================================================================
" Functions
" ==============================================================================
"
" Matches the following scenarios:
"
"   (x: Int) => x + 1
"
"   val getTheAnswer = () => 42
call add(b:doge_patterns, {
\  'match': '\m^\%(val\s\+\%([[:alnum:]_]\+\)\s*=\s*\)\?(\(.\{-}\))\s*=>\s*',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': {
\      'scaladoc': '@param {name} {type} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'scaladoc': [
\        '/** !description',
\        ' *',
\        '#(parameters| * {parameters})',
\        ' * @return !description',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Methods
" ==============================================================================
"
" Matches the following scenarios:
"
"   def urlBuilder(ssl: Boolean = true, domainName: String = 'some domain value'): (String, String) => String = {}
"
"   def main(args: Array[String]): Unit =
"     println("Hello, Scala developer!")
"
"   def move(dx: Int, dy: Int): Unit = {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(public\|private\|protected\|override\)\s\+\)*def\s\+\%([[:alnum:]_]\+\)\%(\[.*\]\)\?\%(\s*=\s*\)\?(\(.\{-}\)):',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': {
\      'scaladoc': '@param {name} {type} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'scaladoc': [
\        '/** !description',
\        ' *',
\        '#(parameters| * {parameters})',
\        ' * @return !description',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Classes
" ==============================================================================
"
" Matches the following scenarios:
"
"   class Cat(val name: String) extends Pet
"
"   class IntIterator(to: Int) extends Iterator[Int] {}
"
"   protected case class LoremIpsum(name: String, age: Int) extends B with C with D {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(public\|private\|protected\|package\|case\)\s\+\)*class\s\+\%([[:alnum:]_]\+\)\%(\[.*\]\)\?(\(.\{-}\))\([^{]\+{\)\?',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': {
\      'scaladoc': '@param {name} {type} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'scaladoc': [
\        '/** !description',
\        ' *',
\        '#(parameters| * {parameters})',
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
