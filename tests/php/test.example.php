<?php

/**
 * This file contains test scenarios and their expected results. When testing
 * using the test.{ext} files you should be able to generate the examples below.
 */

/**
 * myFunction
 *
 * @param array $arg1 TODO
 * @param string $arg2 TODO
 * @param $arg3 TODO
 * @param \Drupal\core\Entity\Node $arg4 TODO
 */
function myFunction(array $arg1, string $arg2, $arg3 = NULL, \Drupal\core\Entity\Node $arg4) {
  //
}

class myClass {

  /**
   * myPublicMethod
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param $arg4 TODO
   * @param $arg5 TODO
   */
  public function myPublicMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

  /**
   * myPrivateMethod
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param $arg4 TODO
   * @param $arg5 TODO
   */
  public function myPrivateMethod(
    array $arg1,
    \Test\Namespacing\With\A\ClassInterface $arg2,
    int $arg3,
    $arg4,
    $arg5 = NULL
  ) {
    //
  }

}
