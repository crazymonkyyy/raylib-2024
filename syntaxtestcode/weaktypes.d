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
float lerpammount=.5;
auto lerp(I,F=typeof(lerpammount))(I a,I b,F per=weak!(F,lerpammount)){
	import std;
	writeln(a," ",b," ",per);
}
auto remap(T,S=float)(T v,T min1=weak!(T,T.min),T max1=weak!(T,T.max),S min2=weak!S(0.0),S max2=weak!S(1.0)){
	import std;
	writeln(v," ",min1," ",max1," ",min2," ",max2);
}
struct myfloat{}
struct myint{
	int i;
	enum min=myint(0);
	enum max=myint(100);
}
void main(){
	lerp(1,10);
	lerp(1,10,myfloat());
	lerpammount=.9;
	lerp(1,10);
	lerp(myint(),myint());
	remap(ubyte(128));
	remap(ubyte(167),ubyte(128));
	remap(5,0,10);
	remap(5,0,10,.5);
	remap(myint());
	remap(5,0,10,myint(100),myint(0));
}