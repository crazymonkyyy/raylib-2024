template toggle(bool defualt=false,alias discriminator=void, int i=__LINE__){
	static bool __toggle=defualt;
	bool toggle(bool input){
		if(input){
			__toggle= ! __toggle;
		}
		return __toggle;
	}
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