module helloworld; //make error go away worthless code
import basic;//using namespace std / import std for this enverment
mixin mainhack!();
ref handleinputfile(int N=1024)(){
	//BAD: wasm made file io impossible thru anything sane, I will do what I can with insane bad ones
	//BAD: only supports one file in and out, this will not change
	static int counter=0; //ive seen several repeated calls in logs, this is to add 5 seconds of delay
	static str!N data;
	if(counter>0){counter--;}
	if(IsFileDropped && counter==0){
		counter=300;
		data.length=0;
		auto temp=LoadDroppedFiles();
		auto file=temp.paths[0];
		auto temp2=LoadFileText(file);
		auto temp3=temp2;
		while(temp2[0]!='\0'){
			data~=(temp2++)[0];
		}
		UnloadFileText(temp3);
		UnloadDroppedFiles(temp);
	}
	return data;
}

void main_(){// hack for making swapping between wasm and native work
	makewindow;
	while (!WindowShouldClose()){
		startdrawing;
		handleinputfile().drawtext(0,0);
		//DrawText(storage,0,0,16,Color(255,255,255,255));
		with(button){
			if(right.pressed){
				savefile(mystr~"hello world");
			}
		}
		enddrawing;
	}
	CloseWindow();
}