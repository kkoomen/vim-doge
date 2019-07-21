 // Variable types
 // - var
 // - val (read-only)

// =============================================================================
// Functions
// =============================================================================

/**
 * [TODO:description]
 * @param a [TODO:description]
 * @param b [TODO:description]
 * @return [TODO:description]
 */
fun sum(a: Int, b: Int): Int {
  return a + b
}

/**
 * [TODO:description]
 * @param a [TODO:description]
 * @param b [TODO:description]
 * @return [TODO:description]
 */
fun sum(a: Int, b: Int) = a + b

/**
 * [TODO:description]
 * @param a [TODO:description]
 * @param b [TODO:description]
 * @return [TODO:description]
 */
fun printSum(a: Int, b: Int) {
  println("sum of $a and $b is ${a + b}")
}

/**
 * [TODO:description]
 * @param map [TODO:description]
 * @param str [TODO:description]
 * @return [TODO:description]
 */
fun parseInt(map: MutableMap<String, Any?>, str: String): Int? {}

/**
 * [TODO:description]
 * @param i [TODO:description]
 * @param lst [TODO:description]
 * @param str [TODO:description]
 * @param map [TODO:description]
 * @param str [TODO:description]
 * @return [TODO:description]
 */
fun parseInt(i: Int = 0, lst: List<*, <T>>, str: String.() -> Unit, map: MutableMap<String, Any?>, str: List<String, <T>>): Int? {}

/**
 * [TODO:description]
 * @param json [TODO:description]
 * @return [TODO:description]
 */
inline fun <reified T: Any> Gson.fromJson(json: JsonElement): T = this.fromJson(json, T::class.java) {}

/**
 * [TODO:description]
 * @param onetime [TODO:description]
 * @param callback [TODO:description]
 * @return [TODO:description]
 */
fun listenForPackageChanges(onetime: Int = true, callback: () -> Unit): Int? = object : BroadcastReceiver() {

/**
 * [TODO:description]
 * @return [TODO:description]
 */
inline fun <reified T : Enum<T>> printAllValues() {
  print(enumValues<T>().joinToString { it.name })
}

/**
 * [TODO:description]
 * @param x [TODO:description]
 * @return [TODO:description]
 */
fun <T> id(x: T): T = x

/**
 * [TODO:description]
 * @param i [TODO:description]
 * @return [TODO:description]
 */
open data fun asNullable(i: Foo?) {}

/**
 * [TODO:description]
 * @param x [TODO:description]
 * @return [TODO:description]
 */
fun demo(x: Comparable<Number>) {}

/**
 * [TODO:description]
 * @param group [TODO:description]
 * @param user [TODO:description]
 * @param test [TODO:description]
 * @return [TODO:description]
 */
fun readStar(group: Group<*>, user: User<*>, test: Boolean) {}

/**
 * [TODO:description]
 * @param group [TODO:description]
 * @return [TODO:description]
 */
fun readOut(group: Group<out Animal>) {}

/**
 * [TODO:description]
 * @param group [TODO:description]
 * @return [TODO:description]
 */
fun readIn(group: Group<in Nothing>) {}

/**
 * [TODO:description]
 * @param list [TODO:description]
 * @return [TODO:description]
 */
fun acceptAnyList(list: List<Any?>) {}

/**
 * [TODO:description]
 * @param from [TODO:description]
 * @param to [TODO:description]
 * @return [TODO:description]
 */
fun copy(from: Array<Any>, to: Array<Any>) {}

// =============================================================================
// Functions: visibility modifiers
// =============================================================================
// Options: public | protected | private | inline

/**
 * [TODO:description]
 * @param list [TODO:description]
 * @return [TODO:description]
 */
private fun foo(list: List<Any?>) {}

// =============================================================================
// Extension Functions
// =============================================================================
/**
 * [TODO:description]
 * @param index1 [TODO:description]
 * @param index2 [TODO:description]
 * @return [TODO:description]
 */
fun <T> MutableList<Int>.swap(index1: Int, index2: Int) {}

/**
 * [TODO:description]
 * @param index1 [TODO:description]
 * @param index2 [TODO:description]
 * @return [TODO:description]
 */
fun MutableList<Int>.swap(index1: Int, index2: Int) {}

/**
 * [TODO:description]
 * @param index1 [TODO:description]
 * @param index2 [TODO:description]
 * @return [TODO:description]
 */
fun <T> MutableList.swap(index1: Int, index2: Int) {}

/**
 * [TODO:description]
 * @param index1 [TODO:description]
 * @param index2 [TODO:description]
 * @return [TODO:description]
 */
fun MutableList.swap(index1: Int, index2: Int) {}

/**
 * [TODO:description]
 * @param index1 [TODO:description]
 * @param index2 [TODO:description]
 * @return [TODO:description]
 */
fun <T> MutableList<T>.swap(index1: Int, index2: Int) {}

/**
 * [TODO:description]
 * @return [TODO:description]
 */
fun Any?.toString(): String {
  if (this == null) return "null"
  // after the null check, 'this' is autocast to a non-null type, so the toString() below
  // resolves to the member function of the Any class
  return toString()
}

// =============================================================================
// Classes: Implementation by Delegation
// =============================================================================
/**
 * [TODO:description]
 * @property b [TODO:description]
 */
class Derived(b: Base) : Base by b

class Delegate {
  /**
   * [TODO:description]
   * @property thisRef [TODO:description]
   * @property property [TODO:description]
   * @return [TODO:description]
   */
  operator fun getValue(thisRef: Any?, property: KProperty<*>): String {
    return "$thisRef, thank you for delegating '${property.name}' to me!"
  }

  /**
   * [TODO:description]
   * @param thisRef [TODO:description]
   * @param property [TODO:description]
   * @param value [TODO:description]
   * @return [TODO:description]
   */
  operator fun setValue(thisRef: Any?, property: KProperty<*>, value: String) {
    println("$value has been assigned to '${property.name}' in $thisRef.")
  }
}

/**
 * [TODO:description]
 * @property map [TODO:description]
 */
class MutableUser(val map: MutableMap<String, Any?>) {
  var name: String by map
  var age: Int     by map
}

class ResourceDelegate<T> : ReadOnlyProperty<MyUI, T> {
  /**
   * [TODO:description]
   * @param thisRef [TODO:description]
   * @param property [TODO:description]
   * @return [TODO:description]
   */
  override fun getValue(thisRef: MyUI, property: KProperty<*>): T {}
}

/**
 * [TODO:description]
 * @property id [TODO:description]
 */
class ResourceLoader<T>(id: ResourceID<T>) {
  /**
   * [TODO:description]
   * @param thisRef [TODO:description]
   * @param prop [TODO:description]
   * @return [TODO:description]
   */
  operator fun provideDelegate(
      thisRef: MyUI,
      prop: KProperty<*>
  ): ReadOnlyProperty<MyUI, T> {
    checkProperty(thisRef, prop.name)
    // create delegate
    return ResourceDelegate()
  }

  /**
   * [TODO:description]
   * @param thisRef [TODO:description]
   * @param name [TODO:description]
   * @return [TODO:description]
   */
  private fun checkProperty(thisRef: MyUI, name: String) {}
}

class MyUI {
  /**
   * [TODO:description]
   * @param id [TODO:description]
   * @return [TODO:description]
   */
  fun <T> bindResource(id: ResourceID<T>): ResourceLoader<T> {}

  val image by bindResource(ResourceID.image_id)
  val text by bindResource(ResourceID.text_id)
}

// =============================================================================
// Classes: Companion Object Extensions
// =============================================================================
class MyClass {
  companion object { }
}

/**
 * [TODO:description]
 * @return [TODO:description]
 */
fun MyClass.Companion.foo() {}

// =============================================================================
// Inline classes
// =============================================================================
/**
 * [TODO:description]
 * @property s [TODO:description]
 */
inline class Name(val s: String) {
  val length: Int
  get() = s.length

  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  fun greet() {
    println("Hello, $s")
  }
}

// =============================================================================
// Data classes
// =============================================================================
/**
 * [TODO:description]
 * @property name [TODO:description]
 * @property age [TODO:description]
 */
data class User(val name: String, val age: Int)

// =============================================================================
// Inner classes
// =============================================================================
class Outer {
  private val bar: Int = 1
  inner class Inner {
    /**
     * [TODO:description]
     * @return [TODO:description]
     */
    fun foo() = bar
  }
}

// =============================================================================
// Enum classes
// =============================================================================
/**
 * [TODO:description]
 * @property rgb [TODO:description]
 */
enum class Color(val rgb: Int) {
  RED(0xFF0000),
  GREEN(0x00FF00),
  BLUE(0x0000FF)
}

enum class RGB { RED, GREEN, BLUE }

// =============================================================================
// Classes: primary constructors
// =============================================================================
/**
 * [TODO:description]
 * @property firstName [TODO:description]
 */
class Person constructor(firstName: String) {}

/**
 * [TODO:description]
 * @property a [TODO:description]
 */
class C private constructor(a: Int) {}

/**
 * [TODO:description]
 * @property firstName [TODO:description]
 */
class Person(firstName: String) {}

// =============================================================================
// Classes: secondary constructors
// =============================================================================
class Person {
  /**
   * [TODO:description]
   * @param parent [TODO:description]
   * @param query [TODO:description]
   * @param users [TODO:description]
   */
  constructor(parent: Person, query: Query<*, <T>>, users: List<User>) {
    parent.children.add(this)
  }
}

/**
 * [TODO:description]
 * @property name [TODO:description]
 */
class Person(val name: String) {
  /**
   * [TODO:description]
   * @param name [TODO:description]
   * @param parent [TODO:description]
   */
  constructor(name: String, parent: Person) : this(name) {
    parent.children.add(this)
  }
}

// =============================================================================
// Classes: inheritance
// =============================================================================
class MyView : View {
  /**
   * [TODO:description]
   * @param ctx [TODO:description]
   */
  protected constructor(ctx: Context) : super(ctx)

  /**
   * [TODO:description]
   * @param ctx [TODO:description]
   * @param attrs [TODO:description]
   */
  constructor(ctx: Context, attrs: AttributeSet) : super(ctx, attrs)
}

// =============================================================================
// Abstract classes & methods
// =============================================================================

/**
 * [TODO:description]
 * @property name [TODO:description]
 * @property color [TODO:description]
 * @property weight [TODO:description]
 */
abstract class Vehicle(val name: String, val color: String, val weight: Double) {
  /**
   * [TODO:description]
   * @param t [TODO:description]
   * @param u [TODO:description]
   * @return [TODO:description]
   */
  abstract fun signal(t: Int, u: Int) = apply(t, u)
}

// =============================================================================
// Classes: methods
// =============================================================================
class Bar2 : Foo {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  override fun v() {}

  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  final override fun v() {}
}

open class Base {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  open fun v() {}

  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  fun nv() {}
}

/**
 * [TODO:description]
 */
class Derived() : Base() {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  override fun v() {}
}

open class Foo {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  open fun f() { println("Foo.f()") }

  open val x: Int get() = 1
}

class Bar : Foo() {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  override fun f() {
    super.f()
    println("Bar.f()")
  }

  override val x: Int get() = super.x + 1
}

// =============================================================================
// Classes: interfaces
// =============================================================================
interface A {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  fun foo() { print("A") }
}

interface B {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  fun foo() { print("B") }

  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  fun bar() { print("bar") }
}

class D : A, B {
  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  override fun foo() {
    super<A>.foo()
    super<B>.foo()
  }

  /**
   * [TODO:description]
   * @return [TODO:description]
   */
  override fun bar() {
    super<B>.bar()
  }
}

/**
 * [TODO:description]
 */
external class MyClass() {}
