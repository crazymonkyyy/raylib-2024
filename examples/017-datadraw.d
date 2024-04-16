module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
alias lookuptable=ubyte[256];
lookuptable x;
lookuptable y;
void fill(ref lookuptable i){
	foreach(ubyte j;0..256){
		i[j]=j;
	}
}

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	x.fill;
	y.fill;
	while (!WindowShouldClose()){
		startdrawing;
		static int i;
		i++;
		i%=256;
		DrawCircle(x[i],y[i],5.0,color);
		with(button){
		if((shift+z).released){
			status("released");
		}
		enddrawing;
	}}
	CloseWindow();
}
