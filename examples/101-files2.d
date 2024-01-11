module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	bool started=false;
	auto temp1=GetWorkingDirectory;
	auto temp2=LoadDirectoryFiles(temp1);
	int selected;
	void load(){
		temp2=LoadDirectoryFiles(temp2.paths[selected]);
		selected=0;
	}
	while (!WindowShouldClose()){
		startdrawing;
		foreach(i;0..temp2.count){
			DrawText(temp2.paths[i],5,i*20,16,Color(255,255,255,255));
		}
		draw_(3,selected*20+10,2.0);
		with(button){
			if(down_.pressed){
				selected++;
			}
			if(up.pressed){
				selected--;
			}
			if(left.pressed){
				temp2=LoadDirectoryFiles("/");
			}
			if(space.pressed){
				load;
			}
			if(s.pressed){
				SaveFileText(cast(char*)&"//home/web_user/RAYLIB"[0],cast(char*)&"PRINTING FROM WASM1"[0]);
				SaveFileText(cast(char*)&"//dev/stdout"[0],cast(char*)&"PRINTING FROM WASM2"[0]);
				SaveFileText(cast(char*)&"//proc/self/fd/RAYLIB"[0],cast(char*)&"PRINTING FROM WASM3"[0]);
				SaveFileText(cast(char*)&"//proc/self/fd"[0],cast(char*)&"PRINTING FROM WASM4"[0]);
				SaveFileText(cast(char*)&"//tmp/RAYLIB"[0],cast(char*)&"PRINTING FROM WASM5"[0]);
				SaveFileText(cast(char*)&"RAYLIB"[0],cast(char*)&"PRINTING FROM WASM6"[0]);
				SaveFileText(cast(char*)&"//RAYLIB"[0],cast(char*)&"PRINTING FROM WASM7"[0]);
				SaveFileText(cast(char*)&"//assets/RAYLIB"[0],cast(char*)&"PRINTING FROM WASM8"[0]);
			}
		}
		enddrawing;
	}
	CloseWindow();
}