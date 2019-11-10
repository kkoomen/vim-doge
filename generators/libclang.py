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

from clang.cindex import Index, CursorKind
import json
import vim
import os
import tempfile

func = {}

def get_token(node, key):
    try:
        token = next(node.get_tokens())
        return getattr(token, key)
    except Exception:
        return None


def find_func(node, line):
    if node.location.line == line:
        if node.kind in [CursorKind.CXX_METHOD, CursorKind.FUNCTION_DECL]:
            if 'parameters' not in func.keys():
                func['parameters'] = []
            func['name'] = node.spelling
            func['returnType'] = get_token(node, 'spelling')
        elif node.kind == CursorKind.PARM_DECL:
            func['parameters'].append({
                'name': node.spelling,
            })
    for child in node.get_children():
        find_func(child, line)


def main():
    ext = vim.eval("&filetype")
    lines = vim.eval("getline(line(0), line('$'))")
    line = int(vim.eval("line('.')"))

    # Save the lines to a temp file and parse that file.
    fd, filename = tempfile.mkstemp('.{}'.format(ext))
    try:
        with os.fdopen(fd, 'w') as tmp:
            tmp.write('\n'.join(lines))

        index = Index.create()
        tu = index.parse(filename)
        if tu:
            find_func(tu.cursor, line)
            if len(func.keys()) > 0:
                print(json.dumps(func))
    except Exception as e:
        print(e)
    finally:
        os.remove(filename)

if __name__ == '__main__':
    main()
