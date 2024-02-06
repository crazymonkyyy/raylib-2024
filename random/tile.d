module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
import tempmath;
import std;
alias Pi=raylib.PI;
Vector2[4] to(T:Vector2)(Rectangle r){
	return [
		Vector2(r.x    ,r.y    ),
		Vector2(r.x    ,r.y+r.h),
		//Vector2(r.x+r.w,r.y    ),
		Vector2(r.x+r.w,r.y+r.h),
		Vector2(r.x+r.w,r.y    ),
	];
}

/*
0: dither
1:lerped color
2:diangol
3:rounded
F:symbol
*/

Vector2 lerp4(Vector2 a, Vector2 b, ubyte p){
	int p_=4-p;
	return Vector2(
		(p*a.x)/4+(p_*b.x)/4,
		(p*a.y)/4+(p_*b.y)/4,
	);
}
T lerp4(T)(T a,T b, ubyte p){
	int p_=4-p;
	return (a*p+b*p_)/4;
}
T lerp18(T)(T a,T b,ubyte p){
	return cast(T)((a*(p+1)+b*(17-p))/18);
}

alias drawcommand=ubyte;
void draw(Rectangle r,drawcommand c,Color c1,Color c2){
	final switch(c%16){
		static foreach(i;0..16){
			case i: draw!i(r,c/16,c1,c2); return;
}}}
ubyte[18] dither=[15, 17, 11, 8, 0, 9, 12, 3, 1, 10, 14, 7, 6, 13, 2, 4, 16, 5];//=iota(16).array.randomShuffle;
void draw(int i:0)(Rectangle r,drawcommand c,Color c1,Color c2){
	//DrawRectangleRec(r,c>7?c1:c2);
	//c1=c>7?c2:c1;
	foreach(x;r.x..r.x+r.w){
	foreach(y;r.y..r.y+r.h){
		//if(c<=dither[(x+y/4)%$])
			DrawPixel(cast(int)x,cast(int)y,
				c>=dither[cast(int)(x+(y%4)*4)%$]?c1:c2);
	}}
}
void draw(int i:1)(Rectangle r,drawcommand c,Color c1,Color c2){
	DrawRectangleRec(r,
		Color(
			lerp18(c1.r,c2.r,c),
			lerp18(c1.g,c2.g,c),
			lerp18(c1.b,c2.b,c),
	));
}
void draw(int i:2)(Rectangle r,drawcommand c,Color c1,Color c2){
	DrawRectangleRec(r,c2);
	Vector2[4] t_=r.to!Vector2;
	t_=t_[].map!(a=>lerp4(t_[c/4],a,c%4)).array;
	Vector2[3] t=t_[].remove((c/4+2)%4).array;
	DrawTriangle(t[0],t[1],t[2],c1);
}
void draw(int i:3)(Rectangle r,drawcommand c,Color c1,Color c2){
	DrawRectangleRec(r,c2);
	ubyte a=c%4;
	ubyte b=c/4;
	DrawCircleSector(
		r.to!Vector2[b],
		r.w.lerp4(float(0),cast(ubyte)(4-a)),
		(b-1)*-90,
		b*-90,
		16,
		c1,
	);
}
void draw(int i:4)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:5)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:6)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:7)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:8)(Rectangle r,drawcommand c,Color c1,Color c2){}

void draw(int i:9)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:10)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:11)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:12)(Rectangle r,drawcommand c,Color c1,Color c2){}

void draw(int i:13)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:14)(Rectangle r,drawcommand c,Color c1,Color c2){}
void draw(int i:15)(Rectangle r,drawcommand c,Color c1,Color c2){}

void main_(){// hack for making swapping between wasm and native work
	//dither=iota(ubyte(16)).array.randomShuffle;
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		
		
		enum offsetx=100;
		enum offsety=100;
		enum xgrowth=32;
		enum ygrowth=32;
		foreach(ubyte i;0..256){
			auto r=Rectangle(i%16*xgrowth+offsetx,i/16*ygrowth+offsety,24,24);
			draw(r,i,allcolors[7],allcolors[3]);
		}
		
		
		enddrawing;
	}
	CloseWindow();
}