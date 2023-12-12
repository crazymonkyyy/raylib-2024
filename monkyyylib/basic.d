version(D_BetterC){
	public import wasmstd; 
	enum betterc=true;
	mixin template mainhack(){
		extern(C) void main()=>main_;
	}
} else {
	public import std;
	enum betterc=false;
	mixin template mainhack(){
		extern(C) void main()=>main_;
	}
}
public import raylib;
public import monkyyycolor;
public import mystring;
public import monkyyydraw;
void makewindow(){
	activecolorscheme=solarizeddark;
	version(D_BetterC){
		validateRaylibBinding();
		InitWindow(800, 640, "Hello, World!");
		SetTargetFPS(60);
	} else {
		validateRaylibBinding();
		InitWindow(800, 640, "Hello, World!");
		SetWindowPosition(1700,0);//TODO: make customizable, config file
		SetTargetFPS(60);
	}
}
void startdrawing(){
	BeginDrawing();
	ClearBackground(background);
}