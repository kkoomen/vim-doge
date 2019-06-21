<?php

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route as BaseRoute;
use Symfony\Component\HttpFoundation\RedirectResponse as RedirectResponseBase, Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

/**
 * TODO
 *
 */
function myFunc() {}

/**
 * TODO
 *
 * @param array $p1 TODO
 * @param string $p2 
 * @param mixed $p3 
 * @param \Drupal\core\Entity\Node $p4 a
 */
function myFunction(array &$p1, string $p2, &$p3 = NULL, \Drupal\core\Entity\Node $p4) {
  //
}

/**
 * TODO
 *
 * @param \Symfony\Component\HttpFoundation\Response $p4 TODO
 */
function myFunction(Response $p4) {
  // This should return \Symfony\Component\HttpFoundation\Response since
  // 'Response' is not defined as a an alias.
}

/**
 * TODO
 *
 * @param BaseRoute $p4 TODO
 */
function myFunction(BaseRoute $p4) {
  // This should return 'BaseRoute' since it is defined as an alias.
}

/**
 * TODO
 *
 * @param \Symfony\Bundle\FrameworkBundle\Controller\AbstractController $p4 TODO
 */
function myFunction(AbstractController $p4) {
  // This should return
  // \Symfony\Bundle\FrameworkBundle\Controller\AbstractController since
  // 'AbstractController' is not defined as an alias.
}

/**
 * TODO
 *
 * @param RedirectResponse $p4 TODO
 */
function myFunction(RedirectResponse $p4) {
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
   * @param array $p1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $p2 TODO
   * @param int $p3 TODO
   * @param mixed $p4 TODO
   * @param mixed $p5 TODO
   */
  public function myPublicMethod(array &$p1, \Test\Namespacing\With\A\ClassInterface $p2, int $p3, $p4, $p5 = NULL) {
    //
  }

  /**
   * TODO
   *
   * @param array $p1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $p2 TODO
   * @param int $p3 TODO
   * @param mixed $p4 TODO
   * @param mixed $p5 TODO
   */
  public final function myPublicFinalMethod(array $p1, \Test\Namespacing\With\A\ClassInterface $p2, int $p3, $p4, $p5 = 'test') {
    //
  }

  /**
   * TODO
   *
   * @param array $p1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $p2 TODO
   * @param int $p3 TODO
   * @param mixed $p4 TODO
   * @param mixed $p5 TODO
   */
  public static function myPublicStaticMethod(array $p1, \Test\Namespacing\With\A\ClassInterface $p2, int $p3, $p4, $p5 = NULL) {
    //
  }

  /**
   * TODO
   *
   * @param array $p1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $p2 TODO
   * @param int $p3 TODO
   * @param mixed $p4 TODO
   * @param array $p5 TODO
   */
  public static final function myPublicStaticFinalMethod(array $p1, \Test\Namespacing\With\A\ClassInterface $p2, int $p3, $p4 = [], array $p5 = array()) {
    //
  }

  /**
   * TODO
   *
   * @param array $p1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $p2 TODO
   * @param int $p3 TODO
   * @param mixed $p4 TODO
   * @param mixed $p5 TODO
   */
  private function myPrivateMultilineMethod(
    array $p1,
    \Test\Namespacing\With\A\ClassInterface $p2,
    int $p3,
    $p4,
    $p5 = NULL
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
   * @param array $p1 TODO
   * @param \Test\Namespacing\With\A\ClassInterface $p2 TODO
   * @param int $p3 TODO
   * @param mixed $p4 TODO
   * @param mixed $p5 TODO
   */
  public function myPublicMethod(array &$p1, \Test\Namespacing\With\A\ClassInterface $p2, int $p3, $p4, $p5 = NULL) {
    //
  }

}
