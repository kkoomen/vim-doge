" ==============================================================================
" The Kotlin documentation should follow the 'KDoc' conventions.
" see https://kotlinlang.org/docs/reference/kotlin-doc.html
" ==============================================================================

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_pattern_single_line_comment = '\m\(\/\*.\{-}\*\/\|\/\/.\{-}$\)'
let b:doge_pattern_multi_line_comment = '\m\/\*.\{-}\*\/'

let b:doge_supported_doc_standards = doge#buffer#get_supported_doc_standards(['kdoc'])
let b:doge_doc_standard = doge#buffer#get_doc_standard('kotlin')
let b:doge_patterns = doge#buffer#get_patterns()

" ==============================================================================
"
" Define our base for every pattern.
"
" ==============================================================================
" The parameters.match describes the following pattern:
"   <param-name>: <param-type>
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
" ==============================================================================
let s:pattern_base = {
\  'parameters': {
\    'match': '\m\%(\%(var\|val\)\s\+\)\?\([[:alnum:]_]\+\)\%(\s*:\s*\%([[:alnum:]_]\+\)\?\%(<[[:alnum:][:space:]_,<>:?*]\{-1,}>\|[^,]\+\)\?\)\?',
\    'tokens': ['name'],
\    'format': '@param {name} !description'
\  },
\  'insert': 'above',
\}

" ==============================================================================
"
" Define the pattern types.
"
" ==============================================================================

" ------------------------------------------------------------------------------
" Matches regular functions, class methods and extension functions.
" ------------------------------------------------------------------------------
" fun MutableList<Int>.swap<Int>(index1: Int, index2: Int) {
" fun listenForPackageChanges(onetime: Boolean = true, callback: () -> Unit) = object : BroadcastReceiver() {}
" inline fun <reified T : Enum<T>> printAllValues() {}
" fun <T> id(x: T): T = x
" fun readOut(group: Group<out Animal>) {}
" fun readIn(group: Group<in Nothing>) {}
" fun acceptAnyList(list: List<Any?>) {}
" inline fun <reified T: Any> Gson.fromJson(json: JsonElement): T = this.fromJson(json, T::class.java)
" open fun f() { println("Foo.f()") }
" ------------------------------------------------------------------------------
let s:function_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|protected\|private\|final\|inline\|abstract\|override\|operator\|open\|data\)\s\+\)*fun\s\+\%([^(]\+\)\s*(\(.\{-}\))\%(\s*:\s*[[:alnum:]_:\.]\+\%(<[[:alnum:][:space:]_,<>:?*]\{-}>\)\??\?\)\?\s*[={]',
\  'tokens': ['parameters'],
\})

" ------------------------------------------------------------------------------
" Matches classes.
" ------------------------------------------------------------------------------
" class Outer() {}
" inner class Inner() {}
" data class User(val name: String, val age: Int) {}
" enum class Color(val rgb: Int) {}
" class Person constructor(firstName: String) {}
" class C private constructor(a: Int) {}
" class Person(firstName: String) {}
" class MyView() : View()) {}
" inline class Name(val s: String) {}
" abstract class Vehicle(val name: String, val color: String, val weight: Double) {}
" external class MyClass() {}
" ------------------------------------------------------------------------------
let s:class_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(inner\|inline\|data\|enum\|external\|open\|abstract\|sealed\)\s\+\)*class\s\+\%([[:alnum:]_]\+\%(<[[:alnum:][:space:]_,<>:?*]\{-}>\)\?\)\s*\%(\%(public\|private\|protected\)\s*\)\?\%(constructor\s*\)\?(\(.\{-}\))',
\  'tokens': ['parameters'],
\  'parameters': {
\    'format': '@property {name} !description',
\  },
\})

" ------------------------------------------------------------------------------
" Matches class constructors.
" ------------------------------------------------------------------------------
" constructor(parent: Person, query: Query<*, <T>>) {}
" ------------------------------------------------------------------------------
let s:class_constructor_pattern = doge#helpers#deepextend(s:pattern_base, {
\  'match': '\m^\%(\%(public\|private\|protected\)\s\+\)\?constructor\s*(\(.\{-}\))',
\  'tokens': ['parameters'],
\})


" ==============================================================================
"
" Define the doc standards.
"
" ==============================================================================
call doge#buffer#register_doc_standard('kdoc', [
\  doge#helpers#deepextend(s:function_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parameters| * {parameters})%',
\      ' * @return !description',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:class_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parameters| * {parameters})%',
\      ' */',
\    ],
\  }),
\  doge#helpers#deepextend(s:class_constructor_pattern, {
\    'template': [
\      '/**',
\      ' * !description',
\      '%(parameters| * {parameters})%',
\      ' */',
\    ],
\  }),
\])

let &cpoptions = s:save_cpo
unlet s:save_cpo
