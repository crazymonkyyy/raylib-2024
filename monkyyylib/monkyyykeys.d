import raylib;
struct button_{
	int which;
	bool ismouse=false;
	button_ opBinary(string s:"+")(int i){
		assert(i==1);
		assert(__ctfe);
		return button_(which+1,ismouse);
	}
	enum max=button_(int.max);
	bool pressed(){
		if(ismouse){return IsMouseButtonPressed(which);}
		return IsKeyPressed(which);
	}
	bool down(){
		if(ismouse){return IsMouseButtonDown(which);}
		return IsKeyDown(which);
	}
	bool opCast(T:bool)(){ return down;}
	buttoncord opBinary(string s:"+")(button_ b){
		return buttoncord([this,b],[]);}
	buttoncord opBinary(string s:"-")(button_ b){
		return buttoncord([this],[b]);}
	bool toggle(bool b=false,int i=__LINE__)(){
		import staticabstractions;
		return pressed.toggle!(b,void,i);
	}
}
struct buttoncord{
	button_[] me;
	button_[] notme;
	buttoncord opBinary(string s:"+")(button_ b){
		me~=b; return this;
	}
	buttoncord opBinary(string s:"-")(button_ b){
		notme~=b; return this;
	}
	bool opCast(T:bool)(){
		foreach(a;notme){
			if(a.down){return false;}}
		foreach(a;me[0..$-1]){
			if(!a.down){return false;}}
		return me[$-1].pressed;
	}
}
/*
import std.stdio;
void main(){
	char c='b';
	foreach(i;0..25){
		write(c); write(",");
		c++;
	}
}
*/


enum button{
	a=button_(KeyboardKey.KEY_A),
	b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,
	_0=button_(KeyboardKey.KEY_ZERO),
	_1,_2,_3,_4,_5,_6,_7,_8,_9,
	f1=button_(KeyboardKey.KEY_F1),
	f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,
	mouse1=button_(0,true),
	mouse2,mouse3,mouse4,mouse5,mouse6,
	shift=button_(KeyboardKey.KEY_LEFT_SHIFT),
	ctrl,alt,super_,Rshift,Rctrl,Ralt,Rsuper,menu,
	right=button_(KeyboardKey.KEY_RIGHT),
	left,down_,up,//TODO: fix down wierd behavoir... or something
	tab=button_(KeyboardKey.KEY_TAB),
	backspace,insert,delete_,
}
//todo: all keys, but not by me