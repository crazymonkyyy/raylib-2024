import raylib;
struct colorscheme{
	string name;
	Color[16] data; alias data this;
	this()(string file){
		import basic;
		import myalgorithms;
		assert(file[$-4..$]==".csv");
		name=file[file.lastindex('/')+1..$-4];
		foreach(i,e;File(file).byLine.front.split(',').take(16)){
			data[i]=Color(e.to!string);
		}
	}
	this(string s,Color[] c){
		name=s;
		data=c;
	}
}
auto dune = colorscheme("atelier-dune", [Color(32, 32, 29, 255), Color(41, 40, 36, 255), Color(110, 107, 94, 255), Color(125, 122, 104, 255), Color(153, 149, 128, 255), Color(166, 162, 140, 255), Color(232, 228, 207, 255), Color(254, 251, 236, 255), Color(215, 55, 55, 255), Color(182, 86, 17, 255), Color(174, 149, 19, 255), Color(96, 172, 57, 255), Color(31, 173, 131, 255), Color(102, 132, 225, 255), Color(184, 84, 212, 255), Color(212, 53, 82, 255)]);
auto darkviolet = colorscheme("darkviolet", [Color(0, 0, 0, 255), Color(35, 26, 64, 255), Color(67, 45, 89, 255), Color(89, 51, 128, 255), Color(0, 255, 0, 255), Color(176, 138, 230, 255), Color(144, 69, 230, 255), Color(163, 102, 255, 255), Color(168, 46, 230, 255), Color(187, 102, 204, 255), Color(242, 157, 242, 255), Color(69, 149, 230, 255), Color(64, 223, 255, 255), Color(65, 54, 217, 255), Color(126, 92, 230, 255), Color(168, 134, 191, 255)]);
auto gruvboxdark = colorscheme("gruvbox-dark-hard", [Color(29, 32, 33, 255), Color(60, 56, 54, 255), Color(80, 73, 69, 255), Color(102, 92, 84, 255), Color(189, 174, 147, 255), Color(213, 196, 161, 255), Color(235, 219, 178, 255), Color(251, 241, 199, 255), Color(251, 73, 52, 255), Color(254, 128, 25, 255), Color(250, 189, 47, 255), Color(184, 187, 38, 255), Color(142, 192, 124, 255), Color(131, 165, 152, 255), Color(211, 134, 155, 255), Color(214, 93, 14, 255)]);
auto gruvboxlight = colorscheme("gruvbox-light-hard", [Color(249, 245, 215, 255), Color(235, 219, 178, 255), Color(213, 196, 161, 255), Color(189, 174, 147, 255), Color(102, 92, 84, 255), Color(80, 73, 69, 255), Color(60, 56, 54, 255), Color(40, 40, 40, 255), Color(157, 0, 6, 255), Color(175, 58, 3, 255), Color(181, 118, 20, 255), Color(121, 116, 14, 255), Color(66, 123, 88, 255), Color(7, 102, 120, 255), Color(143, 63, 113, 255), Color(214, 93, 14, 255)]);
auto horizon = colorscheme("horizon-terminal-light", [Color(253, 240, 237, 255), Color(250, 218, 209, 255), Color(249, 203, 190, 255), Color(189, 179, 177, 255), Color(148, 140, 138, 255), Color(64, 60, 61, 255), Color(48, 44, 45, 255), Color(32, 28, 29, 255), Color(233, 86, 120, 255), Color(249, 206, 195, 255), Color(250, 218, 209, 255), Color(41, 211, 152, 255), Color(89, 225, 227, 255), Color(38, 187, 217, 255), Color(238, 100, 172, 255), Color(249, 203, 190, 255)]);
auto mocha = colorscheme("mocha", [Color(59, 50, 40, 255), Color(83, 70, 54, 255), Color(100, 82, 64, 255), Color(126, 112, 90, 255), Color(184, 175, 173, 255), Color(208, 200, 198, 255), Color(233, 225, 221, 255), Color(245, 238, 235, 255), Color(203, 96, 119, 255), Color(210, 139, 113, 255), Color(244, 188, 135, 255), Color(190, 181, 91, 255), Color(123, 189, 164, 255), Color(138, 179, 181, 255), Color(168, 155, 185, 255), Color(187, 149, 132, 255)]);
auto nord = colorscheme("nord", [Color(46, 52, 64, 255), Color(59, 66, 82, 255), Color(67, 76, 94, 255), Color(76, 86, 106, 255), Color(216, 222, 233, 255), Color(229, 233, 240, 255), Color(236, 239, 244, 255), Color(143, 188, 187, 255), Color(191, 97, 106, 255), Color(208, 135, 112, 255), Color(235, 203, 139, 255), Color(163, 190, 140, 255), Color(136, 192, 208, 255), Color(129, 161, 193, 255), Color(180, 142, 173, 255), Color(94, 129, 172, 255)]);
auto onedark = colorscheme("onedark", [Color(40, 44, 52, 255), Color(53, 59, 69, 255), Color(62, 68, 81, 255), Color(84, 88, 98, 255), Color(86, 92, 100, 255), Color(171, 178, 191, 255), Color(182, 189, 202, 255), Color(200, 204, 212, 255), Color(224, 108, 117, 255), Color(209, 154, 102, 255), Color(229, 192, 123, 255), Color(152, 195, 121, 255), Color(86, 182, 194, 255), Color(97, 175, 239, 255), Color(198, 120, 221, 255), Color(190, 80, 70, 255)]);
auto solarizeddark = colorscheme("solarized-dark", [Color(0, 43, 54, 255), Color(7, 54, 66, 255), Color(88, 110, 117, 255), Color(101, 123, 131, 255), Color(131, 148, 150, 255), Color(147, 161, 161, 255), Color(238, 232, 213, 255), Color(253, 246, 227, 255), Color(220, 50, 47, 255), Color(203, 75, 22, 255), Color(181, 137, 0, 255), Color(133, 153, 0, 255), Color(42, 161, 152, 255), Color(38, 139, 210, 255), Color(108, 113, 196, 255), Color(211, 54, 130, 255)]);
auto solarizedlight = colorscheme("solarized-light", [Color(253, 246, 227, 255), Color(238, 232, 213, 255), Color(147, 161, 161, 255), Color(131, 148, 150, 255), Color(101, 123, 131, 255), Color(88, 110, 117, 255), Color(7, 54, 66, 255), Color(0, 43, 54, 255), Color(220, 50, 47, 255), Color(203, 75, 22, 255), Color(181, 137, 0, 255), Color(133, 153, 0, 255), Color(42, 161, 152, 255), Color(38, 139, 210, 255), Color(108, 113, 196, 255), Color(211, 54, 130, 255)]);
enum colorschemenames=["dune", "darkviolet", "gruvboxdark", "gruvboxlight", "horizon", "mocha", "nord", "onedark", "solarizeddark", "solarizedlight"];

public colorscheme activecolorscheme;//=solarizeddark;

void swapcolorscheme(){
	static int last=8;//TODO: check if 8 is solarized dark;
	last++; last%=10;
	lable: switch(last){
		static foreach(i,s;colorschemenames){
			mixin("case ",i,": activecolorscheme =",s,";");
			break lable;
		}
		default: break;
	}
}
import toggle;
public stickyindex!(activecolorscheme,0,7)  background;
public stickyindex!(activecolorscheme,1,8)  highlight;
public stickyindex!(activecolorscheme,7,15) text;//15 or 16? is 16 the error color?should this line up with background and hightlights?
public stickyindex!(activecolorscheme,8,16) color;
public stickyindex!(activecolorscheme,0,16) allcolors;

void resetcolors(){//called in start drawing
	background.reset;
	highlight.reset;
	text.reset;
	color.reset;
	//allcolors //maybe someone making rainbow vomit wont want this to reset
}

//void main(string[] s){
//	import std   ;
//	auto a=colorscheme(s[1]);
//	writeln("auto ",a.name," = ",a,";");
//}