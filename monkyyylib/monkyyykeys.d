// `with(button){if(ctrl+c)` magic syntax for buttons

import raylib;
version(D_BetterC){
	import staticsizedata;
	alias __array__=staticarray!(button_,5);
}else{
	alias __array__=button_[];
}

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
	bool released(){
		if(ismouse){return IsMouseButtonReleased(which);}
		return IsKeyReleased(which);
	}
	bool down(){
		if(ismouse){return IsMouseButtonDown(which);}
		return IsKeyDown(which);
	}
	bool opCast(T:bool)(){ return down;}
	buttoncord opBinary(string s:"+")(button_ b){
		buttoncord o;
		o.me~=this;
		o.me~=b;
		return o;
	}
	buttoncord opBinary(string s:"-")(button_ b){
		buttoncord o;
		o.me~=this;
		o.notme~=b;
		return o;
	}
	bool toggle(bool b=false,int i=__LINE__)(){
		import staticabstractions;
		return pressed.toggle!(b,void,i);
	}
	ubyte ramp(int i=__LINE__)(){//TODO rename i's in templates for clarity 
		static ubyte i;
		if(down){
			if(i!=255){i++;}
		} else {
			i=0;
		}
		return i;
	}
	ubyte decay(int i=__LINE__)(ubyte increase, ubyte decrease){
		static ubyte i;
		if(down){
			if(i+increase>255){i=255;}
			else{i+=increase;}
		} else {
			if(i-decrease<0){i=0;}
			else{i-=decrease;}
		}
		return i;
	}
	ubyte tapable(int i=__LINE__)(ubyte tap,ubyte increase, ubyte decrease){
		static ubyte i;
		if(pressed){
			if(i+increase>255){i=255;}
			else{i+=increase;}
			return i;
		}
		if(down){
			if(i+increase>255){i=255;}
			else{i+=increase;}
		} else {
			if(i-decrease<0){i=0;}
			else{i-=decrease;}
		}
		return i;
	}
}
struct buttoncord{
	__array__ me;
	__array__ notme;
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
	bool released(){
		foreach(a;notme){
			if(a.down){return false;}}
		foreach(a;me[0..$-1]){
			if(!a.down){return false;}}
		return me[$-1].released;
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
	space=button_(KeyboardKey.KEY_SPACE),
}
//todo: all keys, but not by me
