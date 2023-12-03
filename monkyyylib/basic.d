version(D_BetterC){
	public import wasmstd; 
	enum betterc=true;
	mixin template mainhack(){
		extern(C) void main()=>main_;
	}
} else {
	public import std;
	enum betterc=false;
	mixin template mainhack(){
		extern(C) void main()=>main_;
	}
}
public import raylib;