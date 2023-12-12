//should be temporary, probaly wont be
struct mystring(int N=80){
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
		import std.conv;
		this~=t.to!string;
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
	char* tostringz(T=size_t,S=size_t)(T t=0,S s=length){
		return &opSlice(t,s);
	}
	alias tostringz this;
}