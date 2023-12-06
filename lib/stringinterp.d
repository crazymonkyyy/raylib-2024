//TODO: make functional 

int[] tokenindexs(string s){
	int[] o=[0];
	bool which;
	char[2] chars=['$',' '];
	int index;
	loop:
		if(s.length==0){
			o~=index;
			return o;
		}
		if(s[0]==chars[which]){
			o~=index+which;
			which= ! which;
		}
		s=s[1..$];
		index++;
	goto loop;
}
//unittest{
//	import std;
//	enum s="hi $name  im $name2 , thats $name3";
//	s.tokenindexs.writeln;
//	foreach(i,c;s){
//		writeln(i,',',c);
//	}
//}
auto slice(int[] indexs,string s){
	struct pair{ string litteral; string token;}
	pair[] o;
	loop:
		if(indexs.length<3){
			//import std; indexs.writeln;
			//s.length.writeln;
			if(indexs.length==2){
				o~=pair(s[indexs[0]..indexs[1]],"");
			}
			return o;
		}
		o~=pair(s[indexs[0]..indexs[1]],s[indexs[1]+1..indexs[2]-1]);
		indexs=indexs[2..$];
	goto loop;
}
//unittest{
//	import std;
//	enum s="hi $name  im $name2 , thats $name3 :$foo + $bar = $foo $bar ";
//	s.tokenindexs.slice(s).each!writeln;
//}
string interp(string s,string[string] env){
	string o;
	//s=s.dup;
	s~=' ';
	foreach(p;s.tokenindexs.slice(s)){
		o~=p.litteral;
		if(p.token in env){
			o~=env[p.token];
		}
	}
	return o;
}
//unittest{
//	import std;
//	enum s="hi $name  im $name2 , thats $name3 :$foo +$bar =$foo $bar ;someextratext $missing";
//	s.interp([
//		"name":"bill",
//		"name3":"john",
//		"name2":"bob",
//		"foo":"1",
//		"bar":"2",
//	]).writeln;
//}