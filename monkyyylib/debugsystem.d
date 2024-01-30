// here be dragons, made of glass; if your an end user you shouldnt be here, ask me if someone wants an explaination for how things work

import monkyyydraw;
import mystring;
import staticabstractions;
import namedcounter;
import monkyyykeys;

struct __debug{}

alias debugtoggle=toggle!(false,__debug);
alias debugctcounter=counter!("debug");
template debugstorage(int i){
	static str!80 debugstorage;
}
void watch(alias A,int line=__LINE__)(string s=""){
	enum count=debugctcounter!line;
	debugstorage!count.delete_;
	if(debugtoggle){
		debugstorage!count~A.stringof~s~':'~A~'('~line~')';
	}
}
template finalizecount(){
	enum finalizecount=debugctcounter!(int.max);
}
void debugwriteln()(){
	import std;
	if( ! debugtoggle){return;}
	static foreach(i;0..finalizecount!()){
		debugstorage!i[].writeln;
}}
void debugdraw()(){
	if( ! debugtoggle){return;}
	static foreach(i;0..finalizecount!()){
		debugstorage!i[].drawtext(0,i*16);
}}
void debugsystemending()(){//made for enddrawing
	if( ! button.f2.pressed.debugtoggle){
		return;
	}
	debugdraw;
}