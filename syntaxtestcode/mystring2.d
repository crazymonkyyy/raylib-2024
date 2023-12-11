//broke cause template header

struct mystring{
	string me;
	string opSlice(T:size_t)(T a,T b){
		return me[a..b];
	}
	string opSlice(T)(char c,T t){
		foreach(i,c_;me){
			if(c_==c) return this[i,t];
		}
		return "";
	}
	string opSlice(size_t a,char c){
		foreach_reverse(i,c_;me){
			if(c_==c) return opSlice(a,i);
		}
		return "";
	}
}
unittest{
	import std;
	//                123456789012345678901234567890
	auto s=mystring("foo%bar^foobar$faz%hi");
	s[2..'^'].writeln;
	s['$'..19].writeln;
	s['%'..'^'].writeln;
}