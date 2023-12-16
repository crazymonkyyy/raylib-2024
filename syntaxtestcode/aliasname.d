import std;
template getname(alias A){
	enum string getname=A.stringof;
}
//void main(){
//	int foo;
//	getname!foo.writeln;
//	struct vec2{int x;int y;}
//	vec2 bar;
//	getname!(bar.x).writeln;
//}
template indexedstring(int i){
	//ref indexedstring(){
	//	static string s;
	//	return s;
	//}
	static string indexedstring;
}
template watch(alias A,int i){
	void watch(){
		indexedstring!i = A.stringof~":"~A.to!string;
	}
}
void debugmenu(int i)(){
	static foreach(j;0..i){
		indexedstring!j.writeln;
}}
void main(){
	int i;
	int j;
	float k;
	while(true){
	i++;
	watch!(i,0);
	j*=-1;
	if(i%2){
		j++;
		watch!(j,1);
	}
	k+=.0001;
	watch!(k,2);
	debugmenu!3;
}}