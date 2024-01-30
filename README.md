## d raylib for wasm

a biuld envernment(not a lib) for wasm, copy and paste whatever files you wish, take a snap shot for real projects and contribute breaking changes whatevers

For *me* shiping software to the web(tho if a windows dev would like to make windows work that be great), tho theres a attempt to document.

```
install raylib enscription python dmd ldc
gh repo clone crazymonkyyy/raylib-2024
./biuld.d examples/001-helloworld
```

## Doc links

[Examples](docs/examplecode.md)

## biulding

./biuld.d [-mode] file

modes:
* (none) - native
* wasm - attempts to biuld wasm and runs 0.0.0.0 (use `python -m http.server`)
* itch - removes (some) wasm debugging, bundles up assets into a zip folder that works for itch.io
* delete - deletes (some) extra files such as whatever wasm spits out, us if you expect cashing is ruining debuging
* libtest - testing if libs actaully compile without linking file
* syntaxtest - even more restrictive compiling flags

## contributing

I'll merge whatever, and I marked several places of code with `TODO:`

For big projects I dont want todo: 

* I want a demo website with the examples compiled to wasm, which means figuring out github pages and making a whole website
* Vectors use a `mixin linear` thats commented out to let wasm compile at all, a long term solution for vector opoverloads
* clear well written docs
* a good long term solution to not having the std, a script that pulls out std functions? testing which files work with a broken libc? taking a copy? automating a chatbot to simplify each std function?

## beta todo list

* custom web page for examples
* fully tested, well designed, all op overloads data stuctures
* 10 examples games?
* TODO:
* handle all random todos

## windows

Windows isnt offically supported, but a test run was done

rough biuld commands
  1. steal this script and run it https://github.com/schveiguy/raylib-d/blob/master/install/source/app.d to get a "raylib.lib and raylib.dll"
  2.`ldc -I.\lib -I.\raylib -I.\monkyyylib -L-lraylib -i -mixin=mix -run examples\001-helloworld.d`
  
windows support todo:

	1. windows off by one of posix string args
	
	2. steal script and run it
	
	3. biuld.d more robust in general
