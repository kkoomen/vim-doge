" ==============================================================================
" The Scala documentation should follow the 'ScalaDoc' conventions.
" see https://docs.scala-lang.org/style/scaladoc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

" Matches the following pattern:
"   <param-name>: <param-type> = <param-default-value>
let s:parameters_match_pattern = '\m\(\%(val\s+\)\?[[:alnum:]_]\+\)\%(\s*:\s*\([^,(\)=]\+\)\)\?\%(\s*=\s*[^,(\)]\+\)\?'

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
\  'match': '\m^\%(val\s\+\([[:alnum:]_]\+\)\s*=\s*\)\?(\(.\{-}\))\s*=>\s*',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': ['@param', '{name}', '{type}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '/** TODO',
\      ' *',
\      '! * {parameters}',
\      ' * @return TODO',
\      ' */',
\    ],
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
\  'match': '\m^\%(override\s\+\)\?\%(\%(public\|private\|protected\)\s\+\)\?def\s\+\([[:alnum:]_]\+\)\%(\[.*\]\)\?\%(\s*=\s*\)\?(\(.\{-}\)):',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': ['@param', '{name}', '{type}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '/** TODO',
\      ' *',
\      '! * {parameters}',
\      ' * @return TODO',
\      ' */',
\    ],
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
\  'match': '\m^\%(package\s\+\)\?\%(\%(public\|private\|protected\)\s\+\)\?\%(case\s\+\)\?class\s\+\([[:alnum:]_]\+\)\%(\[.*\]\)\?(\(.\{-}\))\([^{]\+{\)\?',
\  'match_group_names': ['funcName', 'parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name', 'type'],
\    'format': ['@param', '{name}', '{type}', 'TODO'],
\  },
\  'comment': {
\    'insert': 'above',
\    'trim_comparision_check': 0,
\    'template': [
\      '/** TODO',
\      ' *',
\      '! * {parameters}',
\      ' */',
\    ],
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
