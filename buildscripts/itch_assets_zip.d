import std;
import myalgorithms:elementslice;

void main(string[] s){
	"rm itch_assets_zip.o".executeShell;
	["emcc --shell-file=buildscripts/itch.html -o index.html *.o libraylib.a -s USE_GLFW=3 -s ASYNCIFY "].chain(
	File(s[1]).byLineCopy
		.map!(a=>a.elementslice!".byascii"('"','"'))
		.filter!(a=>a.length>"assets".length)
		.filter!(a=>a[0.."assets".length]=="assets")
		.map!(a=>" --preload-file "~a)
	)
	.join(' ').executeShell.output.writeln;
}