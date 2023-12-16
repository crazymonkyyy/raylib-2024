/*
static sized data stuctures

TODO:
*/

struct staticarray(T,int N){
	T[N] data;
	size_t length;
	void opOpAssign(string op: "~")(T t){
		data[length++]=t;
	}
	ref opIndex(size_t i){
		return data[i];
	}
	auto opSlice(){
		return data[0..length];
	}
	auto opSlice(size_t a,size_t b){
		return data[a..b];
	}
	size_t opDollar(){
		return length;
	}
	//lots of todo:
}