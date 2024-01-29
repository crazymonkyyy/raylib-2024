module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		draw_(20,30,40,50);//TODO: remove _ and space out
		draw_(120,30,40);
		draw_(220,30);
		enddrawing;
	}
	CloseWindow();
}