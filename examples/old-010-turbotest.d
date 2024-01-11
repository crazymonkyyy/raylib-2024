

// BAD: to verbose, going to to go in a different direction, leaving for reference



module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
auto turbo(values...)(bool b,typeof(values[0]) defualt=typeof(values[0]).init){
	import tempmath;
	static array=[values];
	static int i=0;
	if(b){
		i++;
		return array[min(i-1,$-1)];
	} else {
		i=0;
		return defualt;
}}

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		static int i_;
		(str()~i_).drawtext(10,10,72);
		with(button){
			i_+=left.down.turbo!(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,2,3,4,5);
			if(left.down){
				"button down".drawtext(10,90);
			}
		enddrawing;
	}}
	CloseWindow();
}