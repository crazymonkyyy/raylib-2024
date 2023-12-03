//dmd -mixin=mix -run count.d

import std;
template counter(){
	template access(int i){
		//pragma(msg,j,"acess");
		enum access=mixin("__LINE__");
	}
	template get_(int i,int sentinel){
		//pragma(msg,i," ",sentinel);
		static if(access!(i)>sentinel){
			enum get_=i;
		} else {
			enum get_=get_!(i+1,sentinel);
	}}
	template get(int i=__LINE__){
		enum setty=mixin("__LINE__");
		alias get=get_!(0,setty);
	}
}
void main(){
	counter!().get!().writeln;
	counter!().get!().writeln;
	counter!().get!().writeln;
}