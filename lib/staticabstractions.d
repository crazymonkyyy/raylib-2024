template toggle(bool defualt=false,alias discriminator=void, int i=__LINE__){
	static bool __toggle=defualt;
	bool toggle(bool input){
		if(input){
			__toggle= ! __toggle;
		}
		return __toggle;
	}
	bool toggle(){
		return __toggle;
	}
}
ubyte ramp(int i=__LINE__)(bool b){//TODO rename i's in templates for clarity 
	static ubyte i;
	if(b){
		if(i!=255){i++;}
	} else {
		i=0;
	}
	return i;
}
//import std;
//void main(){
//	foreach(i;0..15){
//		(i%5==0).toggle.writeln;
//}}
//void main(){
//	foreach(i;0..15){
//		(i%5==0).toggle!true.writeln;
//}}
//void main(){
//	foreach(i;0..15){
//		((i%3==0).toggle +
//		(i%5==0).toggle
//		).writeln;
//}}
//void main(){//todo check this is eqlient to ... what I think it does without templates
//	foreach(j;0..100){
//		int o=0;
//		static foreach(i,e;[3,5,7,9]){
//			o+=(j%e==0).toggle!(false,i);
//		}
//		o.writeln;
//	}
//}
struct stickyindex(alias A,int low=0,size_t high=A.length){
	int index=0;
	ref opIndex(int i){
		index=i%(high-low);
		return A[low..high][index];
	}
	ref opIndex(ulong i)=> this[cast(int)i];
	ref __get__(){
		return A[low..high][index];
	}
	alias __get__ this;
	ref opUnary(string s:"++")(){
		if(++index==(high-low)){
			index=0;
		}
		return __get__;
	}
	ref opUnary(string s:"--")(){
		if(--index==-1){
			index=(high-low);
		}
		return __get__;
	}
	void reset(){
		index=0;
	}
}
//void main(){
//	int[5] foo_;
//	stickyindex!foo_ foo;
//	stickyindex!(foo_,2) bar;
//	foo=1;
//	foo[3]=5;
//	import std;
//	foo_.writeln;
//	foo=10;
//	foo_.writeln;
//	bar++=4;
//	bar++=6;
//	bar++=7;
//	foo_.writeln;
//}

alias aliasseq(T...)=T;
struct tuple(T...){
	T types;
	alias types this;
}
auto ref weak(T,alias A)(){
	static if(is(T:typeof(A))){
		return A;
	} else {
		return T.init;
}}
auto ref weak(T,S)(auto ref S a){
	static if(is(T:S)){
		return a;
	} else {
		return T.init;
}}