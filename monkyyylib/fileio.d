//BAD: wasm made file io impossible thru anything sane, I will do what I can with insane bad ones
import basic;
ref handleinputfile(int N=1024)(){
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
void savefile(string prefix="data:application/text,",int N)(str!N data){
	enum words=N/4;
	enum estlength=words*8+prefix.length+10;//spaces are 3 char wide when converted, and 4 char per word in thoery
	char[16] hex="0123456789ABCDEF";
	str!estlength o;
	o~=prefix;
	foreach(c;data[]){
		if(c.isletter){
			o~c;
		} else {
			o~='%';
			o~=hex[(cast(ubyte)c)/16];
			o~=hex[(cast(ubyte)c)%16];
		}
	}
	OpenURL(o.tocharz);
}
