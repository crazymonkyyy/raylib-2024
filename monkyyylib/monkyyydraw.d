import raylib;
import monkyyycolor;
//export sanity; todo

void draw_(T...)(T args)=>draw(args,color:color);//todo make smart
void drawH(T...)(T args)=>draw(args,color:highlight);
void drawB(T...)(T args)=>draw(args,color:background);
void drawA(T...)(T args)=>draw(args,color:allcolor);

//void draw(T...)(Vector2 vec2,T args)=>draw(x:cast(int)vec2.x,y:cast(int)vec2.y,args);
struct gradent{}
import staticabstractions;
//void draw(gradent g,alias A,int low,size_t high,T...)(stickyindex!(A,low,high) color,T args)=>draw(color1:color++,color2:color--,args);

alias draw=raylib.DrawCircle;
alias draw=raylib.DrawCircleGradient;
alias draw=raylib.DrawPixel;
alias draw=raylib.DrawRectangle;
alias draw=raylib.DrawRectangleGradientH;
//alias draw=
//alias draw=
/*
TODO:
figure out how named agruments work with overload sets and expand this to allot of functions

right now im getting nonsense errors, and shit

I stuggle with 3 layers of recersion 
*/

void drawtext(/*T,*/I,J,C,C2)(string text_,I x,I y,J textsize=16,C color=text,C2 color2=highlight){
	void assertcstring(T)(char* s,T len){
		assert(s[len]==0,"is not a c string");
	}
	//string t=text_;
	
	char* t_=cast(char*)&(text_[0]);
	assertcstring(t_,text_.length);
	int x_=cast(int)x;
	int y_=cast(int)y;
	int size=cast(int)textsize;
	int width=MeasureText(t_,size);
	if(x_<0){
		x_=-x_;
		x-=width;
	}
	if(y_<0){
		y_=-y_;
		y-=size;
	}
	draw(x_,y_,width,size,color2);
	DrawText(t_,x_,y_,size,color);
}