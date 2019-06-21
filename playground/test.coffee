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
@param {*} p1 TODO
@param {*} p2 TODO
@param {*} p3 TODO
###
myFunc = (p1, p2, p3) -> x * x

###
@description TODO
@function myFunc
@param {*} $p1 TODO
@param {*} $p2 TODO
@param {*} $p3 TODO
###
myFunc = ($p1, $p2, $p3) => x * x

###
@description TODO
@function String#dasherize
###
String::dasherize = ->
  this.replace /_/g, "-"
