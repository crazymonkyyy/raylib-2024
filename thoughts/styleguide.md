## submiting/reviewing guidelines

1. more code gooder, all example code that compiles is good code
2. the style guide is a suggestion
3. all grammer rewrites should be accepted without review
4. merge rights should be given out to anyone who has a firm handshake and a ounce of grit

## project structure

1. /raylib/ is for the bindings that a stolen from elsewhere and be replaced every major version with lazy hacks to make it work
2. /exmples/ should be example code, keep it small with good file names
3. /monkyyylib/ is where tacked on additions to raylib go
4. /lib/ is general purpose ulity files for d
5. /src/ is where the real project goes if this forked for a real project
6. biuld.d is the biulds script, use it and expand it

old style guide, TODO: update
----

## whitespace

#### principals
1. tabs
2. white space is for humans not machines, do not run an auto formater that makes white space match ()'s
3. () are for the machines not humans, do not run an auto formater that moves ()'s to match whitespace
4. tabs are for a *humans* conception of scope, do not "correct" an authors whitespace
5. comments should be honest

#### examples

```d
foreach(y,list;bar){
foreach(x,e;list){
	foo[x,y]=...;
}}
```
This is a 2d iteration where x and y are interlinked; as such, that tab represents that 2d iteration. (also note the `}}`)

```d
bar=foo
	.map
	.filter
	.reduce
```
this doesn't even contain {} but none the less is conceptually a 3 statement loop over foo; as such this tab represents that these statements are about foo

```d
bool empty(){i>=length;}
```
This is an extremely simple function, and therefore can be one line

```d
enum foo=[
	vec2(  1,999),
	vec2( 10,100),
	vec2(100, 10),
	vec2(999,  1),
];
```
This is a large data structure that needs multiple lines to be readable; spaces should be used to make "rectangular selection" modifications easy.

```d
if( ! foo.isvalid){
```
Unary `!` can be easy to miss, but massively effects the control flow, this whitespace highlights it for the reader. 

```d
int setup=10;
loop:
	setup--;
	if(setup==0){goto exit;}
exit:
setup=cleanup;
```
The code in the loop is indented as if it was a code block, dispite the control flow being completely manual.

## acceptable paradigms

#### data-oriented design
	in data-oriented design, you carefully design your data to fit your problem extremely well; then modify the data in the most straightforward way possible.

#### ranges
	Define a data structure to have a range based interface; then heavily use the std 

#### Soft functional
	[See prophet Carmacks essay](https://www.gamedeveloper.com/programming/in-depth-functional-programming-in-c-)
	
	soft functional is when you're attempting to minimize state, but not disallowing access to global variables, but do not get into monads and other memes

When using this style:

1. move complex conditional logic to functions that start with is and return bools. `foo.isvalid`
2. Stateful functions should be trivial (when possible) and return void.
3. Math and algorithms should be wrapped up in (mostly) pure functions and have documenting unit tests
4. If possible, limit mutability of the global variables; counters that strictly increase, append-only data structures, write-once

## naming

1. no capitals
2. strongly prefer trivial to spell words; ringarray > circularbuffer (I have to copy-paste circular to spell it correctly)
3. short local names should be on this list
	i: anonymous int
	f: anonymous float
	r: anonymous range
	ror: range of ranges
	x,y,z,w: dimensions
	R: range(type)
	F: anonymous function
	T,S,U: anonymous type
	o: output
	e: element (of a list)
4. Assume ufcs and consider the usage in a statement `foo.update` not `foo.fooupdate`

## comments

When submiting bad code, mark it as `TODO:`,`HACK:`, `BAD:` and then premptively defend yourself for why it exists.

Leave [vitriolic](https://youtu.be/k238XpMMn38), swear heavy code with your user name and date; when dealing with code that doesnt spark joy. This will improve morral for the next person; and mark what needs to be rewritten.