//should be temporary, probaly wont be
bool bigint(int i){
	return i>10_000_000;
}
import raylib;
str!(80) str(){return str!(80)();}
struct str(int N){
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
		}
	}
	void opOpAssign(string op: "~",T:double)(T f){
		this~=cast(float)f;
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
	ref char opIndex(int i){
		return data[i];
	}
	alias tostringz this;
	
	void delete_(){
		length=0;
	}
}