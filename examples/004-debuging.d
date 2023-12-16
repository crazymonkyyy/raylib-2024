module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
import debugsystem;
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		static int i;
		i++;
		watch!i;
		watch!GetMousePosition;
		debugwriteln;
		if(button.f2.pressed){
			true.debugtoggle;
		}
		enddrawing;
	}
	CloseWindow();
}