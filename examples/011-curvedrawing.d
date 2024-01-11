module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
import tempmath;
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	//string s="hi";
	//char* c_=cast(char*)&s[0];
	while (!WindowShouldClose()){
		startdrawing;
		[1,2,1337].tostringblob!(int,3).drawtext(0,0);
		//0x01000000,0x02000000,0x39050000,
		//DrawText(c_,0,0,16,Color(255,255,255,255));// I HATE HATE HATE HATE W3C SAFTISM AND ALL THIS FUCKING BULLSHIT; WHY DO YOU BREAK BOTH FILE IO AND CLIPBOARDS HOW AM I EVER SUPPOSE TO MAKE A USEFUL APP
		with(button){
			if(ctrl+v){
				//c_=cast(char*)GetClipboardText;
			}
		enddrawing;
	}}
	CloseWindow();
}