module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
void main_(){// hack for making swapping between wasm and native work
	makewindow;
	string empty="drop a file";
	char* storage=cast(char*)(&empty[0]);
	char* file;
	typeof(LoadDroppedFiles()) temp;
	typeof(LoadFileText(file)) temp2;
	bool started=false;
	while (!WindowShouldClose()){
		startdrawing;
		if(IsFileDropped && !started){
			started=true;
			temp=LoadDroppedFiles();
			file=temp.paths[0];
			temp2=LoadFileText(file);
			storage=temp2;
		}
		DrawText(storage,0,0,16,Color(255,255,255,255));
		with(button){
			if(space.pressed){
				SaveFileText(file,cast(char*)(&("foobar"[0])));
				UnloadFileText(temp2);
				UnloadDroppedFiles(temp);
			}
		enddrawing;
	}}
	CloseWindow();
}