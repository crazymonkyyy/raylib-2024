//import core.stdc.stdio;
//extern(C):

char* tostringz(string s){
	//import core.stdc.stdlib;
	//import core.stdc.string;
	char* copy = cast(char*)malloc((s.length + 1));
	copy[0 .. s.length] = s[];
	copy[s.length] = 0;
	return &copy[0];
}
void println(){
	printf("\n");
}
void writeln(string a){
	//import std.string:toStringz; the std is fucking worthless
	printf(a.tostringz); println;
}
void writeln(bool b){
	if(b){
		writeln("true");
	} else {
		writeln("false");
	}
}

//void writeln(T...)(T){}