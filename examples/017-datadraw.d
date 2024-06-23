module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
alias lookuptable=ubyte[256];

void fill(ref lookuptable i){
	foreach(ubyte j;0..256){
		i[j]=j;
	}
}
//float remap(float input,ref lookuptable where,float minin,float maxin,float minout,float maxout){
//	return input;
//}

void editable(Key)(ref lookuptable t,Key k){
	import tempmath;
	import myalgorithms;
	static int lastx;
	static int lasty;
	int mousex=GetMouseX/2;
	int mousey=255-(GetMouseY/2);
	if(k.down){ //graph drawing
		switch( (button.mouse1.down && mousex>=0 &&mousex<256 && mousey>=0 &&mousey<256).ramp){
			case 0: break;//not clicked
			default: //drag
				//writeln("last:",lastx,",",lasty,";cur:",mousex,",",mousey);
				foreach(x;counter(extermes(mousex,lastx).types).tophoboes){
					alias pair=tuple!(int,int);
					auto temp= mousex>lastx? pair(lasty,mousey):pair(mousey,lasty);
					t[x]=cast(ubyte)(x.remap(extermes(mousex,lastx).types,temp.types));
					//writeln("	x:",x,",",data[x]);
				}
				goto case 1;
			case 1://clicked
				t[mousex]=cast(ubyte)mousey; 
		}
		lastx=mousex;
		lasty=mousey;
		foreach(int x_,i;t){
			int x=x_*2;
			int y=(255-i)*2;
			draw_(x+0,y+0);
			draw_(x+0,y+1);
			draw_(x+1,y+0);
			draw_(x+1,y+1);
		}
	}
}
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	lookuptable xs;
	lookuptable ys;
	lookuptable rs;
	lookuptable gs;
	lookuptable bs;
	xs.fill;
	ys.fill;
	while (!WindowShouldClose()){
		startdrawing;
		static int i;
		i++;
		i%=256;
		DrawCircle(xs[i],ys[i],5.0,Color(rs[i],gs[i],bs[i]));
		with(button){
		if((shift+z).released){
			status("released");
		}
		xs.editable(x);
		ys.editable(shift+y);
		rs.editable(r);
		gs.editable(g);
		bs.editable(b);
		
		enddrawing;
	}}
	CloseWindow();
}
