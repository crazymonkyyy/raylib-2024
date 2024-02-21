import raylib;
import myalgorithms;
int rng(T)(int max,auto ref T seed) {
	const uint mod = 0x7FFFFFFF; // 2^31 - 1
	const uint mul = 0x41C64E6D; // 16,807
	seed = (seed * mul) % mod;
	return cast(int)(seed % max);
}
void swap(T)(ref T a, ref T b){
	T t=a;
	a=b;
	b=t;
}
T min(T,S)(T a,S b){
	if(a<b){
		return a;
	}
	return cast(T)b;
}
ref T[] partshuffle(T)(ref T[] array,float part,ulong seed){
	bool[] store;//todo change to ringarray
	store.length=array.length;
	foreach(i;0..array.length){
		auto j=rng(min(cast(int)(array.length*part),array.length-i),seed);
		if(store[i]){continue;}
		swap(array[i],array[i..$][j%$]);
		store[min(i+j,$-1)]=true;
	}
	return array;
}
ref T[] inverseshuffle(alias F,T)(ref T[] array,float part/*opps*/,ulong seed){
	auto indexes=counter(array.length).array;
	F(indexes,part,seed);
	bool finished=false;
	while( ! finished){
		finished=true;
		foreach(i;0..array.length){
			if(indexes[i]!=i){
				finished=false;
				swap(array[indexes[i]],array[i]);
				swap(indexes[indexes[i]],indexes[i]);
			}
		}
	}
	return array;
}
struct playlist_{
	import basic;
	string[] songs;
	int seed;
	int index;
	int message;
	Music m;
	str!80 name;
	void next(){
		if(++index>=songs.length){
			songs.partshuffle(.3,seed++);
			index=0;
		}
		UnloadMusicStream(m);
		m=LoadMusicStream(&(songs[index][0]));
		PlayMusicStream(m);
		message=0;
		name=songs[index].elementslice!".byascii"('/','.');
	}
	void prev(){
		if(GetMusicTimePlayed(m)>5){
			SeekMusicStream(m,0);
			return;
		}
		if(--index<0){
			inverseshuffle!partshuffle(songs,.3,seed);
			index=cast(int)songs.length-1;
		}
		UnloadMusicStream(m);
		m=LoadMusicStream(&(songs[index][0]));
		if( ! IsMusicReady(m)){
			status("panic");
		} else{ PlayMusicStream(m);}
		message=0;
		name=songs[index].elementslice!".byascii"('/','.');
	}
	void pause(){
		
	}
	void opAssign(string[] s){
		songs=s;
		//InitAudioDevice;
		m=LoadMusicStream(&(songs[index][0]));
		if( ! IsAudioDeviceReady){
			status("VERY PANIC");
		} else {
		if( ! IsMusicReady(m)){
			status("panic");
		} else { 
			PlayMusicStream(m);
		}}
	}
	void update(){
		UpdateMusicStream(m);
	}
	void volume(int i){
		SetMusicVolume(m,i/100.0);
	}
	void draw(int x,int y,Texture2D image){
		update;
		DrawTexture(image,x,y,text);
		if(message++<180){
			name.drawtext(x,y-16);
		}
		if(CheckCollisionPointRec(GetMousePosition,Rectangle(x,y,image.width,image.height))){
			if(button.mouse1.pressed){
				final switch((GetMouseX-x)/(image.width/3)){
					case 0: prev; return;
					case 1: pause; return;
					case 2: next; return;
	}}}}
}
playlist_ playlist;