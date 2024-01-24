module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
import tempmath;
import myalgorithms;
mixin mainhack!();

staticarray!(Vector2,1000) snake;
float rot=45;
float speed=2;
auto impluse()=>Vector2(cos(rot)*speed,sin(rot)*speed);
Vector2 fruit;
float[256] turncurve;

void movefruit(){
	fruit.x=GetRandomValue(100,700);
	fruit.y=GetRandomValue(100,540);
}

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	turncurve=[
	0x007E7E7D7D7D7D7D,0x7D7D7D7C7C7C7C7C,0x7C7C7B7B7B7B7B7B,0x7B7B7B7B7B7B7877,0x6F6C64605C525048,0x44403D3935302C28,0x26231F1C1A181613,0x12111110100F0F0F,
	0x0F0F0F0F0F0E0E0E,0x0E0E0E0E0E0E0E0F,0x0F0F0F0F0F101010,0x1111111111121314,0x1415161718191A1C,0x1D1E20222426282A,0x2B2D2F313336383B,0x3E404346494C4F51,
	0x5356585A5C5F6265,0x686A6C6E7174777B,0x7D7F818385878B8D,0x909396999C9D9FA1,0xA2A4A5A7A9ABADAF,0xB1B4B5B6B8B8B9BA,0xBBBCBEBEBFC0C1C3,0xC4C5C6C7C8C9CBCB,
	0xCCCCCDCDCECFD0D0,0xD1D1D2D3D4D4D5D6,0xD6D7D8D8D9DADADB,0xDCDDDFDFE0E1E2E2,0xE3E4E4E5E6E7E7E8,0xE9E9EAEBEBECEDEE,0xEFEFEFF0F0F0F000,0x0000000000000000,
	].binaryblob.toiter.map!(a=>a/float(25)).array;
	turncurve[0]=0;
	turncurve[1]+=20;
	turncurve[4]-=5;
	turncurve[9]-=5;
	turncurve[15]-=5;
	movefruit;
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
		color++;
		draw_(fruit,10);
		if(CheckCollisionCircles(snake[0],5,fruit,10)){
			movefruit;
			snake~=snake[$-1];
			snake~=snake[$-1];
			snake~=snake[$-1];
			snake~=snake[$-1];
		}
		watch!rot;
		
		with(button){
			rot+=turncurve[right.down.ramp()];
			rot-=turncurve[left.down.ramp()];
			
		enddrawing;
	}}
	CloseWindow();
}