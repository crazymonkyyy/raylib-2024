#!rdmd
import std;
string buildscript;
string file;
void main(string[] s){
	assert(s.length>1,"TODO:");
	if(s[1][0]=='-'){
		buildscript="buildscripts/"~s[1][1..$]~".dsh";
	}else{
		assert(0,"TODO:");
	}
	//----
	dstring command=File(buildscript).byLineCopy.join(';').array;
	auto pid=spawnShell(command.to!string);
	wait(pid);
}