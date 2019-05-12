#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: fenc=utf-8 ts=4 sw=4 et


def myFunc(param1: str = 'string', param2: int = 5):
    """
    TODO

    :param param1 str: TODO
    :param param2 int: TODO
    """
    pass

def myFunc(param1: Callable[[int], None] = {}) -> None:
    """
    TODO

    :param param1 Callable[[int], None]: TODO
    :rtype None: TODO
    """
    pass

def myFunc(param1: Callable[[int], None] = False, param2: Callable[[int, Exception], None]) -> Sequence[T]:
    """
    TODO

    :param param1 Callable[[int], None]: TODO
    :param param2 Callable[[int, Exception], None]: TODO
    :rtype Sequence[T]: TODO
    """
    pass

def myFunc(param1: int = 5, param2: str = 'string', param3: bool = True, param4: Callable[[int, Exception], None]) -> float:
    """
    TODO

    :param param1 int: TODO
    :param param2 str: TODO
    :param param3 bool: TODO
    :param param4 Callable[[int, Exception], None]: TODO
    :rtype float: TODO
    """
    pass

def myFunc(param1: Sequence[T]) -> Generator[int, float, str]:
    """
    TODO

    :param param1 Sequence[T]: TODO
    :rtype Generator[int, float, str]: TODO
    """
    pass

class MyClass(object):

    """Docstring for MyClass. """

    def __init__(self: MyClass):
        """
        TODO

        :param self MyClass: TODO
        """
        pass

    def myMethod(self: MyClass, param1: Sequence[T]) -> Generator[int, float, str]:
        """
        TODO

        :param self MyClass: TODO
        :param param1 Sequence[T]: TODO
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
