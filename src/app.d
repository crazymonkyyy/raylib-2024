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
	int fren=-1;
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
			v.x*=.5;
			v.y*=.5;
		}
		p.x=clamp(p.x,left+size,right-size);
		p.y=clamp(p.y,top+size,bot-size);
	}
	void draw(bool b=true){
		auto f=b?&DrawCircle:&DrawCircleLines;
		f(cast(int)p.x,cast(int)p.y,size,color);
	}
	void collide()(ref ball o){
		if(CheckCollisionCircles(p,size,o.p,o.size)){
			auto x=p.x-o.p.x;
			auto y=p.y-o.p.y;
			auto n=Vector2(x,y).norm;
			if(n.y>.2&&v.y<-.2){v.y*=.5;}
			if(n.y<.2&&o.v.y>.2){o.v.y*=.5;}
			p.x+=n.x*.45;
			p.y+=n.y*.45;
			o.p.x-=n.x*.45;
			o.p.y-=n.y*.45;
			if(dis(p,o.p)<size/4){
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
bool uniq(T)(T a, T b, T c) {
	if (a == b || a == c || b == c) {
		return false;
	}
	return true;
}
bool allsame(T)(T a, T b, T c) {
	return a == b && b == c;
}

nullablearray!(ball,1000) balls;
void combine(int a,int b){
	bool touch(int a,int b){
		if(a==-1 || b==-1){return false;}
		return CheckCollisionCircles(balls[a].p,balls[a].size*1.5,balls[b].p,balls[b].size*1.5);
	}
	if( ! touch(a,b)){return;}
	int c;
	if(a!=balls[a].fren && touch(a,balls[a].fren)){
		c=balls[a].fren;
		goto match;
	}
	if(b!=balls[b].fren && touch(b,balls[b].fren)){
		c=balls[b].fren;
		goto match;
	}
	balls[a].fren=b;
	balls[b].fren=a;
	return;
	match:
		if( ! uniq(a,b,c)) return;
		if(balls.nulls[a]){return;}
		if(balls.nulls[b]){return;}
		if(balls.nulls[c]){return;}
		if( ! allsame(balls[a].size,balls[b].size,balls[c].size)){return;}
		balls~=ball(Vector2(
				(balls[a].p.x+balls[b].p.x+balls[c].p.x)/3,
				max(balls[a].p.y,balls[b].p.y,balls[c].p.y)),
				Vector2(0,0),
				cast(ubyte)(balls[a].color_+1),
				);
		balls.nulls[a]=true;
		balls.nulls[b]=true;
		balls.nulls[c]=true;
}
ball next;
void main_(){
	makewindow;
	next.v=Vector2(0,10);
	next.color_=3;
	while (!WindowShouldClose()){
		startdrawing;
		drawH(left,top,right-left,bot-top);
		foreach(i,_;balls){
			foreach(j,__;balls){
				if(j>=i)break;
				combine(cast(int)i,cast(int)j);
				balls[i].collide(balls[j]);
			}
			balls[i].update;
			balls[i].draw;
		}
		next.p=GetMousePosition;
		next.bound;
		next.draw(false);
		with(button){
		if(mouse1.pressed ||mouse1.ramp>30){
			balls~=next;
			next.color_=cast(ubyte)min(GetRandomValue(0,8),GetRandomValue(0,4));
		}
		enddrawing;
	}}
	CloseWindow();
}