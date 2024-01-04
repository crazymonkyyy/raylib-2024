module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
enum lines=20;
alias button_=ulong;
alias buttons=staticarray!(button_,10);
buttons[lines] buttonsbyline;
alias mystring=str!120;
mystring[lines] stringsbyline;
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	auto keys=loadspritesheet!("assets/keys.png",16,16);
	enum offset=8;
	void drawbutton(buttons b_,int y){
		foreach(int x,b;b_){
			keys[cast(uint)b](x*32+offset,y,2);
	}}
	void drawlines(){
		enum lineheight=36;
		foreach(i;0..lines){
			drawbutton(buttonsbyline[i],i*lineheight);
			stringsbyline[i].drawtext(buttonsbyline[i].length*32+offset*2,i*lineheight,30);
		}
	}
	while (!WindowShouldClose()){
		startdrawing;
		static int activeline;
		drawlines;
		draw_(4,activeline*36+16,3.0);
		stringsbyline[activeline].type;
		with(button){
		import tempmath;
		if(down_.pressed) activeline=(++activeline).clamp(0,20);
		if(up.pressed) activeline=(--activeline).clamp(0,20);
		if(ctrl){
			"click one to add it to active line".status;
			DrawTexture(keys.baseimage,0,0,Colors.WHITE);
			keys[GetMouseX/16,GetMouseY/16];
			keys(32,420,6);
		}
		if(ctrl+mouse1){
			buttonsbyline[activeline]~=keys.i;
		}
		if(mouse2 && buttonsbyline[activeline].length>0){//TODO fix static array
			buttonsbyline[activeline].length--;
		}
		enddrawing;
	}}
	CloseWindow();
}