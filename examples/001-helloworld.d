module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		"hello world".drawtext(100,200);//TODO: cleanup
		auto foo=str;
		foo~="raylib ";
		foo~=5.0;
		foo~="!!!!!!!";
		foo.drawtext(150,300,30);
		highlight++;text++;
		"yay".drawtext(300,400,60);
		str!120 bar;
		bar~=100000000;
		bar.drawtext(200,200-16);
		highlight++;text++;
		bar.drawtext(200,200);
		highlight++;text++;
		bar.drawtext(200,216);
		resetcolors;
		drawtext(str~1000~','~1337,400,500);
		enddrawing;
	}
	CloseWindow();
}