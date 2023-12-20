module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
enum explodelife=120;
struct explode{
	Vector2 center;
	int life=explodelife;
	float size(){
		return 30*(explodelife-life)/cast(float)explodelife;
	}
}
nullablearray!(explode,100) explodes;
struct line{
	import tempmath;
	Vector2 start;
	Vector2 end;
	int life;
	int lifetime()=>cast(int)dis(start,end);
	Vector2 mid(){
		auto x=remap(life,0.0,lifetime,start.x,end.x);
		auto y=remap(life,0.0,lifetime,start.y,end.y);
		return Vector2(x,y);
	}
}
nullablearray!(line,100) lines;
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		if(button.mouse1.pressed){
			explodes~=explode(GetMousePosition);
		}
		foreach(i,e;explodes[]){
			explodes[i].life--;
			DrawCircleV(e.center,e.size,color[i]);
			if(e.life==0){
				explodes[i]=null;
			}
		}
		foreach(i,e;lines[]){
			lines[i].life++;
			if(e.life==e.lifetime){
				lines[i]=null;
			}
			DrawLineV(e.start,e.mid,color[i]);
		}
		if(GetRandomValue(0,20)==0){
			lines~=line(Vector2(GetRandomValue(0,800),0),Vector2(GetRandomValue(0,800),640));
		}
		foreach(i,e;explodes[]){
			foreach(j,l;lines[]){
				if(CheckCollisionPointCircle(l.mid,e.center,e.size)){
					explodes~=explode(l.mid);
					lines[j]=null;
				}
		}}
		enddrawing;
	}
	CloseWindow();
}