<?php

/**
 * This file contains test scenarios and their expected results. You should be
 * able to generate the examples below.
 */

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route as BaseRoute;
use Symfony\Component\HttpFoundation\RedirectResponse as RedirectResponseBase, Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

/**
 * TODO
 *
 * @param array $arg1 TODO
 * @param string $arg2 TODO
 * @param mixed $arg3 TODO
 * @param \Drupal\core\Entity\Node $arg4 TODO
 */
function myFunction(array &$arg1, string $arg2, &$arg3 = NULL, \Drupal\core\Entity\Node $arg4) {
  //
}

/**
 * TODO
 *
 * @param \Symfony\Component\HttpFoundation\Response $arg4 TODO
 */
function myFunction(Response $arg4) {
  // This should return \Symfony\Component\HttpFoundation\Response since
  // 'Response' is not defined as a an alias.
}

/**
 * TODO
 *
 * @param BaseRoute $arg4 TODO
 */
function myFunction(BaseRoute $arg4) {
  // This should return 'BaseRoute' since it is defined as an alias.
}

/**
 * TODO
 *
 * @param \Symfony\Bundle\FrameworkBundle\Controller\AbstractController $arg4 TODO
 */
function myFunction(AbstractController $arg4) {
  // This should return
  // \Symfony\Bundle\FrameworkBundle\Controller\AbstractController since
  // 'AbstractController' is not defined as an alias.
}

/**
 * TODO
 *
 * @param RedirectResponse $arg4 TODO
 */
function myFunction(RedirectResponse $arg4) {
  // This should return 'RedirectResponse' since it is defined as an alias.
}

class myClass {

  /**
   * @var \Drupal\Core\Config\Entity\Query\QueryFactory
   */
  protected $entityQueryFactory;

  /**
   * TODO
   *
   * @param \Drupal\Core\Config\Entity\Query\QueryFactory $eqf TODO
   */
  public function __construct(\Drupal\Core\Config\Entity\Query\QueryFactory $eqf) {
    $this->entityQueryFactory = $eqf;
  }


  /**
   * TODO
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param mixed $arg4 TODO
   * @param mixed $arg5 TODO
   */
  public function myPublicMethod(array &$arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

  /**
   * TODO
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param mixed $arg4 TODO
   * @param mixed $arg5 TODO
   */
  public final function myPublicFinalMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = 'test') {
    //
  }

  /**
   * TODO
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param mixed $arg4 TODO
   * @param mixed $arg5 TODO
   */
  public static function myPublicStaticMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

  /**
   * TODO
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param mixed $arg4 TODO
   * @param array $arg5 TODO
   */
  public static final function myPublicStaticFinalMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4 = [], array $arg5 = array()) {
    //
  }

  /**
   * TODO
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param mixed $arg4 TODO
   * @param mixed $arg5 TODO
   */
  private function myPrivateMultilineMethod(
    array $arg1,
    \Test\Namespacing\With\A\ClassInterface $arg2,
    int $arg3,
    $arg4,
    $arg5 = NULL
  ) {
    //
  }

}

class myClass2 {

  /**
   * @var \Drupal\Core\Config\Entity\Query\QueryFactory
   */
  protected $entityQueryFactory;

  /**
   * TODO
   *
   * @param \Drupal\Core\Config\Entity\Query\QueryFactory $eqf TODO
   * @param \Symfony\Bundle\FrameworkBundle\Controller\AbstractController $controller TODO
   */
  public function __construct(\Drupal\Core\Config\Entity\Query\QueryFactory $eqf, AbstractController $controller) {
    $this->entityQueryFactory = $eqf;
    $this->controller = $controller;
  }

  /**
   * @var \Symfony\Bundle\FrameworkBundle\Controller\AbstractController
   */
  protected $controller;

  /**
   * TODO
   *
   * @param array $arg1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $arg2 TODO
   * @param int $arg3 TODO
   * @param mixed $arg4 TODO
   * @param mixed $arg5 TODO
   */
  public function myPublicMethod(array &$arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

}
