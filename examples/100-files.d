// eh todo, this seems annoing and idk how to access user files even in thoery on wasmd

module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		auto files=LoadDirectoryFiles(".");
		cast(int)(files.count).writeln;
		foreach(i;0..files.count){
			import std.string:fromStringz;
			(files.paths[i].fromStringz).writeln;
		}
		stdout.flush;
		with(button){
		
		enddrawing;
	}}
	CloseWindow();
}