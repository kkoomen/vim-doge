# This file contains test scenarios and their expected results. You should be
# able to generate the examples below.

###
@description TODO
@function myFunc
###
myFunc = () -> x * x

###
@description TODO
@function myFunc
@param {*} x TODO
###
myFunc = (x) -> x * x

###
@description TODO
@function myFunc
@param {*} x TODO
###
myFunc = (x) => x * x

###
@description TODO
@function myFunc
@param {*} arg1 TODO
@param {*} arg2 TODO
@param {*} arg3 TODO
###
myFunc = (arg1, arg2, arg3) -> x * x

###
@description TODO
@function myFunc
@param {*} $arg1 TODO
@param {*} $arg2 TODO
@param {*} $arg3 TODO
###
myFunc = ($arg1, $arg2, $arg3) => x * x

###
@description TODO
@function String#dasherize
###
String::dasherize = ->
  this.replace /_/g, "-"
