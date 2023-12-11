import std;
struct foo{
	int i;
	void bar(T:char)(T c){
		"hello".writeln;
		i++;
	}
	void bar(T:string)(string s){
		"hi".writeln;
		this.bar('h');
	}
	void bar(T)(T t){
		this.bar("bye");
		i++;
	}
}
unittest{
	foo f;
	f.bar(1);
}