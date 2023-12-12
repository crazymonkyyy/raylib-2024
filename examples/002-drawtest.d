module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		draw_(2,3,4,5);//TODO: remove _ and space out
		draw_(2,3,4);
		draw_(2,3);
		EndDrawing();
	}
	CloseWindow();
}