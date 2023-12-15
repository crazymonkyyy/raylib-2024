module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		with(button){
		if(z){
			"z.pressed".writeln;
		}
		if(x.toggle){
			"x toggle".writeln;
		}
		if(ctrl+c){
			"copied".writeln;
		}
		if(super_+shift+alt+v){
			"hi".writeln;
		}
		EndDrawing();
	}}
	CloseWindow();
}