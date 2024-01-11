import basic;
T abs(T)(T a){
	if(a>0){return a;}
	return -a;
}
auto dis(Vector2 a,Vector2 b){
	return abs(a.x-b.x)+abs(a.y-b.y);
}
T lerp(T)(T a, T b, float t){
	return a + (b - a) * t;
}
T min(T)(T a, T b){
	static if(is(T==size_t)){
		if(a==T.min-1){return 0;}
	}
	if(a<b){return a;}
	return b;
}
T inverseLerp(T)(T a, T b, T value){
	if (a != b) {
		return (value - a) / (b - a);
	} else {
		return a;
	}
}

S remap(T,S)(T value, T fromLow, T fromHigh, S toLow, S toHigh){
	auto t=inverseLerp(fromLow, fromHigh, value);
	return lerp(toLow, toHigh, t);
}
T clamp(T)(ref T v,T l,T h){
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
	while(v>high){
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
	return *cast(T[M]*)(&data);
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
