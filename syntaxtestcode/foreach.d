import std;
alias aliasseq(T...)=T;
struct tuple(T...){
	T types;
	alias types this;
}
struct foreachable{
	int i;
	float f=0;
	auto front(){
		//tuple!(int,float) o;
		//o[0]=i;
		//o[1]=f;
		return tuple!(int,float)(i,f);
	}
	void popFront(){
		i+=1;
		f+=.3;
	}
	bool empty()=>i==10;
}
unittest{
	foreach(i,f;foreachable()){
		import std;
		writeln(i,',',f);
	}
}