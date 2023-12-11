struct mystring(int N){
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
}
void assertcstring(string s){
	assert((cast(char*)&s)[s.length]==0,s~" is not a c string");
}
unittest{
	assertcstring("hi");
	//import std;
	//assertcstring("hi"~1.to!string);
}
unittest{
	mystring!5 foo;
	foo~='a';
	import std;
	foo.data.writeln;
	foo~="bcde";
	foo.data.writeln;
	foo~='z';
	foo.data.writeln;
}
unittest{
	import std;
	"----".writeln;
	mystring!5 foo;
	foo~=1;
	foo.data.writeln;
	foo~=20;
	foo.data.writeln;
	foo~=1.337;
	foo.data.writeln;
}
unittest{
	import std;
	"----".writeln;
	mystring!10 foo;
	foo~=[1,1];
	foo.data.writeln;
	foo~=20;
	foo.data.writeln;
	foo~=1.337;
	foo.data.writeln;
}
unittest{
	mystring!100 foo;
	foo~="hello im tired";
	foo~="hi tired im dad";
	assertcstring(foo[3..10]);
	assertcstring(foo[30..1000]);
	assertcstring(foo[2..4]);
	import std;
	foo[2..4].writeln;
	foo[].writeln;
}