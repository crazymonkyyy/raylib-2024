import raylib;
import monkyyycolor;
import staticabstractions;
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

void drawtext(/*T,*/I,J=int,C=typeof(text),C2=typeof(highlight))
		(string text_,I x,I y,J textsize=weak!J(16),C color=weak!(C,text),C2 color2=weak!(C2,highlight)){
	if(text_.length==0){return;}
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
		x_-=width;
	}
	if(y_<0){
		y_=-y_;
		y_-=size;
	}
	draw(x_,y_,width,size,color2);
	DrawText(t_,x_,y_,size,color);
}
auto loadspritesheet(string sheet_,int width,int height)(){
	struct spritesheet{
		Texture baseimage;
		size_t i;
		auto init(){
			baseimage=LoadTexture("assets/keys.png");
			return this;
		}
		auto __get(int x,int y,float scale=1.0,float rotation=0){
			auto count=baseimage.width/width;
			DrawTexturePro(baseimage,Rectangle((i%count)*width,(i/count)*height,width,height), Rectangle(x,y,width*scale,height*scale), Vector2((width/2)*scale,(height/2)*scale),rotation, Color(255,255,255,255));
		}
		alias opCall=__get;
		auto opIndex(size_t j){
			auto count=baseimage.width/width;
			auto county=baseimage.height/height;
			if(j>count*county){return this;}
			i=j;
			return this;
		}
		auto opIndex(size_t x,size_t y){
			auto count=baseimage.width/width;
			auto county=baseimage.height/height;
			if(x>count||y>county){return this;}
			return this[x+y*count];
		}
	}
	spritesheet foo;
	return foo.init;
}