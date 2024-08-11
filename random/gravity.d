import basic;
mixin mainhack!();

Vector2[] points;
auto path(Vector2 start){
	struct Path{
		Vector2 front;
		Vector2 momentium;//=Vector2(0,0);
		void popFront(){
			foreach(v;points){
				auto pull=1/(front-v).length;
				pull*=pull;
				momentium+=(v-front).normal*pull*100;
			}
			momentium*=.9999;
			front+=momentium;
			empty=empty_;
		}
		bool empty=false;
		bool empty_(){
			foreach(v;points){
				if((v-front).length<5){return true;}
			}
			return false;
		}
	}
	return Path(start);
}
auto slide2(R)(R r){
	struct Slide2{
		R r;
		typeof(R.front) last;
		auto front()=>pair(last,r.front);
		void popFront(){
			last=r.front;
			r.popFront;
		}
		bool empty()=>r.empty;
	}
	auto t=Slide2(r);
	t.popFront;
	return t;
}
auto last(R)(R r){
	typeof(r.front()) e;
	while( ! r.empty){
		e=r.front;
		r.popFront;
	}
	return e;
}
auto closest(Vector2 v){
	import std;
	return points.map!(a=>(a-v).length).minIndex;
}
import std;
enum W=600;
enum H=400;
typeof(path(Vector2()))[H][W] paths;
void main_(){
	makewindow;
	points~=Vector2(100,100);
	points~=Vector2(400,200);
	points~=Vector2(300,50);
	
	foreach(x;0..W){
	foreach(y;0..H){
		paths[x][y]=path(Vector2(x,y));
	}}
	while(!WindowShouldClose()){
		startdrawing;
		foreach(x;0..W){
		foreach(y;0..H){
			foreach(i;0..10){
				if(paths[x][y].empty) break;
				paths[x][y].popFront;
			}
			DrawPixel(x,y,color[paths[x][y].front.closest*2]);
		}}
		
		//auto e=path(GetMousePosition).take(1000).last.closest;
		foreach(a,b;path(GetMousePosition).slide2.take(10000)){
			DrawLineV(a,b,allcolors[7]);
		}
		
		with(button){
			if(mouse2.pressed){
				points~=GetMousePosition;
			}
		
		enddrawing;
	}}
	CloseWindow();
}
