<?php

/**
 * This file contains test scenarios and their expected results. You should be
 * able to generate the examples below.
 */

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route as BaseRoute;
use Symfony\Component\HttpFoundation\RedirectResponse as RedirectResponseBase, Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

function myFunction(array &$arg1, string $arg2, &$arg3 = NULL, \Drupal\core\Entity\Node $arg4) {
  //
}

function myFunction(Response $arg4) {
  // This should return \Symfony\Component\HttpFoundation\Response since
  // 'Response' is not defined as a an alias.
}

function myFunction(BaseRoute $arg4) {
  // This should return 'BaseRoute' since it is defined as an alias.
}

function myFunction(AbstractController $arg4) {
  // This should return
  // \Symfony\Bundle\FrameworkBundle\Controller\AbstractController since
  // 'AbstractController' is not defined as an alias.
}

function myFunction(RedirectResponse $arg4) {
  // This should return 'RedirectResponse' since it is defined as an alias.
}

class myClass {

  protected $entityQueryFactory;

  public function __construct(Drupal\Core\Config\Entity\Query\QueryFactory $eqf) {
    $this->entityQueryFactory = $eqf;
  }


  public function myPublicMethod(array &$arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

  public final function myPublicFinalMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = 'test') {
    //
  }

  public static function myPublicStaticMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

  public static final function myPublicStaticFinalMethod(array $arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4 = [], array $arg5 = array()) {
    //
  }

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

  protected $entityQueryFactory;

  public function __construct(\Drupal\Core\Config\Entity\Query\QueryFactory $eqf, AbstractController $controller) {
    $this->entityQueryFactory = $eqf;
    $this->controller = $controller;
  }

  protected $controller;

  public function myPublicMethod(array &$arg1, \Test\Namespacing\With\A\ClassInterface $arg2, int $arg3, $arg4, $arg5 = NULL) {
    //
  }

}
