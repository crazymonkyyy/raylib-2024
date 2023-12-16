module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		with(button){
		if(z){
			status("z is down",1);
		}
		if(x.pressed){
			status("x was pressed");
		}
		if(ctrl+c){
			status("copied");
		}
		if(v.toggle){
			status("v is toggled on",1);
		}
		if(super_+shift+alt+b){
			status("your pressed allot of buttons",300);
		}
		enddrawing;
	}}
	CloseWindow();
}