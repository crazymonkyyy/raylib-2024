import basic;
import tempmath;
mixin mainhack!();
enum smallest=2.75;
enum incrment=5;
enum left=200;
enum right=750;
enum bot=600;
enum top=100;
struct ball{
	Vector2 p;
	Vector2 v;
	float size()=>smallest+color_*incrment;
	ubyte color_;
	Color color()=>monkyyycolor.color[color_];
	void update(){
		p.x+=v.x;
		p.y+=v.y;
		v.x*=.95;
		v.y*=.95;
		v.y+=.2;
		bound;
	}
	auto bound(){
		if( ! CheckCollisionCircleRec(p,1,Rectangle(left,top,right-left,bot-top))){
			v.x*=.8;
			v.y*=.8;
		}
		p.x=clamp(p.x,left+size,right-size);
		p.y=clamp(p.y,top+size,bot-size);
	}
	void draw(bool b=true){
		auto f=b?&DrawCircle:&DrawCircleLines;
		f(cast(int)p.x,cast(int)p.y,size,color);
	}
	void collide(ref ball o){
		if(CheckCollisionCircles(p,size,o.p,o.size)){
			auto x=p.x-o.p.x;
			auto y=p.y-o.p.y;
			auto n=Vector2(x,y).norm;
			if(n.y>.2&&v.y<-.2){v.y*=.5;}
			if(n.y<.2&&o.v.y>.2){o.v.y*=.5;}
			p.x+=n.x*.5;
			p.y+=n.y*.5;
			o.p.x-=n.x*.5;
			o.p.y-=n.y*.5;
			if(dis(p,o.p)<size/2){
				p.x+=1;
				p.y-=1;
				n.x*=5;
				n.y*=5;
			}
			v.x+=n.x*.1;
			v.y+=n.y*.1;
			o.v.x-=n.x*.1;
			o.v.y-=n.y*.1;
		}
	}
}
nullablearray!(ball,1000) balls;
void main_(){
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		drawH(left,top,right-left,bot-top);
		foreach(i,_;balls){
			foreach(j,__;balls){
				if(j>=i)break;
				balls[i].collide(balls[j]);
			}
			balls[i].update;
			balls[i].draw;
		}
		with(button){
		if(mouse1.pressed){
			balls~=ball(GetMousePosition,Vector2(0,10),3);
		}
		enddrawing;
	}}
	CloseWindow();
}