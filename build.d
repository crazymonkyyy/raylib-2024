#!rdmd -I./lib
import std;
string buildscript;
string file;
void main(string[] s){
	assert(s.length>1,"TODO:");
	if(s[1][0]=='-'){
		buildscript="buildscripts/"~s[1][1..$]~".dsh";
		s=s[1..$];
	}else{
		buildscript="buildscripts/default.dsh";
	}
	file=s[1];
	//----
	auto command=File(buildscript).byLineCopy;
	//command.writeln;
	import stringinterp;
	auto command_=command.map!(
		a=>a.to!string.interp([
			"file":file,
		])
	);
	//command_.writeln;
	command_.each!((a){a.writeln;a.executeShell.output.writeln;});
}