# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import ladder


test "basic tests":
  var x = true
  var y = false
  contact(x):
    coil y
  
  check y
  
  contact(not x):
    check false
    coil y
    coil x
  
  check(not y)
  check(not x)

test "nested contacts":
  var x = true
  var y = false
  contact x:
    contact y:
      check false
    check true
  
  contact y:
    check false
  
  contact y:
    contact x:
      check false
    coil x
  
  contact x:
    check false
  
  check(not y)
  check(not x)
