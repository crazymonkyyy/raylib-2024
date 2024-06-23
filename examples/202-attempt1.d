module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
import tempmath;

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
Vector2 lerp2(Vector2 a,Vector2 b,float f){
	return a*f+(1-f)*b;
}
float lazyexo(byte i){
	if(i==-128){return 0;}
	if(i<0){return 1/lazyexo(cast(byte)-i);}
	enum table1=[0.0,1.0/5,1.0/3,1.0/2];
	enum table2=[1,2,5,10];
	float frac=table1[i%4];
	i/=4;
	uint signif1=table2[i%4];
	i/=4;
	signif1<<=i*4;
	return signif1+signif1*frac;
}
Vector2 ease(Vector2 a,Vector2 b,ubyte[256] table,float per){
	per=per.clamp(0,1);
	int[4] which;
	int i=(cast(int)(per*254));
	assert(i.between(0,254),i.to!string);
	switch(i){
		case 0: which=[0,0,1,2];break;
		case 254: which=[253,254,255,255];break;
		default:which=[i-1,i,i+1,i+2];
	}
	Vector2[4] points=[
		lerp2(a,b,table[which[0]]/256.0),
		lerp2(a,b,table[which[1]]/256.0),
		lerp2(a,b,table[which[2]]/256.0),
		lerp2(a,b,table[which[3]]/256.0),
	];
	return lerp4(points,per*254-i);
}
Vector2 pointa;
Vector2 pointb;
ubyte[256] table;
float per=0;
byte speed;
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		drawH(0,0,512,512);
		foreach(int x_,i;table){
			int x=x_*2;
			int y=(255-i)*2;
			draw_(x+0,y+0);
			draw_(x+0,y+1);
			draw_(x+1,y+0);
			draw_(x+1,y+1);
		}
		DrawCircleV(pointa,5,color[1]);
		DrawCircleV(pointb,5,color[2]);
		with(button){
		if(mouse1.down){
			import tempmath;
			table[min($-1,max(0,GetMouseX/2))]=255-cast(ubyte)(GetMouseY/2);
		}
		if(ctrl){
			pointa=GetMousePosition;
		}
		if(shift){
			pointb=GetMousePosition;
		}
		if(mouse1.pressed && GetMouseX.between(512,542)&& GetMouseY.between(0,255)){
			speed=cast(byte)(GetMouseY-128);
		}
		if(space){per=0;}
		if(shift+space){per=-1;}
		per+=lazyexo(speed);
		auto per_=per*10000;
		watch!per_;
		auto speed_=lazyexo(speed);
		watch!(speed_);
		DrawLine(512,speed+128,542,speed+128,text);
		if(a){
			per=GetMouseX/512.0;
		}
		DrawCircleV(ease(pointa,pointb,table,per),7,color[3]);
		DrawCircleV(lerp2(pointa,pointb,per),6,color[4]);
		auto which=cast(int)(per.clamp(0.0,1.0)*254);
		auto which_=which*1000;
		watch!which_;
		auto per3=(table[which]/256.0)*1000;
		watch!per3;
		DrawCircleV(lerp2(pointa,pointb,table[which]/256.0),5,color[5]);
		
		enddrawing;
	}}
	CloseWindow();
}
