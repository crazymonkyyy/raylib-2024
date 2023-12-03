version(D_BetterC){
	import wasmstd; 
	enum betterc=true;
	extern(C) void main()=>main_;
} else {
	import std;
	enum betterc=false;
	void main()=>main_;
}
void main_(){
	betterc.writeln;
	"hello".writeln;
}