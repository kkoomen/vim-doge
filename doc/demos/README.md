# Table of Contents
- [Table of Contents](#table-of-contents)
- [Demos and supported functionality](#demos-and-supported-functionality)
  * [PHP](#php)
  * [JavaScript](#javascript)
  * [Python](#python)

# Demos and supported functionality

This README contains several demos of some of the languages being supported by
DoGe and also specifies _what_ is being supported.

## PHP

Supported:
- Class properties (based on the constructor of the surrounding class)
- Class methods
- Functions

[![Demo PHP](https://asciinema.org/a/PXtgawXXnDOVbAm6Kk4cS2MmC.svg)](https://asciinema.org/a/PXtgawXXnDOVbAm6Kk4cS2MmC)

## JavaScript

JavaScript is one of the most complicated ones to support, because of all the
EcmaScript features and libraries that add TypeScript-like type hints.
Nonetheless, DoGe supports all of it.

Supported:
- Regular functions
- Prototype functions
- Generator functions
- ES6
  - Fat-arrow functions
  - Classes
  - Class methods
  - Class properties
  - Destructuring in parameter lists
- FlowJS/TypeScript-like type hints

All of the above is _also_ supported for TypeScript and NodeJS.

[![Demo JavaScript](https://asciinema.org/a/KUvRSPGyFVI0dKsblEa41RG3x.svg)](https://asciinema.org/a/KUvRSPGyFVI0dKsblEa41RG3x)

## Python

Supported:
- Functions
- Class methods
- Doc standards
  - reST
  - Sphinx
  - Numpy
  - Google
- Python 3.7+ type hints

[![Demo Python](https://asciinema.org/a/QKwuUrZphWPD6eZ3mowumkA1O.svg)](https://asciinema.org/a/QKwuUrZphWPD6eZ3mowumkA1O)
