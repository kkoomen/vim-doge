<?php

/**
 * This file contains test scenarios which should generate proper documentation.
 */


function myFunction(array $arg1, string $arg2, $arg3 = NULL, \Drupal\core\Entity\Node $arg4) {
  //
}

class myClass {

  public function myPublicMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

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
