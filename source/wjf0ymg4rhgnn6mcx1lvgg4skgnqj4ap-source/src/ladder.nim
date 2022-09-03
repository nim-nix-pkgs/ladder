## Ladder logic control blocks implemented with Nim macros, using
## standard contact-coil semantics.
##
## .. code-block:: nim
##  import ladder
##
##  var
##    x = true
##    y = false
##    z = false
##
##  contact x:
##    echo "hello, world!"
##    coil y
##
##  echo y    # true
##  
##  contact(x and y):
##    coil z
##
##  echo z    # true
##  
##  contact(not z):
##    echo "this text will not be printed."
##    coil x
##  
##  echo x    # false
##

import macros

macro contact*(cond, contents: untyped): untyped =
  ## A `contact`_ block takes a condition `cond`_ of boolean type.
  ## If the boolean is true, code inside the block will be executed
  ## and all `coil`_ s contained by the block will be set to true.
  ## If `cond`_ is false, coils contained by the contact will be
  ## set to false, and no other code inside the contact will run.
  result =
    nnkStmtList.newTree(
      nnkLetSection.newTree(
        nnkIdentDefs.newTree(
          newIdentNode("contactValue"),
          newEmptyNode(),
          cond)))
  
  for stm in contents:
    var isCoil =
      case stm.kind
      of nnkCommand, nnkCall:
        (stm[0].kind == nnkIdent) and (stm[0].strVal == "coil")
      of nnkDotExpr:
        var lastIsCoil = false
        for c in stm:
          lastIsCoil = (c.kind == nnkIdent) and (c.strVal == "coil")
        lastIsCoil
      else:
        false
    if not isCoil:
      result.add(
        nnkIfStmt.newTree(
          nnkElifBranch.newTree(
            nnkInfix.newTree(
              newIdentNode("=="),
              cond,
              newIdentNode("true")),
            nnkStmtList.newTree(stm))))
    else:
      result.add stm
  
  result =
    nnkStmtList.newTree(
      nnkBlockStmt.newTree(
        newEmptyNode(),
        result))

macro coil*(contents: untyped): untyped =
  ## `coil` may only be called inside a `contact` block.
  ## coil takes one argument- a boolean variable. The boolean
  ## is set if the surrounding contact is true, and cleared
  ## when the surrounding contact is false.
  if contents.kind != nnkIdent:
    error "\"coil\" may only be used on a boolean variable"
  nnkStmtList.newTree(
    nnkAsgn.newTree(
      contents,
      newIdentNode("contactValue")))
