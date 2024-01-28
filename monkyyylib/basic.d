version(D_BetterC){
	public import wasmstd; 
	enum betterc=true;
	mixin template mainhack(){
		extern(C) void main()=>main_;
	}
	//extern(C) void __assert(bool* b,char* s,){
	//
	//}
} else {
	public import std.conv:to;
	public import std.stdio;
	enum betterc=false;
	mixin template mainhack(){
		extern(C) void main()=>main_;
	}
}
public import raylib;
public import monkyyycolor;
public import mystring;
public import monkyyydraw;
public import monkyyykeys;
public import staticabstractions;
public import debugsystem;
public import staticsizedata;
public import fileio;
void makewindow(){
	activecolorscheme=solarizeddark;
	version(D_BetterC){
		//validateRaylibBinding();
		InitWindow(800, 640, "Hello, World!");
		SetTargetFPS(60);
	} else {
		validateRaylibBinding();
		InitWindow(800, 640, "Hello, World!");
		SetWindowPosition(1700,0);//TODO: make customizable, config file
		SetTargetFPS(60);
	}
	InitAudioDevice;
}
str!120 statusstring;
int statusdecay;
void status(T)(T status_,int length=120){
	statusstring.delete_;
	statusstring~=status_;
	statusdecay=length;
}
void startdrawing(){
	resetcolors;
	BeginDrawing();
	ClearBackground(background);
}
void enddrawing(){
	if(button.f9.pressed){
		swapcolorscheme;
	}
	if(button.f10.toggle){
		DrawFPS(0,0);
	}
	if( ! IsWindowFocused){status("click to focus",1);}//TODO: doesnt work on wasm where the issue was
	if(statusdecay-->0){
		statusstring.drawtext(-800,-640);//TODO: colors?
	} else {
		statusdecay=0;//prevent underflow
	}
	debugsystemending;
	EndDrawing();
}