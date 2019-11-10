#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: fenc=utf-8 ts=4 sw=4 et

"""
Python binding of the clang tool used to extract information of a function
declaration within Vim.

Prerequisites (MacOS):
- pip3 install clang
- brew install llvm

--------------------------------------------------------------------------------

If you've installed clang via your package manager then you might have a file
called 'libclang.so.<libclang-major-version>', for example: 'libclang.so.8'.
Go into the directory where this file exists using 'cd' and create a symlink:

    ln -s libclang.so.<libclang-major-version> libclang.so

Now it should be detectable via python if you do:

    $ python3
    >>> from clang.cindex import Index
    >>> Index.create()
    >>> <clang.cindex.Index object at 0x1084763d0>

--------------------------------------------------------------------------------

If you compiled manually:
Make sure that your $PATH and $LD_LIBRARY_PATH are set correctly.
The libclang binary its location should be defined in the $LD_LIBRARY_PATH.
"""

from clang.cindex import Index, CursorKind, Cursor
import sys
import json
import vim
import os
import tempfile
from typing import Union

FUNCTION = {}


def get_next_token(node: Cursor, key: str) -> Union[str, None]:
    """
    Get the next token from a node.

    :param node clang.cindex.Cursor: The node itself.
    :param key str: The key to get from the next token.
    :rtype str/none: The requested token or None otherwise.
    """
    try:
        token = next(node.get_tokens())
        return getattr(token, key)
    except Exception:
        return None


def find_node(node: Cursor, line: int) -> Union[Cursor, bool]:
    """
    Find a node based on a given line number.

    :param node clang.cindex.Cursor: The node itself.
    :param line int: The line number where the node is located at.
    :rtype clang.cindex.Cursor/bool: The found node or False otherwise.
    """
    if node.location.line == line:
        return node
    for child in node.get_children():
        result = find_node(child, line)
        if result:
            return result
    return False


def main():
    file_ext = vim.eval("expand('%:p:e')")
    ext = file_ext if file_ext else vim.eval('&filetype')

    lines = vim.eval("getline(line(1), line('$'))")
    current_line = int(vim.eval("line('.')"))

    # Save the lines to a temp file and parse that file.
    fd, filename = tempfile.mkstemp('.{}'.format(ext))
    try:
        with os.fdopen(fd, 'w') as tmp:
            tmp.write('\n'.join(lines))

        index = Index.create()
        tu = index.parse(filename)
        if tu:
            node = find_node(tu.cursor, current_line)
            while node:
                if node.kind in [CursorKind.TEMPLATE_NON_TYPE_PARAMETER, CursorKind.TEMPLATE_TYPE_PARAMETER]:
                    current_line += 1
                    node = find_node(tu.cursor, current_line)
                elif node.kind in [CursorKind.CXX_METHOD, CursorKind.FUNCTION_DECL, CursorKind.FUNCTION_TEMPLATE]:
                    FUNCTION['name'] = node.spelling
                    FUNCTION['returnType'] = get_next_token(node, 'spelling')
                    if 'parameters' not in FUNCTION.keys():
                        FUNCTION['parameters'] = []
                    for child in node.get_children():
                        if child.kind == CursorKind.PARM_DECL:
                            FUNCTION['parameters'].append({
                                'name': child.spelling,
                            })
                    print(json.dumps(FUNCTION))
                    break
                else:
                    break
    except Exception as e:
        print(e)
    finally:
        os.remove(filename)

if __name__ == '__main__':
    main()
