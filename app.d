module helloworld;
import basic;
//import std.stdio;
import raylib;
mixin template foo(){
}
mixin foo!();
extern(C) void main(){
	//validateRaylibBinding();
	InitWindow(800, 640, "Hello, World!");
	SetTargetFPS(60);
	while (!WindowShouldClose()){
		BeginDrawing();
			
		ClearBackground(Colors.RAYWHITE);
		DrawText("Hello, 5.0 raylib", 330, 300, 28, Colors.BLACK);
		EndDrawing();
	}
	CloseWindow();
}

