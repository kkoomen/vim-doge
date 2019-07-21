<?php

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route as BaseRoute;
use Symfony\Component\HttpFoundation\RedirectResponse as RedirectResponseBase, Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

function myFunc() {}

function myFunction(array &$p1, string $p2, &$p3 = NULL, \Drupal\core\Entity\Node $p4) {
  //
}

function myFunction(Response $p4) {
  // This should return \Symfony\Component\HttpFoundation\Response since
  // 'Response' is not defined as a an alias.
}

function myFunction(BaseRoute $p4) {
  // This should return 'BaseRoute' since it is defined as an alias.
}

function myFunction(AbstractController $p4) {
  // This should return
  // \Symfony\Bundle\FrameworkBundle\Controller\AbstractController since
  // 'AbstractController' is not defined as an alias.
}

function myFunction(RedirectResponse $p4) {
  // This should return 'RedirectResponse' since it is defined as an alias.
}

class MyClass {

  protected $entityQueryFactory;

  public function __construct(\Drupal\Core\Config\Entity\Query\QueryFactory $eqf, AbstractController $controller) {
    $this->entityQueryFactory = $eqf;
    $this->controller = $controller;
  }

  protected $controller;

  public function myPublicMethod(array &$p1, \Test\Namespacing\With\A\ClassInterface $p2, int $p3, $p4, $p5 = NULL) {
    //
  }

}
