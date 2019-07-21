###
[TODO:description]

@function myFunc
###
myFunc = () -> x * x

###
[TODO:description]

@function myFunc
@param {[TODO:type]} x [TODO:description]
###
myFunc = (x) -> x * x

###
[TODO:description]

@function myFunc
@param {[TODO:type]} x [TODO:description]
###
myFunc = (x) => x * x

###
[TODO:description]

@function myFunc
@param {[TODO:type]} p1 [TODO:description]
@param {[TODO:type]} p2 [TODO:description]
@param {[TODO:type]} p3 [TODO:description]
###
myFunc = (p1, p2, p3) -> x * x

###
[TODO:description]

@function myFunc
@param {[TODO:type]} $p1 [TODO:description]
@param {[TODO:type]} $p2 [TODO:description]
@param {[TODO:type]} $p3 [TODO:description]
###
myFunc = ($p1, $p2, $p3) => x * x

###
[TODO:description]

@function String#dasherize
###
String::dasherize = ->
  this.replace /_/g, "-"
