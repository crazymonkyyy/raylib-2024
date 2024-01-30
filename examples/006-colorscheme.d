module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		"press f9 to change color scheme".drawtext(50,50,20);
		foreach(i;0..8){
			draw_(50,100+50*i,23);
			color++;
		}
		foreach(i;0..8){
			DrawRectangle(150,100+50*i,200,40,background);
			DrawRectangleLinesEx(Rectangle(150,100+50*i,200,40),i,highlight++);
			
			(mystr~i~" : is being drawn").drawtext(160,110+50*i,16,text++,background++);
		}
		enddrawing;
	}
	CloseWindow();
}