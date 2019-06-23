#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: fenc=utf-8 ts=4 sw=4 et

def myFunc():
    """
    TODO

    """
    pass

def myFunc(p1: str = 'string', p2: int = 5):
    """
    TODO

    :param p1 str: TODO
    :param p2 int: TODO
    """
    pass

def myFunc(p1: Callable[[int], None] = {}) -> None:
    """
    TODO

    :param p1 Callable[[int], None]: TODO
    :rtype None: TODO
    """
    pass

def myFunc(p1: Callable[[int], None] = False, p2: Callable[[int, Exception], None]) -> Sequence[T]:
    """
    TODO

    :param p1 Callable[[int], None]: TODO
    :param p2 Callable[[int, Exception], None]: TODO
    :rtype Sequence[T]: TODO
    """
    pass

def myFunc(p1: int = 5, p2: str = 'string', p3: bool = True, p4: Callable[[int, Exception], None]) -> float:
    """
    TODO

    :param p1 int: TODO
    :param p2 str: TODO
    :param p3 bool: TODO
    :param p4 Callable[[int, Exception], None]: TODO
    :rtype float: TODO
    """
    pass

def myFunc(p1: Sequence[T]) -> Generator[int, float, str]:
    """
    TODO

    :param p1 Sequence[T]: TODO
    :rtype Generator[int, float, str]: TODO
    """
    pass

class MyClass(object):

    def __init__(self: MyClass):
        """
        TODO

        :param self MyClass: TODO
        """
        pass

    def myMethod(self: MyClass, p1: Sequence[T]) -> Generator[int, float, str]:
        """
        TODO

        :param self MyClass: TODO
        :param p1 Sequence[T]: TODO
        :rtype Generator[int, float, str]: TODO
        """
        pass

    def call(self, *args: str, **kwargs: str) -> str:
        """
        TODO

        :param self any: TODO
        :param args str: TODO
        :param kwargs str: TODO
        :rtype str: TODO
        """
        pass
