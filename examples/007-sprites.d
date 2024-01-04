module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	auto keys=loadspritesheet!("assets/keys.png",16,16);
	while (!WindowShouldClose()){
		static float rot=0;
		watch!rot;
		startdrawing;
		keys(300,500,2,rot);
		with(button){
		if(ctrl){
			"pick one".status;
			DrawTexture(keys.baseimage,0,0,Colors.WHITE);
			keys[GetMouseX/16,GetMouseY/16];
		}
		if(shift){
			"spin".status;
			rot+=1;
		}
		if(space.pressed){
			"poke".status;
			keys[keys.i+1](200,200,10);
		}
		if(z){
			keys(200,200,10);
		}
		enddrawing;
	}}
	CloseWindow();
}