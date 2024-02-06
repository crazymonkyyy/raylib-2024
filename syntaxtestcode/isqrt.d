
float isqrt(bool veryveryslow:true)(float f){
	import std.math:sqrt;
	return 1/sqrt(f);
}
//float isqrt()(float f){
//	long i;
//	float x2,y;
//	const float threehalfs=1.5;
//	x2=f*.5;
//	y=f;
//	i=*cast(long*)(&y);
//	i=0x5f3759df - (i>>1); // "what the fuck?" -saint carmack
//	y =*cast(float*)&i;
//	y=y*(threehalfs-(x2*y*y));
//	return y;
//}
ref T recast(T,S)(ref S s){
	return *cast(T*)(&s);
}
T abs(T)(T a){
	if(a<0)return -a;
	return a;
}
float isqrt(int iterations,long consant=0x5f3759df,float threehalfs=1.5,float onehalf=.5)(float f){
	import std;
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
alias quakeisqrt=testisqrt!1;
alias quake2isqrt=testisqrt!2;
alias mkyisqrt=testisqrt!(0,0x5f32f948);
alias mordenisqrt=testisqrt!(3,0x5f2fed52,1.55452,0.55570);
void testisqrt(Args...)(){
	import std.stdio;
	foreach(f;[-1000,-1.0,0.0,float.init,.1,.3,.5,.9,1,2,3,4,5,10,13.37,1000]){
		writeln(f,":",isqrt!Args(f));
}}
unittest{
	testisqrt!true;
	testisqrt!(0);
}