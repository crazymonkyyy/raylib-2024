import basic;//using namespace std / import std for this enverment
mixin mainhack!();
int toglyph(int i){
	switch(i){
		case 0:return 11;
		case 12:return 12;
		default: return i%12-1;
}}
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	auto glyphs=LoadTexture("random/char.png");
	while (!WindowShouldClose()){
		startdrawing;
		import std.datetime;//I want to punch jmd for this bullshit; its so poorly written 
		static if(false){
			int min=Clock.currTime.minute;
			int hour=Clock.currTime.hour;
		} else {
			int min=Clock.currTime.second;
			int hour=(Clock.currTime.hour*60+Clock.currTime.minute)%24;
		}
		watch!min;
		watch!hour;
		DrawTexturePro(glyphs,Rectangle(hour.toglyph*48,0,48,72),Rectangle(0,0,48,72),Vector2(0,0),0,text);
		DrawTexturePro(glyphs,Rectangle(13*48,0,48,72),Rectangle(48,0,48,72),Vector2(0,0),0,text);
		DrawRectangle(61,8+(60-min),3,min,text);
		enddrawing;
	}
	CloseWindow();
}