#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: fenc=utf-8 ts=4 sw=4 et

def myFunc():
    """
    [TODO:description]

    """
    pass

def myFunc(p1: str = 'string', p2: int = 5):
    """
    [TODO:description]

    :param p1 str: [TODO:description]
    :param p2 int: [TODO:description]
    """
    pass

def myFunc(p1: Callable[[int], None] = {}) -> None:
    """
    [TODO:description]

    :param p1 Callable[[int], None]: [TODO:description]
    :rtype None: [TODO:description]
    """
    pass

def myFunc(p1: Callable[[int], None] = False, p2: Callable[[int, Exception], None]) -> Sequence[T]:
    """
    [TODO:description]

    :param p1 Callable[[int], None]: [TODO:description]
    :param p2 Callable[[int, Exception], None]: [TODO:description]
    :rtype Sequence[T]: [TODO:description]
    """
    pass

def myFunc(p1: int = 5, p2: str = 'string', p3: bool = True, p4: Callable[[int, Exception], None]) -> float:
    """
    [TODO:description]

    :param p1 int: [TODO:description]
    :param p2 str: [TODO:description]
    :param p3 bool: [TODO:description]
    :param p4 Callable[[int, Exception], None]: [TODO:description]
    :rtype float: [TODO:description]
    """
    pass

def myFunc(p1: Sequence[T]) -> Generator[int, float, str]:
    """
    [TODO:description]

    :param p1 Sequence[T]: [TODO:description]
    :rtype Generator[int, float, str]: [TODO:description]
    """
    pass

class MyClass(object):

    def __init__(self: MyClass):
        """
        [TODO:description]

        :param self MyClass: [TODO:description]
        """
        pass

    def myMethod(self: MyClass, p1: Sequence[T]) -> Generator[int, float, str]:
        """
        [TODO:description]

        :param self MyClass: [TODO:description]
        :param p1 Sequence[T]: [TODO:description]
        :rtype Generator[int, float, str]: [TODO:description]
        """
        pass

    def call(self, *args: str, **kwargs: str) -> str:
        """
        [TODO:description]

        :param self [TODO:type]: [TODO:description]
        :param args str: [TODO:description]
        :param kwargs str: [TODO:description]
        :rtype str: [TODO:description]
        """
        pass
