module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	//validateRaylibBinding();
	InitWindow(800, 640, "Hello, World!");
	SetTargetFPS(60);
	while (!WindowShouldClose()){
		BeginDrawing();
		ClearBackground(Colors.RAYWHITE);//TODO not raycolors
		DrawText("Hello, 5.0 raylib", 330, 300, 28, Colors.BLACK);
		EndDrawing();
	}
	CloseWindow();
}