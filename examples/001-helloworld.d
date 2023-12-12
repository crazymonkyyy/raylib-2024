module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		DrawText("Hello, 5.0 raylib", 330, 300, 28, Color("dc322f"));
		EndDrawing();
	}
	CloseWindow();
}