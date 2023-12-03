import std;
template getname(alias A){
	enum string getname=A.stringof;
}
void main(){
	int foo;
	getname!foo.writeln;
	struct vec2{int x;int y;}
	vec2 bar;
	getname!(bar.x).writeln;
}