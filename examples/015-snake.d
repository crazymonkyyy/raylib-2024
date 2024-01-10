module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
import tempmath;
mixin mainhack!();

staticarray!(Vector2,1000) snake;
float rot=45;
float speed=2;
auto impluse()=>Vector2(cos(rot)*speed,sin(rot)*speed);
Vector2 fruit;



void main_(){// hack for making swapping between wasm and native work
	makewindow;
	snake~=Vector2(300,300);
	snake~=Vector2(300,300);
	snake~=Vector2(300,300);
	snake~=Vector2(300,300);
	snake~=Vector2(300,300);
	snake~=Vector2(300,300);
	while (!WindowShouldClose()){
		startdrawing;
		foreach(i,e;snake[]){
			if(i==0){
				snake[i].x=e.x+impluse.x;
				snake[i].y=e.y+impluse.y;
			} else {
				snake[i].x=snake[i-1].x*.1+e.x*.9;
				snake[i].y=snake[i-1].y*.1+e.y*.9;
			}
			draw_(e,5);
		}
		watch!rot;
		
		with(button){
			if(left.down){rot+=1;}
			if(right.down){rot-=1;}
		enddrawing;
	}}
	CloseWindow();
}