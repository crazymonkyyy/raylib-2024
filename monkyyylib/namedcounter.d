/*
compile time counter, a simplier version exists in styntaxtestcode/counter.d
requires -mixin=mix as a compiler flag
uses a compiler bug, and is O(n) when you may expect O(c); use with care
I cant trivailly explain it but the main thing is `mixin("__LINE__")` always increases

style guide: leave counter!() for endusers plz
*/

template counter(string s="unnamed"){
	template access(int i){
		enum access=mixin("__LINE__");
	}
	template get_(int i,int sentinel){
		static if(access!(i)>sentinel){
			enum get_=i;
		} else {
			enum get_=get_!(i+1,sentinel);
	}}
	int counter(int i=__LINE__)(){
		enum setty=mixin("__LINE__");
		return get_!(0,setty);
	}
}
/*
void main(){
	import std;
	counter!().writeln;
	counter!"a".writeln;
	counter!"a".writeln;
	counter!().writeln;
	counter!().writeln;
	counter!"a".writeln;
}
*/