module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();


float[4] splinemuls(float f){
	enum sixth=1.0/6;
	float x=f<.5?f:1-f;
	float xx=x*x;
	float p1=xx+xx*sixth-x+x*sixth;
	p1/=2;
	float p4=-xx*sixth- x*sixth;
	p4/=2;
	float[4] o;
	o[0]=f<.5?p1:p4;
	o[3]=f<.5?p4:p1;
	o[1]=f-o[0];
	o[2]=(1-f)-o[3];
	return o;
}
Vector2 lerp4(Vector2[4] a,float f){
	auto b=splinemuls(f);
	Vector2 o;
	foreach(i;0..4){
		o.x+=a[i].x*b[i];
		o.y+=a[i].y*b[i];
	}
	return o;
}

Vector2[] points;

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		with(button){
		if(mouse1.pressed){
			points~=GetMousePosition;
		}
		foreach(p;points){
			DrawCircleV(p,3,color);
		}
		import std;
		foreach(ps;points.slide!(No.withPartial)(4).map!(a=>a.staticArray!4)){
		foreach(i;0..100){
			DrawPixelV(lerp4(ps,i/100.0),color[2]);
		}}
		
		enddrawing;
	}}
	CloseWindow();
}
