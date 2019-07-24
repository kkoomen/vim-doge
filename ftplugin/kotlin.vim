" ==============================================================================
" The Kotlin documentation should follow the 'KDoc' conventions.
" see https://kotlinlang.org/docs/reference/kotlin-doc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = ['kdoc']
let b:doge_doc_standard = get(g:, 'doge_doc_standard_kotlin', b:doge_supported_doc_standards[0])
if index(b:doge_supported_doc_standards, b:doge_doc_standard) < 0
  echoerr printf(
  \ '[DoGe] %s is not a valid Kotlin doc standard, available doc standard are: %s',
  \ b:doge_doc_standard,
  \ join(b:doge_supported_doc_standards, ', ')
  \ )
endif

let b:doge_patterns = []

" Matches the following pattern:
"   <param-name>: <param-type>
"
" Matches the following scenarios:
"
"   (map: MutableMap<String, Any?>, str: String.() -> Unit)
"
"   (str: String.() -> Unit, map: MutableMap<String, Any?>)
"
"   (num: <*>, str: String.() -> Unit, map: MutableMap<String, Any?>)
"
"   (map: MutableMap<String, <T>>, str: String.() -> Unit)
"
"   (map: MutableMap, str: String)
"
"   (onetime: Boolean = true, callback: () -> Unit)
let s:parameters_match_pattern = '\m\%(\%(var\|val\)\s\+\)\?\([[:alnum:]_]\+\)\%(\s*:\s*\%([[:alnum:]_]\+\)\?\%(<[[:alnum:][:space:]_,<>:?*]\{-1,}>\|[^,]\+\)\?\)\?'

" ==============================================================================
" Matches regular functions, class methods and extension functions.
" ==============================================================================
"
" Matches the following scenarios:
"
"   fun MutableList<Int>.swap<Int>(index1: Int, index2: Int) {
"
"   fun listenForPackageChanges(onetime: Boolean = true, callback: () -> Unit) = object : BroadcastReceiver() {}
"
"   inline fun <reified T : Enum<T>> printAllValues() {}
"
"   fun <T> id(x: T): T = x
"
"   fun readOut(group: Group<out Animal>) {}
"
"   fun readIn(group: Group<in Nothing>) {}
"
"   fun acceptAnyList(list: List<Any?>) {}
"
"   inline fun <reified T: Any> Gson.fromJson(json: JsonElement): T = this.fromJson(json, T::class.java)
"
"   open fun f() { println("Foo.f()") }
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(public\|protected\|private\|final\|inline\|abstract\|override\|operator\|open\|data\)\s\+\)*fun\s\+\%([^(]\+\)\s*(\(.\{-}\))\%(\s*:\s*[[:alnum:]_:\.]\+\%(<[[:alnum:][:space:]_,<>:?*]\{-}>\)\??\?\)\?\s*[={]',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'kdoc': '@param {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'kdoc': [
\        '/**',
\        ' * !description',
\        '%(parameters| * {parameters})%',
\        ' * @return !description',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Matches classes.
" ==============================================================================
"
" Matches the following scenarios:
"
"   class Outer() {}
"
"   inner class Inner() {}
"
"   data class User(val name: String, val age: Int) {}
"
"   enum class Color(val rgb: Int) {}
"
"   class Person constructor(firstName: String) {}
"
"   class C private constructor(a: Int) {}
"
"   class Person(firstName: String) {}
"
"   class MyView() : View()) {}
"
"   inline class Name(val s: String) {}
"
"   abstract class Vehicle(val name: String, val color: String, val weight: Double) {}
"
"   external class MyClass() {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(inner\|inline\|data\|enum\|external\|open\|abstract\|sealed\)\s\+\)*class\s\+\%([[:alnum:]_]\+\%(<[[:alnum:][:space:]_,<>:?*]\{-}>\)\?\)\s*\%(\%(public\|private\|protected\)\s*\)\?\%(constructor\s*\)\?(\(.\{-}\))',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'kdoc': '@property {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'kdoc': [
\        '/**',
\        ' * !description',
\        '%(parameters| * {parameters})%',
\        ' */',
\      ],
\    },
\  },
\})

" ==============================================================================
" Matches constructors inside a class.
" ==============================================================================
"
" Matches the following scenarios:
"
"   constructor(parent: Person, query: Query<*, <T>>) {}
call add(b:doge_patterns, {
\  'match': '\m^\%(\%(public\|private\|protected\)\s\+\)\?constructor\s*(\(.\{-}\))',
\  'match_group_names': ['parameters'],
\  'parameters': {
\    'match': s:parameters_match_pattern,
\    'match_group_names': ['name'],
\    'format': {
\      'kdoc': '@param {name} !description',
\    },
\  },
\  'comment': {
\    'insert': 'above',
\    'template': {
\      'kdoc': [
\        '/**',
\        ' * !description',
\        '%(parameters| * {parameters})%',
\        ' */',
\      ],
\    },
\  },
\})

let &cpoptions = s:save_cpo
unlet s:save_cpo
