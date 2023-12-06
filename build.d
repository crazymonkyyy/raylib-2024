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
	dstring command=File(buildscript).byLineCopy.join(';').array;
	command.writeln;
	import stringinterp;
	string command_=command.to!string.interp([
		"file":file,
	]);
	command_.writeln;
	auto pid=spawnShell(command_);
	wait(pid);
}