module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
import tempmath;
import myalgorithms;
mixin mainhack!();

staticarray!(Vector2,1000) snake;
float rot=45;
int speedindex;
float speed()=>speedcurve[speedindex%$];

auto impluse()=>Vector2(cos(rot)*speed,sin(rot)*speed);
Vector2[7] fruit;
float[256] turncurve;
float[256] speedcurve;

void movefruit(int i){
	fruit[i].x=GetRandomValue(100,700);
	fruit[i].y=GetRandomValue(100,540);
}

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	//turncurve=[
	//0x007E7E7D7D7D7D7D,0x7D7D7D7C7C7C7C7C,0x7C7C7B7B7B7B7B7B,0x7B7B7B7B7B7B7877,0x6F6C64605C525048,0x44403D3935302C28,0x26231F1C1A181613,0x12111110100F0F0F,
	//0x0F0F0F0F0F0E0E0E,0x0E0E0E0E0E0E0E0F,0x0F0F0F0F0F101010,0x1111111111121314,0x1415161718191A1C,0x1D1E20222426282A,0x2B2D2F313336383B,0x3E404346494C4F51,
	//0x5356585A5C5F6265,0x686A6C6E7174777B,0x7D7F818385878B8D,0x909396999C9D9FA1,0xA2A4A5A7A9ABADAF,0xB1B4B5B6B8B8B9BA,0xBBBCBEBEBFC0C1C3,0xC4C5C6C7C8C9CBCB,
	//0xCCCCCDCDCECFD0D0,0xD1D1D2D3D4D4D5D6,0xD6D7D8D8D9DADADB,0xDCDDDFDFE0E1E2E2,0xE3E4E4E5E6E7E7E8,0xE9E9EAEBEBECEDEE,0xEFEFEFF0F0F0F000,0x0000000000000000,
	//].binaryblob.toiter.map!(a=>a/float(25)).array;
	//turncurve.writeln;
	//speedcurve=[
	//0x7F7F7C7A79767470,0x6E6C6A696762615F,0x5F5F5F5F5F5F5F5F,0x5F5F5F5F5F5F5D57,0x504A4644413E3D3B,0x3838383838383838,0x3838383838383838,0x3532302D2B292827,
	//0x2421202020202121,0x2121212121212121,0x2120202020201F21,0x1F1F21232527282A,0x2B2C2E3031343434,0x3535353535353636,0x3637373737373737,0x373737373737373A,
	//0x3B3F43464A4E5153,0x5557595C5D5E5E5F,0x5F5F5F5F5F5F5F5F,0x5F5F5F5F5F5F5F5F,0x5F5F5F5F5F5F696E,0x73777B7F82868989,0x898989898A8A8A8A,0x8A8A8A8A8A8A8A8A,
	//0x8A8A8A8B939CA3A8,0xABAFB0B1B1B1B1B1,0xB1B1B1B1B1B1B1B1,0xB1B1B1B1B1B1B1B1,0xB2B2B4B8BDC4C9CE,0xCECECECECECDCDCD,0xCFD1D2D4D5D9DBDD,0xE0E2E4E7E7EBECEC,
	//].binaryblob.toiter.map!(a=>a/float(25)).array;
	//speedcurve.writeln;
	turncurve=[5, 5, 5, 5, 5, 5.04, 5.04, 0, 4.96, 4.96, 4.96, 4.96, 4.96, 5, 5, 5, 4.92, 4.92, 4.92, 4.92, 4.92, 4.92, 4.96, 4.96, 4.76, 4.8, 4.92, 4.92, 4.92, 4.92, 4.92, 4.92, 2.88, 3.2, 3.28, 3.68, 3.84, 4, 4.32, 4.44, 1.6, 1.76, 1.92, 2.12, 2.28, 2.44, 2.56, 2.72, 0.76, 0.88, 0.96, 1.04, 1.12, 1.24, 1.4, 1.52, 0.6, 0.6, 0.6, 0.64, 0.64, 0.68, 0.68, 0.72, 0.56, 0.56, 0.56, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.56, 0.56, 0.56, 0.56, 0.56, 0.56, 0.56, 0.64, 0.64, 0.64, 0.6, 0.6, 0.6, 0.6, 0.6, 0.8, 0.76, 0.72, 0.68, 0.68, 0.68, 0.68, 0.68, 1.12, 1.04, 1, 0.96, 0.92, 0.88, 0.84, 0.8, 1.68, 1.6, 1.52, 1.44, 1.36, 1.28, 1.2, 1.16, 2.36, 2.24, 2.16, 2.04, 1.96, 1.88, 1.8, 1.72, 3.24, 3.16, 3.04, 2.92, 2.8, 2.68, 2.56, 2.48, 4.04, 3.92, 3.8, 3.68, 3.6, 3.52, 3.44, 3.32, 4.92, 4.76, 4.64, 4.52, 4.4, 4.32, 4.24, 4.16, 5.64, 5.56, 5.4, 5.32, 5.24, 5.16, 5.08, 5, 6.44, 6.36, 6.28, 6.24, 6.12, 6, 5.88, 5.76, 7, 6.92, 6.84, 6.76, 6.68, 6.6, 6.56, 6.48, 7.44, 7.4, 7.36, 7.36, 7.28, 7.24, 7.2, 7.08, 7.8, 7.72, 7.68, 7.64, 7.6, 7.6, 7.52, 7.48, 8.12, 8.12, 8.04, 8, 7.96, 7.92, 7.88, 7.84, 8.32, 8.32, 8.28, 8.24, 8.2, 8.2, 8.16, 8.16, 8.56, 8.52, 8.48, 8.48, 8.44, 8.4, 8.36, 8.36, 8.76, 8.72, 8.72, 8.68, 8.64, 8.64, 8.6, 8.56, 9.04, 9.04, 9, 8.96, 8.92, 8.92, 8.84, 8.8, 9.28, 9.24, 9.24, 9.2, 9.16, 9.12, 9.12, 9.08, 9.52, 9.48, 9.44, 9.4, 9.4, 9.36, 9.32, 9.32, 0, 9.6, 9.6, 9.6, 9.6, 9.56, 9.56, 9.56, 0, 0, 0, 0, 0, 0, 0, 0]
;//wasm cant run the code above
	speedcurve=[4.48, 4.64, 4.72, 4.84, 4.88, 4.96, 5.08, 5.08, 3.8, 3.88, 3.92, 4.12, 4.2, 4.24, 4.32, 4.4, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.48, 3.72, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 2.36, 2.44, 2.48, 2.6, 2.72, 2.8, 2.96, 3.2, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 2.24, 1.56, 1.6, 1.64, 1.72, 1.8, 1.92, 2, 2.12, 1.32, 1.32, 1.28, 1.28, 1.28, 1.28, 1.32, 1.44, 1.32, 1.32, 1.32, 1.32, 1.32, 1.32, 1.32, 1.32, 1.32, 1.24, 1.28, 1.28, 1.28, 1.28, 1.28, 1.32, 1.68, 1.6, 1.56, 1.48, 1.4, 1.32, 1.24, 1.24, 2.08, 2.08, 2.08, 1.96, 1.92, 1.84, 1.76, 1.72, 2.16, 2.16, 2.12, 2.12, 2.12, 2.12, 2.12, 2.12, 2.2, 2.2, 2.2, 2.2, 2.2, 2.2, 2.2, 2.16, 2.32, 2.2, 2.2, 2.2, 2.2, 2.2, 2.2, 2.2, 3.32, 3.24, 3.12, 2.96, 2.8, 2.68, 2.52, 2.36, 3.8, 3.76, 3.76, 3.72, 3.68, 3.56, 3.48, 3.4, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 4.4, 4.2, 3.8, 3.8, 3.8, 3.8, 3.8, 3.8, 5.48, 5.48, 5.36, 5.2, 5.08, 4.92, 4.76, 4.6, 5.52, 5.52, 5.52, 5.52, 5.48, 5.48, 5.48, 5.48, 5.52, 5.52, 5.52, 5.52, 5.52, 5.52, 5.52, 5.52, 6.72, 6.52, 6.24, 5.88, 5.56, 5.52, 5.52, 5.52, 7.08, 7.08, 7.08, 7.08, 7.08, 7.04, 7, 6.84, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 7.08, 8.24, 8.04, 7.84, 7.56, 7.36, 7.2, 7.12, 7.12, 8.2, 8.2, 8.2, 8.24, 8.24, 8.24, 8.24, 8.24, 8.84, 8.76, 8.68, 8.52, 8.48, 8.4, 8.36, 8.28, 9.44, 9.44, 9.4, 9.24, 9.24, 9.12, 9.04, 8.96]
;
	turncurve[0]=0;
	turncurve[1]+=20;
	turncurve[4]-=5;
	turncurve[9]-=5;
	turncurve[15]-=5;
	void reset(){
		foreach(int i,e;fruit){
			movefruit(i);
		}
		snake.length=0;
		snake~=Vector2(310,310);
		snake~=Vector2(300,300);
		snake~=Vector2(300,300);
		snake~=Vector2(300,300);
		snake~=Vector2(300,300);
		snake~=Vector2(300,300);
		speedindex=0;
		rot=45;
	}
	reset;
	auto happy=LoadSound("assets/happy.wav");
	while (!WindowShouldClose()){
		startdrawing;
		static bool ded;
		watch!ded;
		watch!speed;
		watch!speedindex;
		foreach(i,e;snake[]){
			if(i==0){
				if(!ded){
					snake[i].x=e.x+impluse.x;
					snake[i].y=e.y+impluse.y;
				}
			} else {
				if(CheckCollisionCircles(e,4,snake[0],4)){
					ded=true;
				}
				snake[i].x=snake[i-1].x*.1+e.x*.9;
				snake[i].y=snake[i-1].y*.1+e.y*.9;
				foreach(ref f;fruit){
					if(CheckCollisionCircles(e,5,f,13)){
						auto x=e.x-f.x;
						auto y=e.y-f.y;
						snake[i].x+=x*.1;
						snake[i].y+=y*.1;
						f.x-=x*.1;
						f.y-=y*.1;
					}
				}
			}
			draw_(e,5);
		}
		if( ! CheckCollisionCircleRec(snake[0],10,Rectangle(0,0,800, 640))){
			ded=true;
		}
		foreach(int i,e;fruit){
			color++;
			draw_(e,10);
			if(CheckCollisionCircles(snake[0],5,e,15)){
				movefruit(i);
				snake~=snake[$-1];
				snake~=snake[$-1];
				snake~=snake[$-1];
				snake~=snake[$-1];
				PlaySound(happy);
				speedindex++;
			}
		}
		watch!rot;
		
		if(ded){
			"GAME OVER".drawtext(220,300,64);
			(str!80()~"score: "~speedindex).drawtext(350,380,20);
			"press r to reset".drawtext(350,400);
		}
		
		with(button){
			//float rotmod=.5;
			//rotmod+=speed>2.4;
			//rotmod+=speed>3.2;
			//rotmod+=speed>4;
			rot+=turncurve[right.down.ramp()];//*rotmod;
			rot-=turncurve[left.down.ramp()];//*rotmod;
			if(ded&r.pressed){
				reset;
				ded=false;
			}
		enddrawing;
	}}
	CloseWindow();
}