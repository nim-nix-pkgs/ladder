# Package

version       = "0.4.0"
author        = "ryukoposting"
description   = "Ladder logic macros for Nim. documentation hosted at http://ryuk.ooo/nimdocs/ladder/ladder.html"
license       = "Apache-2.0"
srcDir        = "src"


# Dependencies

requires "nim >= 0.18.0"

task docs, "generate docs!":
  withDir "src":
    exec "nim doc2 ladder.nim"
