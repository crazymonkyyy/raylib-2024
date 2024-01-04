import basic;
import raygui;//#WONTFIX: raygui doesnt have a cheatsheet, seems to be broken on seviel guys code, seems most in need of d spefic wrapping
mixin mainhack!();
void main_(){
	makewindow;
	while(!WindowShouldClose()){
		startdrawing;
		GuiButton(Rectangle(10,10,40,80),GuiIconText(ICON_FILE_OPEN, "Open Image")); 
		
		with(button){
		if(f1) status("working");
		
		enddrawing;
	}}
	CloseWindow();
}