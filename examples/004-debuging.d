module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		static int i;
		watch!i;
		i++;
		watch!i;
		watch!GetMousePosition;
		"press f2 for debug infomation".drawtext(300,400);
		enddrawing;
	}
	CloseWindow();
}