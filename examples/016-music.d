module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
import musicplayer;
string[] songlist=[
"assets/aura-cosmic-lofi-aesthetic-music-179919.mp3",
"assets/do-this-vibe-174660.mp3",
"assets/IceCream.mp3",
"assets/melt-180414.mp3",
"assets/moonlight-186699.mp3",
];

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	playlist=songlist;
	auto buttons=LoadTexture("assets/tempbuttons.png");
	while (!WindowShouldClose()){
		startdrawing;
		playlist.draw(100,100,buttons);
		enddrawing;
	}
	CloseWindow();
}