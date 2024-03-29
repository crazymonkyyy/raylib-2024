//string type for surviving without gc and passing c strings to raylib draw functions

//should be temporary, probaly wont be
bool bigint(int i){
	return i>10_000_000;
}
import raylib;
str!(80) mystr(){return str!(80)();}
struct str(int N=80){
	char[N+1] data;
	size_t length=0;
	size_t dirty=N;
	void clean(){
		if(dirty!=N){
			//char t=data[dirty];
			//data[dirty]=data[N];
			//data[N]=t;
			data[dirty]=data[N];
			data[N]=0;
			dirty=N;
		}
	}
	void opOpAssign(string op: "~",T:char)(T c){
		clean();
		if(length<N){
			data[length++]=c;
		} else {
			data[N-1]^=c;
	}}
	void opOpAssign(string op: "~",T:string)(T s){
		foreach(c;s){
			this~=c;
	}}
	void opOpAssign(string op: "~",T)(T t){
		version(D_BetterC) static assert(0,"called an arbitery to!string, this always ends in random std errors missing something");
		import std.conv:to;
		this~=t.to!string;
	}
	void opOpAssign(string op: "~")(Vector2 v){
		this~v.x~','~v.y;
	}
	char todigit(int i){
		return '0'+i%10;
	}
	//TODO: test, test, test
	void opOpAssign(string op: "~",T:int)(T i){
		if(i<0){
			this~='-';
			i=-i;
		}
		if(i.bigint){
			//TODO: science notation
			this~="bigidk";
			return;
		}
		bool sig=false;
		for(int j=1_000_000;j!=0;j/=10){
			char c=todigit(i/j);
			if(c!='0'){sig=true;}
			if(sig||j==1){this~=c;}
		}
	}
	void opOpAssign(string op: "~",T:float)(T f){
		if(f != f) {this~="nan";return;}
		else if(f == -float.infinity) {this~="-inf"; return;}
		else if(f == float.infinity) {this~="inf"; return;}
		auto l=length;
		this~=cast(int)f;
		this~='.';
		if(length-l>8){return;}
		f-=cast(int)f;
		while(length-l>8){
			f*=10;
			this~=todigit(cast(int)f);
		}//TODO doesnt seem to print any lower digits
	}
	void opOpAssign(string op: "~",T:double)(T f){
		this~=cast(float)f;
	}
	void opAssign(T)(T t){
		length=0;
		this~=t;
	}
	ref opBinary(string op: "~",T)(T t){
		if(length<=N){
			this~=t;
		}
		return this;
	}
	string opSlice(size_t a,size_t b){
		clean();
		if(length==0){return "";}
		if(b>length){b=length;}
		if(a>b){return "";}
		data[N]=data[b];
		data[b]=0;
		dirty=b;
		return cast(string)data[a..b];
	}
	string opSlice(T,S)(T a,S b){
		if(a<0){a=0;}
		if(b<0){b+=length;}
		return this.opSlice(cast(size_t)a,cast(size_t)b);
	}
	string opSlice()=>opSlice(0,length);
	string tostringz(T=size_t,S=size_t)(T t=0,S s=N){
		return opSlice(t,s);
	}
	char* tocharz(){
		return cast(char*)(&(tostringz()[0]));
	}
	ref char opIndex(int i){
		return data[i];
	}
	alias tostringz this;
	
	void delete_(){
		length=0;
	}
	void type(){
		import monkyyykeys;
		static timer=0;
		if(button.backspace){
			if(timer==0 ||(timer>30 && timer%3==0)){//factor out into a generic function? 
				if(length>0)length--;
			}//TODO: "I measured it in SDL now, seems it's ~40 frames until the second tick and then 2.5 frames" -tg
			timer++;
		} else {
			timer=0;
		}
		if(button.Rshift+button.backspace){//TODO: consider metakeys as pairs?
			length=0;//TODO: if not write it for both
		}
		loop:
		int t=GetCharPressed();
		if(t!=0){
			this~=cast(char)t;
			goto loop;
		}
	}
}
bool isletter(char c){
	return
	(c>='A' && c<='Z') ||
	(c>='a' && c<='z');
}