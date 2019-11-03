#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: fenc=utf-8 ts=4 sw=4 et

"""
Python binding of the clang tool used to generate information of a given file
along with a specific line number where a function or method might be defined.

Prerequisites (MacOS):
- pip3 install clang
- brew install llvm

Make sure that your $PATH and $LD_LIBRARY_PATH are set correctly.
The libclang binary its directory should be defined in the $LD_LIBRARY_PATH.

Usage: ./libclang.py <file> <line>
"""

from clang.cindex import Index, CursorKind, Config
from optparse import OptionParser, OptionGroup
import json
import sys

func = {}


def get_diag_info(diag, line):
    return {
        'severity': diag.severity,
        'location': diag.location,
        'spelling': diag.spelling,
        'ranges': diag.ranges,
        'fixits': diag.fixits
    }


def get_token(node, key):
    try:
        token = next(node.get_tokens())
        return getattr(token, key)
    except Exception as e:
        return None


def find_func(node, line, opts):
    if opts.verbose:
        print('-'*30)
        print('node location line', node.location.line)
        print('node kind', node.kind)
        print('node spelling', node.spelling)
        print('token spelling', get_token(node, 'spelling'))
    if node.location.line == line:
        for token in node.get_tokens():
            print(token.kind, token.spelling)
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
        find_func(child, line, opts)


def main():
    parser = OptionParser("usage: %prog [options] {filename} {line} [clang-args*]")
    parser.add_option("-v", "--verbose", dest="verbose",
                      help="Show verbose output",
                      action="store_true", default=False)
    parser.add_option("-d", "--diagnostics", dest="diagnostics",
                      help="Show verbose output",
                      action="store_true", default=False)
    parser.disable_interspersed_args()
    (opts, args) = parser.parse_args()
    filename, line = args

    if len(args) == 0:
        parser.error('invalid number arguments')
    print(args)

    index = Index.create()
    tu = index.parse(filename)
    if not tu:
        sys.exit(0)

    find_func(tu.cursor, line, opts)
    diags = [get_diag_info(d, line) for d in tu.diagnostics]
    if diags and opts.diagnostics:
        print(diags)
    if len(func.keys()) > 0:
        print(json.dumps(func))

if __name__ == '__main__':
    main()
