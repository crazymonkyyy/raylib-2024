module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();

Vector2[] points;
float[4] splinemuls(float f){
	enum sixth=1.0/6;
	float x=f<.5?f:1-f;
	float xx=x*x;
	float p1=xx+xx*sixth-x+x*sixth;
	float p4=-xx*sixth- x*sixth;
	float[4] o;
	o[0]=f<.5?p1:p4;
	o[3]=f<.5?p4:p1;
	o[1]=f-o[0];
	o[2]=(1-f)-o[3];
	return o;
}

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		
		foreach(x;0..800){
			auto a=splinemuls(x/800.0);
			DrawPixel(x,cast(int)(a[0]*-400+500),color[0]);
			DrawPixel(x,cast(int)(a[1]*-400+500),color[1]);
			DrawPixel(x,cast(int)(a[2]*-400+500),color[2]);
			DrawPixel(x,cast(int)(a[3]*-400+500),color[3]);
		}
		
		enddrawing;
	}
	CloseWindow();
}
