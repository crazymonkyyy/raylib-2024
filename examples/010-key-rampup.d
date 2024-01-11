module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		with(button){
		draw_(10,10,cast(int)space.ramp,20);
		draw_(10,40,cast(int)space.decay(1,1),20);
		draw_(10,70,cast(int)space.decay(3,1),20);
		draw_(10,100,cast(int)space.decay(1,3),20);
		draw_(10,130,cast(int)space.decay(5,5),20);
		draw_(10,160,cast(int)space.tapable(10,1,1),20);
		draw_(10,190,cast(int)space.tapable(6,3,3),20);
		draw_(10,220,cast(int)space.tapable(5,5,5),20);
		
		if(space.down){
			"button down".drawtext(10,300);
		}
		enddrawing;
	}}
	CloseWindow();
}