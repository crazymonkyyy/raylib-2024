import basic;
import tempmath;
mixin mainhack!();
enum smallest=8;
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
	void update(float step,bool friction)(){
		p.x+=v.x*step;
		p.y+=v.y*step;
		static if(friction){
			v.x*=.95;
			v.y*=.95;
		}
		v.y+=.2*step;
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
	void collide(float step)(ref ball o){
		if(CheckCollisionCircles(p,max(size,o.size),o.p,1)){//completely inside
			if(color_<o.color_){
				p.y-=o.size;
				v.y=0;
			} else {
				o.p.y-=size;
				o.v.y=0;
			}
		}
		if(CheckCollisionCircles(p,size,o.p,o.size)){
			auto x=p.x-o.p.x;
			auto y=p.y-o.p.y;
			auto n=Vector2(x,y).norm;
			if(n.y>.2&&v.y<-.2){v.y*=.5*step;}
			if(n.y<.2&&o.v.y>.2){o.v.y*=.5*step;}
			p.x+=n.x*.45*step;
			p.y+=n.y*.45*step;
			o.p.x-=n.x*.45*step;
			o.p.y-=n.y*.45*step;
			if(dis(p,o.p)<size/4){
				p.x+=1*step;
				p.y-=1*step;
				n.x*=5*step;
				n.y*=5*step;
			}
			v.x+=n.x*.1*step;
			v.y+=n.y*.1*step;
			o.v.x-=n.x*.1*step;
			o.v.y-=n.y*.1*step;
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
	if(balls[a].color_!=balls[b].color_){return;}
	bool touch(int a,int b){
		if(a==-1 || b==-1){return false;}
		if(balls[a].color_!=balls[a].color_){return false;}
		return CheckCollisionCircles(balls[a].p,balls[a].size*1.1,balls[b].p,balls[b].size*1.1);
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
	cleanup:
	balls[a].fren=b;
	balls[b].fren=a;
	return;
	match:
		if( ! uniq(a,b,c)) goto cleanup;
		if(balls.nulls[a]){goto cleanup;}
		if(balls.nulls[b]){goto cleanup;}
		if(balls.nulls[c]){goto cleanup;}
		if( ! allsame(balls[a].size,balls[b].size,balls[c].size)){goto cleanup;}
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
	auto logo=LoadTexture("assets/logo.png");
	while (!WindowShouldClose()){
		startdrawing;
		DrawTextureEx(logo,Vector2(0,0),0,.25,Colors.WHITE);
		drawH(left,top,right-left,bot-top);
		foreach(i,_;balls){
			foreach(j,__;balls){
				if(j>=i)break;
				combine(cast(int)i,cast(int)j);
		}}
		foreach(i,_;balls){
			balls[i].draw;
		}
		foreach(___;0..10){
			if(___==0){
				foreach(i,_;balls){
					balls[i].update!(.1,true);
				}
			}else{
				foreach(i,_;balls){
					balls[i].update!(.1,false);
				}
			}
			foreach(i,_;balls){
				foreach(j,__;balls){
					if(j>=i)break;
					//combine(cast(int)i,cast(int)j);
					balls[i].collide!.1(balls[j]);
				}
				//balls[i].update;
				//balls[i].draw;
			}
		}
		next.p=GetMousePosition;
		next.bound;
		next.draw(false);
		with(button){
		if(mouse1.pressed ||mouse1.ramp>30){
			loop:
			balls~=next;
			next.color_=cast(ubyte)min(GetRandomValue(0,12),GetRandomValue(0,6));
			//next.color_=cast(ubyte)GetRandomValue(0,24);
			//if(space.toggle &&GetRandomValue(0,10000)!=0){
			//	goto loop;
			//}
		}
		if(f3){
			foreach(i,_;balls){
				if(_.fren!=-1)
				DrawLineV(_.p,balls[_.fren].p,allcolors[7]);
		}}
		enddrawing;
	}}
	CloseWindow();
}