
###
@function square
@description TODO
@param {*} x - TODO
###
square = (x) -> x * x

math =
  root:   Math.sqrt
  square: square
  ###
  @function cube
  @description TODO
  @param {*} x - TODO
  ###
  cube:   (x) -> x * square x
