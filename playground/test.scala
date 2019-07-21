// =============================================================================
// Functions
// =============================================================================

/** [TODO:description]
 *
 * @param x Int [TODO:description]
 * @return [TODO:description]
 */
(x: Int) => x + 1

/** [TODO:description]
 *
 * @param x Int [TODO:description]
 * @return [TODO:description]
 */
val addOne = (x: Int) => x + 1

/** [TODO:description]
 *
 * @param x Int [TODO:description]
 * @param y Int [TODO:description]
 * @return [TODO:description]
 */
val add = (x: Int, y: Int) => x + y

/** [TODO:description]
 *
 * @return [TODO:description]
 */
val getTheAnswer = () => 42

// =============================================================================
// Methods
// =============================================================================

/** [TODO:description]
 *
 * @param x Double [TODO:description]
 * @param y Double [TODO:description]
 */
class Point(val x: Double = 0, val y: Double = 0) {
  override def toString: String =
    s"($x, $y)"
  private def printWarning = println("WARNING: Out of bounds")
}

/** [TODO:description]
 *
 * @param x Int [TODO:description]
 * @param y Int [TODO:description]
 * @return [TODO:description]
 */
def add(x: Int, y: Int): Int = x + y

/** [TODO:description]
 *
 * @param x Int [TODO:description]
 * @param y Int [TODO:description]
 * @param multiplier Int [TODO:description]
 * @return [TODO:description]
 */
def addThenMultiply(x: Int, y: Int)(multiplier: Int): Int = (x + y) * multiplier

/** [TODO:description]
 *
 * @param input Double [TODO:description]
 * @return [TODO:description]
 */
def getSquareString(input: Double): String = {}

/** [TODO:description]
 *
 * @param ssl Boolean [TODO:description]
 * @param domainName String [TODO:description]
 * @return [TODO:description]
 */
def urlBuilder(ssl: Boolean = true, domainName: String = "some domain value"): (String, String) => String = {
  val schema = if (ssl) "https://" else "http://"
  (endpoint: String, query: String) => s"$schema$domainName/$endpoint?$query"
}

def curryBinaryOperator[A](operator: (A, A) => A): A => (A => A) = {}

def curryBinaryOperator[A](User: user, name: String, operator: (A, A) => A): (A, A) => (A => A) = {}

def foldLeft[B](z: B)(op: (B, A) => B): B = {}

/** [TODO:description]
 *
 * @param args Array[String] [TODO:description]
 * @return [TODO:description]
 */
def main(args: Array[String]): Unit =
  println("Hello, Scala developer!")

def foldLeft[B](z: B)(op: (B, A) => B): (B, A) => (A) = {}

/** [TODO:description]
 *
 * @param dx Int [TODO:description]
 * @param dy Int [TODO:description]
 * @return [TODO:description]
 */
def move(dx: Int, dy: Int): Unit = {}

/** [TODO:description]
 *
 * @param p {type} [TODO:description]
 */
class name(p) extends A with B {
  /** [TODO:description]
   *
   * @param x Int [TODO:description]
   * @param y Int [TODO:description]
   * @return [TODO:description]
   */
  override def add(x: Int, y: Int): Int = x + y

  /** [TODO:description]
   *
   * @param x Int [TODO:description]
   * @param y Int [TODO:description]
   * @return [TODO:description]
   */
  override private def add(x: Int, y: Int): Int = x + y
}


/** [TODO:description]
 *
 * @param newValue Int [TODO:description]
 * @return [TODO:description]
 */
def x_ = (newValue: Int): Unit = {}

// =============================================================================
// Classes, Objects & Traits
// =============================================================================

// classes
class Test {}

/** [TODO:description]
 *
 * @param prefix String [TODO:description]
 * @param suffix String [TODO:description]
 */
class Greeter(prefix: String, suffix: String) {}

/** [TODO:description]
 *
 * @param amount_msat Long [TODO:description]
 */
private case class GUISat(amount_msat: Long) extends BtcAmountGUILossless {}

/** [TODO:description]
 *
 * @param name String [TODO:description]
 * @param age Int [TODO:description]
 */
protected case class LoremIpsum(name: String, age: Int) extends B with C with D {}

/** [TODO:description]
 *
 * @param x Int [TODO:description]
 * @param y Int [TODO:description]
 */
case class Point(x: Int, y: Int) {}

// objects
object IdFactory {}
case object MSatUnit extends CoinUnit {}
case object MSatUnit extends CoinUnit with C with D {}
package object mypackage {}

// Traits
trait Greeter {
  /** [TODO:description]
   *
   * @param name String [TODO:description]
   * @return [TODO:description]
   */
  def greet(name: String): Unit =
    println("Hello, " + name + "!")
}

trait Iterator[A] {
  def hasNext: Boolean
  /** [TODO:description]
   *
   * @return [TODO:description]
   */
  def next(): A
}

/** [TODO:description]
 *
 * @param to Int [TODO:description]
 */
class IntIterator(to: Int) extends Iterator[Int] {
  /** [TODO:description]
   *
   * @return [TODO:description]
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

/** [TODO:description]
 *
 * @param name String [TODO:description]
 */
class Cat(val name: String) extends Pet

/** [TODO:description]
 *
 * @param name String [TODO:description]
 */
class Dog(val name: String) extends Pet
