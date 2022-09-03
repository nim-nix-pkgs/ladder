**[Documentation for `ladder` is hosted here.](http://ryuk.ooo/nimdocs/ladder/ladder.html)**

# ladder: Ladder Logic Macros for Nim

`ladder` contains the macro expressions necessary to use ladder logic
in Nim. Ladder logic is a form of logical program expression akin to
if-else, but has only one nested section instead of two. Wikipedia
has a good introduction to [ladder logic.](https://en.wikipedia.org/wiki/Ladder_logic#Syntax_&_Examples)

`ladder` contains two macros- `contact` and `coil`. Those familiar with
ladder logic will already know what these do by their name, but to
summarize:

  - `contact` takes an expression returing a boolean, as well as a code
    block. any non-coil expression inside a `contact` will only run if
    the expression is true. In other words, with the exception of coils,
    `contact` works exactly like an if statement.
  - `coil`s are what make ladder logic unique from a basic if statement.
    `coil` sets or clears a boolean, and it can only be put inside a
    `contact` block. If a contact's expression is false, `coil` will
    set the boolean variable given to it to false. If its contact is
    true, `coil` will set its given boolean to true. Thus, `coil` will
    always run when its contact is reached, even if the condition is false.

Ladder logic is rarely implemented in general-purpose programming languages,
but is ubiquitous in languages used on industrial programmable logic
controllers.

# Example

The (somewhat contrived) example below shows a basic Nim program that sets
and clears some booleans:

```nim
var
  x = true
  y = false
  z = false

if x:
  echo "hello, world!"
x = y

echo y    # true

z = x and y

if x and y:
  echo "true and true is true."

echo z    # true

if not z:
  echo "this text will not be printed."

x = not z

echo x    # false
```

This is the equivalent program, written using ladder logic:

```nim
import ladder

var
  x = true
  y = false
  z = false

contact x:
  echo "hello, world!"
  coil y

echo y    # true

contact(x and y):
  coil z
  echo "true and true is true."

echo z    # true

contact(not z):
  echo "this text will not be printed."
  coil x

echo x    # false
```
