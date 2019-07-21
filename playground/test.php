<?php

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route as BaseRoute;
use Symfony\Component\HttpFoundation\RedirectResponse as RedirectResponseBase, Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

/**
 * [TODO:description]
 */
function myFunc() {}

/**
 * [TODO:description]
 *
 * @param array $p1
 *   [TODO:description]
 * @param string $p2
 *   [TODO:description]
 * @param [TODO:type] $p3
 *   [TODO:description]
 * @param \Drupal\core\Entity\Node $p4
 *   [TODO:description]
 */
function myFunction(array &$p1, string $p2, &$p3 = NULL, \Drupal\core\Entity\Node $p4) {
  //
}

/**
 * [TODO:description]
 *
 * @param \Symfony\Component\HttpFoundation\Response $p4
 *   [TODO:description]
 */
function myFunction(Response $p4) {
  // This should return \Symfony\Component\HttpFoundation\Response since
  // 'Response' is not defined as a an alias.
}

/**
 * [TODO:description]
 *
 * @param BaseRoute $p4
 *   [TODO:description]
 */
function myFunction(BaseRoute $p4) {
  // This should return 'BaseRoute' since it is defined as an alias.
}

/**
 * [TODO:description]
 *
 * @param \Symfony\Bundle\FrameworkBundle\Controller\AbstractController $p4
 *   [TODO:description]
 */
function myFunction(AbstractController $p4) {
  // This should return
  // \Symfony\Bundle\FrameworkBundle\Controller\AbstractController since
  // 'AbstractController' is not defined as an alias.
}

/**
 * [TODO:description]
 *
 * @param RedirectResponse $p4
 *   [TODO:description]
 */
function myFunction(RedirectResponse $p4) {
  // This should return 'RedirectResponse' since it is defined as an alias.
}

class MyClass {

  /**
   * @var \Drupal\Core\Config\Entity\Query\QueryFactory
   */
  protected $entityQueryFactory;

  /**
   * [TODO:description]
   *
   * @param \Drupal\Core\Config\Entity\Query\QueryFactory $eqf
   *   [TODO:description]
   * @param \Symfony\Bundle\FrameworkBundle\Controller\AbstractController $controller
   *   [TODO:description]
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
   * [TODO:description]
   *
   * @param array $p1
   *   [TODO:description]
   * @param   est\Namespacing\With\A\ClassInterface $p2
   *   [TODO:description]
   * @param int $p3
   *   [TODO:description]
   * @param [TODO:type] $p4
   *   [TODO:description]
   * @param [TODO:type] $p5
   *   [TODO:description]
   */
  public function myPublicMethod(array &$p1, \Test\Namespacing\With\A\ClassInterface $p2, int $p3, $p4, $p5 = NULL) {
    //
  }

}
