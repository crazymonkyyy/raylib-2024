### Examples

examples are surprizinly in the examples folder, this is the expected output and some explaination of what I expect it to show

## [helloworld](../examples/001-helloworld.d)

![](helloworld.png)

Drawing text, some random syntax for my string type, and colors; messy rn

## [drawtest](../examples/002-drawtest.d)

![](drawtest.png)

the api I had in mind depends on named arguments working with templates; they dont,
waiting on if that changes before making a complicated workaround

## [buttons and messages](../examples/003-buttons-and-messages.d)

(interactive but boring skiping image)

status and button syntax, read the damn code and trust

## [debuging](../examples/004-debuging.d)

(interactive but boring skiping image)

using "watch" to add a varible to the debug menu on F2

## [missle command](../examples/005-misslecommand.d)

![](missle.gif)

https://monkyyy.itch.io/test-wasm-missle-command

Simple dumb game, showing patterns for how id use colors, a data stucture

## [colorscheme](../examples/006-colorscheme.d)

![](colors.gif)

showings the colorschemes, and some color syntax

## [sprites](../examples/007-sprites.d)

![](sprites.gif)

sprite sheet loading

## [typing](../examples/008-typing.d)

![](type.gif)

single line typing

## [keybinding tool](../examples/009-keybindingstool.d)

![](keybinds.gif)

https://monkyyy.itch.io/keybinding-tool

Tool for making keybindings graphics

## [key rampup](../examples/010-key-rampup.d)

![](ramp.gif)

keys presses with more personablity, these abstractions instead of a bool return a ubyte, for how long its been held down which leads to =>

## [curve drawing](../examples/011-curvedrawing.d)

![](curves.gif)

a way to draw a (up to 9) ubyte[256] with some visualizations to get a feel for it; combine it with key binds ramps to make some quick and dirty game feel, or color remaping, or just some data

Not wasm rn because file io sux and work in progress

## [snake](../examples/015-snake.d)

![](snake.gif)

https://monkyyy.itch.io/snake

tank controls snake with lookup tables and key ramping, messy for wasm compadity

## [music](../examples/016-music.d)

reusable musicbox