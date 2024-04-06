import basic;
import std;
//mixin mainhack!();

int[300] data;
auto where(int i)=> Vector2(cos(i/6.0)*i+400,sin(i/6.0)*i+300);
void main(){
	makewindow;
	SetTargetFPS(10);
	while(!WindowShouldClose()){
		foreach(k;iota(1,299).array.randomShuffle){
			k.writeln;
			int j=k;
			while(j<300){
				startdrawing;
				data[j]++;
				foreach(i;0..300){
					if(i!=j){
						DrawCircleV(where(i),3,color[data[i]]);
				}}
					DrawLineV(where(j),where(j-k),allcolors[7]);
				if(WindowShouldClose()){goto exit;}
				enddrawing;
				j+=k;
	}}}
	exit:
	CloseWindow();
}
