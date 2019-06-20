// =============================================================================
// Functions
// =============================================================================

/** TODO
 *
 * @param x Int TODO
 * @return TODO
 */
(x: Int) => x + 1

/** TODO
 *
 * @param x Int TODO
 * @return TODO
 */
val addOne = (x: Int) => x + 1

/** TODO
 *
 * @param x Int TODO
 * @param y Int TODO
 * @return TODO
 */
val add = (x: Int, y: Int) => x + y

/** TODO
 *
 * @return TODO
 */
val getTheAnswer = () => 42

// =============================================================================
// Methods
// =============================================================================

/** TODO
 *
 * @param x Double TODO
 * @param y Double TODO
 */
class Point(val x: Double = 0, val y: Double = 0) {
  override def toString: String =
    s"($x, $y)"
  private def printWarning = println("WARNING: Out of bounds")
}

/** TODO
 *
 * @param x Int TODO
 * @param y Int TODO
 * @return TODO
 */
def add(x: Int, y: Int): Int = x + y

/** TODO
 *
 * @param x Int TODO
 * @param y Int TODO
 * @param multiplier Int TODO
 * @return TODO
 */
def addThenMultiply(x: Int, y: Int)(multiplier: Int): Int = (x + y) * multiplier

/** TODO
 *
 * @param input Double TODO
 * @return TODO
 */
def getSquareString(input: Double): String = {}

/** TODO
 *
 * @param ssl Boolean TODO
 * @param domainName String TODO
 * @return TODO
 */
def urlBuilder(ssl: Boolean = true, domainName: String = "some domain value"): (String, String) => String = {
  val schema = if (ssl) "https://" else "http://"
  (endpoint: String, query: String) => s"$schema$domainName/$endpoint?$query"
}

def curryBinaryOperator[A](operator: (A, A) => A): A => (A => A) = {}

def curryBinaryOperator[A](User: user, name: String, operator: (A, A) => A): (A, A) => (A => A) = {}

def foldLeft[B](z: B)(op: (B, A) => B): B = {}

/** TODO
 *
 * @param args Array[String] TODO
 * @return TODO
 */
def main(args: Array[String]): Unit =
  println("Hello, Scala developer!")

def foldLeft[B](z: B)(op: (B, A) => B): (B, A) => (A) = {}

/** TODO
 *
 * @param dx Int TODO
 * @param dy Int TODO
 * @return TODO
 */
def move(dx: Int, dy: Int): Unit = {}

/** TODO
 *
 * @param arg any TODO
 */
class name(arg) extends A with B {
  /** TODO
   *
   * @param x Int TODO
   * @param y Int TODO
   * @return TODO
   */
  override def add(x: Int, y: Int): Int = x + y

  /** TODO
   *
   * @param x Int TODO
   * @param y Int TODO
   * @return TODO
   */
  override private def add(x: Int, y: Int): Int = x + y
}


/** TODO
 *
 * @param newValue Int TODO
 * @return TODO
 */
def x_ = (newValue: Int): Unit = {}

// =============================================================================
// Classes, Objects & Traits
// =============================================================================

// TODO: ^(?:package\s+)?(?:(?:public|private|protected)\s+)?(?:case\s+)?(?:trait|object|class)\s+([a-zA-Z0-9_]+)(?:\[.*\])?(?:\((.*?)\))?[^{]+{
// [ funcName, parameters ]

// classes
class Test {}

/** TODO
 *
 * @param prefix String TODO
 * @param suffix String TODO
 */
class Greeter(prefix: String, suffix: String) {}

/** TODO
 *
 * @param amount_msat Long TODO
 */
private case class GUISat(amount_msat: Long) extends BtcAmountGUILossless {}

/** TODO
 *
 * @param name String TODO
 * @param age Int TODO
 */
protected case class LoremIpsum(name: String, age: Int) extends B with C with D {}

/** TODO
 *
 * @param x Int TODO
 * @param y Int TODO
 */
case class Point(x: Int, y: Int) {}

// objects
object IdFactory {}
case object MSatUnit extends CoinUnit {}
case object MSatUnit extends CoinUnit with C with D {}
package object mypackage {}

// Traits
trait Greeter {
  /** TODO
   *
   * @param name String TODO
   * @return TODO
   */
  def greet(name: String): Unit =
    println("Hello, " + name + "!")
}

trait Iterator[A] {
  def hasNext: Boolean
  /** TODO
   *
   * @return TODO
   */
  def next(): A
}

/** TODO
 *
 * @param to Int TODO
 */
class IntIterator(to: Int) extends Iterator[Int] {
  /** TODO
   *
   * @return TODO
   */
  override def next(): Int =  {
    if (hasNext) {
      val t = current
      current += 1
      t
    } else 0
  }
}

// Subtyping
trait Pet {
  val name: String
}

/** TODO
 *
 * @param name String TODO
 */
class Cat(val name: String) extends Pet
/** TODO
 *
 * @param name String TODO
 */
class Dog(val name: String) extends Pet
