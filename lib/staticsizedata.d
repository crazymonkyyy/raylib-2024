/*
static sized data stuctures

TODO:
*/
import staticabstractions;
struct staticarray(T,int N){
	T[N] data;
	size_t length;
	void opOpAssign(string op: "~")(T t){
		data[length++]=t;
	}
	ref opIndex(size_t i){
		return data[i];
	}
	auto opSlice(){
		return data[0..length];
	}
	auto opSlice(size_t a,size_t b){
		return data[a..b];
	}
	size_t opDollar(){
		return length;
	}
	//lots of todo:
}

struct nullablearray(T,int N){
	T[N] data;
	bool[N] nulls=true;
	alias THIS=typeof(this);
	enum N_=N;
	ref opIndex(size_t i){
		return data[i];
	}
	auto opSlice(){
		struct filter{
			THIS* parent;
			size_t index;
			bool empty=false;
			auto front()=> tuple!(size_t,T)(index,(*parent)[index]);
			void popFront(){
				loop:
					index++;
					if(index==N){empty=true; return;}
					if((*parent).nulls[index]){ goto loop;}
			}
		}
		auto o=filter(&this,0);
		if(nulls[0]){o.popFront;}
		return o;
	}
	void opIndexAssign(T value,size_t i){
		data[i]=value;
		nulls[i]=false;
	}
	void opIndexAssign(typeof(null),size_t i){
		nulls[i]=true;
	}
	void opOpAssign(string s:"~")(T v){
		foreach(i,b;nulls){
			if(b){
				this[i]=v;
				return;
			}
		}
	}
}
unittest{
	import std;
	nullablearray!(int,10) foo;
	foo.nulls.writeln;
	foo[0]=3;
	foo[4]=5;
	foo[8]=0;
	foo.nulls.writeln;
	foreach(i,e;foo[]){
		e.writeln;
	}
	"----".writeln;
	foo[4]=null;
	foreach(i,e;foo[]){
		e.writeln;
	}
	foo.nulls.writeln;
	foo~=2;
	foo~=7;
	foo.nulls.writeln;
	foreach(i,e;foo[]){
		e.writeln;
	}
}