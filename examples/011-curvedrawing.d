module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
import tempmath;
import myalgorithms;
mixin mainhack!();
enum string[] colornames=(){
		import std;
	return [
		"white","red","organge","yellow","green",
		"cyan","blue","purple","pink"]
		.map!(a=>"active color:"~a)
		.array;
	}();
enum string[] inputnames=(){
		import std;
	return [
		"simple cycle","slow cycle",
		"mouse follow",
		].map!(a=>"input mode: "~a)
		.array;
	}();
alias inputmethods=aliasseq!(
	(){static int i;i=warp(++i,0,255);return i;},
	(){static int i;i=warp(++i,0,255*2);return i/2;},
	(){return clamp(GetMouseX/2,0,255);},
);
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	ubyte[256][9] data;
	while (!WindowShouldClose()){
		startdrawing;
		static int activegraph=0;
		static int activecell=0;
		static int inputmethod=0;
		lable:switch(inputmethod){
			static foreach(i,F;inputmethods){
				case i:activecell=F(); break lable;
			}
			default: assert(0);
		}
		
		drawH(0,0,512,512);
		foreach(color_,list;data){
			allcolors[color_+7];
			drawA(0,520+cast(int)color_*12,list[activecell]*2,11);
		foreach(int x_,i;list){
			int x=x_*2;
			int y=(255-i)*2;
			drawA(x+0,y+0);
			drawA(x+0,y+1);
			drawA(x+1,y+0);
			drawA(x+1,y+1);
		}}
		DrawCircle(512+30,512+30,25,//rainbow circle
			Color(data[1][activecell],data[4][activecell],data[6][activecell]));
		allcolors[activegraph+7];
		DrawLine(activecell*2,512,activecell*2,520,allcolors);
		colornames[activegraph].drawtext(516,4,16,allcolors);
		inputnames[inputmethod].drawtext(516,24,16,allcolors);
		
		with(button){
		if(mouse3.pressed){
			activegraph=warp(activegraph+1,0,8);
		}
		if(tab.pressed){
			inputmethod=warp(inputmethod+1,0,cast(int)inputmethods.length);
		}
		{ //graph drawing
			static int lastx;
			static int lasty;
			int mousex=GetMouseX/2;
			int mousey=255-(GetMouseY/2);
		switch( (mouse1.down && mousex>=0 &&mousex<256 && mousey>=0 &&mousey<256).ramp){
			case 0: break;//not clicked
			default: //drag
				//writeln("last:",lastx,",",lasty,";cur:",mousex,",",mousey);
				foreach(x;counter(extermes(mousex,lastx).types).tophoboes){
					alias pair=tuple!(int,int);
					auto temp= mousex>lastx? pair(lasty,mousey):pair(mousey,lasty);
					data[activegraph][x]=cast(ubyte)(x.remap(extermes(mousex,lastx).types,temp.types));
					//writeln("	x:",x,",",data[x]);
				}
				goto case 1;
			case 1://clicked
				data[activegraph][mousex]=cast(ubyte)mousey; 
		}
			lastx=mousex;
			lasty=mousey;
		}
		enddrawing;
	}}
	CloseWindow();
}