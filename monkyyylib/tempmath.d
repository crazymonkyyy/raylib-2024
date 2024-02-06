//libc-less math, probaly low quality in lots of ways

import basic;
T abs(T)(T a){
	if(a>0){return a;}
	return -a;
}
void swap(T)(T a,T b){
	T t=a;
	a=b;
	b=t;
}
auto dis(Vector2 a,Vector2 b=Vector2(0,0)){
	return abs(a.x-b.x)+abs(a.y-b.y);
}
auto norm(Vector2 a){
	auto n=(abs(a.x)+abs(a.y)).mordenisqrt;
	return Vector2(a.x*n,a.y*n);
}
T lerp(T)(T a, T b, float t){
	return a +cast(T)((b-a)*t);
}
T min(T)(T a, T b){
	static if(is(T==size_t)){
		if(a==T.min-1){return 0;}
	}
	if(a<b){return a;}
	return b;
}
float inverseLerp(T)(T a, T b, T value){
	if (a != b) {
		return (value - a) / (cast(float)b - a);
	} else {
		return a;
	}
}

S remap(T,S)(T value, T fromLow, T fromHigh, S toLow, S toHigh){
	auto t=inverseLerp(fromLow, fromHigh, value);
	return lerp(toLow, toHigh, t);
}
T clamp(T)(auto ref T v,T l,T h){
	if(v<l)v=l;
	if(v>h)v=h;
	return v;
}
//float sin(float x){
//	import std.math;
//	return sin(x);
//}
//float cos(float x){
//	return sin(x-90);
//}

T warp(T)(T v,T low,T high){//TODO actaully math
	while(v>=high){
		v-=high-low;
	}
	while(v<low){
		v+=high-low;
	}
	return v;
}
int floor(float f){
	return cast(int)f;
}
T min(T)(T[] a...){
	T o=T.max;
	foreach(e;a){
		if(e<o){o=e;}
	}
	return o;
}
T max(T)(T[] a...){
	T o=T.min;
	foreach(e;a){
		if(e>o){o=e;}
	}
	return o;
}
tuple!(T,T) extermes(T)(T[] a...){
	return tuple!(T,T)(min(a),max(a));
}

float cos(float x){
	enum float tp = 1.0 / 360;
	x=warp(x,0,360);
	x *= tp;
	x -= float(0.25) + floor(x + float(0.25));
	x *= float(16.0) * (abs(x) - float(0.50));
	return x;
}
float sin(float x){//TODO check if this is all correct parity
	return cos(x-90);
}
auto binaryblob(T=ubyte,S,size_t N)(S[N] data...){
	enum M=(S.sizeof*N)/T.sizeof;
	//static if(__ctfe){
	//	//T[M] o;
	//	//foreach(i,e;
	//} else {
		return *cast(T[M]*)(&data[0]);
	//}
}
/*
void main(){
	import std;
	ulong x=0xffeeddccbbaa9988;
	[x].binaryblob.writeln;
	x.writeln;
	[x].binaryblob.binaryblob!ulong.writeln;
}
*/
auto tostringblob(T,size_t N)(T[N] data...){
	import mystring;
	enum chars="0123456789ABCDEF";
	str!(T.sizeof*N*2+N*3+N/8+5) o;
	foreach(i,list;data){
		o~="0x";
		foreach(e;binaryblob([list])){
			o~=chars[e/16];
			o~=chars[e%16];
		}
		o~=',';
		if(i%8==7){
			o~='\n';
		}
	}
	return o;
}
/*void main(){
	import std;
	[1,2,1337].tostringblob.writeln;
}*/
ref T recast(T,S)(ref S s){
	return *cast(T*)(&s);
}
float isqrt(int iterations,long consant=0x5f3759df,float threehalfs=1.5,float onehalf=.5)(float f){
	long i;
	static if(iterations>0){
		float x2;
		x2=f*onehalf;
		const float threehalfs_=threehalfs;
	}
	i=f.recast!long;
	i=consant - (i>>1); // "what the fuck?" -saint carmack
	f=i.recast!float;
	static foreach(_;0..iterations){
		f=f*(threehalfs_-(x2*f*f));
	}
	return f.abs;//TODO: find out why theres negitive answer coming thru, .3, .5
}
alias quakeisqrt=isqrt!1;
alias quake2isqrt=isqrt!2;
alias mkyisqrt=isqrt!(0,0x5f32f948);
alias mordenisqrt=isqrt!(3,0x5f2fed52,1.55452,0.55570);