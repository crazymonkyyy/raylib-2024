auto mixinmap(string front_,string body_="",R,Args...)(R r,Args args){
	struct range{
		R r;
		size_t i;
		mixin(body_);
		bool dirty=true;
		auto calcfront(){
			auto a=r.front;
			mixin(front_);
		}
		typeof(calcfront()) store;
		auto front(){
			if(dirty){
				store=calcfront;
				dirty=false;
			}
			return store;
		}
		void popFront(){
			r.popFront;
			dirty=true;
			i++;
		}
		bool empty(){
			return r.empty;
		}
	}
	return range(r,0,args);
}
auto lastindex(R,E)(R r,E e){
	int o=-1;
	foreach(i,e_;r){
		if(e==e_){o=cast(int)i;}
	}
	return o;
}
//test syntex for new ranges?
enum isIter(R)=is(typeof(
	(R r){
		if(r.empty)return r.front;
		r.pop;
		return r.front;
	}));
enum hasIndex(R)=is(typeof((R r)=>r.index));
auto counter(int i){
	struct counter_{
		int end;
		int front=0;
		void pop(){front++;}
		bool empty()=>front>=end;
	}
	return counter_(i);
}
void print(R)(R r){
	static assert(isIter!R,"not an iter");
	import std;
	while(!r.empty){
		r.front.writeln;
		r.pop;
	}
}
unittest{
	//counter(10).print();
}
auto byascii(I=size_t)(string s){
	//todo asset I is int or char*
	struct ascii{
		string s;
		I index;
		char front()=>s[0];
		void pop(){
			index++;
			s=s[1..$];
		}
		bool empty()=>s.length==0;
	}
	I temp;
	static if(is(I==char*)){
		temp=cast(char*)&s[0];
	}
	return ascii(s,temp);
}
unittest{
	//"foobar".byascii!().print;
}
auto filter(alias F,R)(R r){
	static assert(isIter!R);
	struct filter_{
		R r;
		auto front()=>r.front;
		void pop(){
			r.pop;
			while( (!r.empty) && (!F(r.front)) ){
				r.pop;
			}
		}
		bool empty()=>r.empty;
		static if(hasIndex!R){
			auto index()=>r.index;
		}
	}
	auto temp=filter_(r);
	if(temp.empty){return temp;}
	if(!F(temp.front)){temp.pop;}
	return temp;
}
//unittest{
//	counter(10).filter!(a=>a%2).print;
//	"foobar".byascii.filter!(a=>a!='o').print;
//	"".byascii.filter!(a=>true).print;
//	"hello world".byascii!(char*).filter!(a=>false).print;
//}
auto swapkeyvalue(R)(R r){
	struct swap{
		R r;
		auto front()=>r.index;
		auto index()=>r.front;
		auto pop()=>r.pop;
		auto empty()=>r.empty;
	}
	return swap(r);
}
unittest{
	"foobar( (foo) (bar) )".byascii.filter!(a=>a=='(').swapkeyvalue.print;
}

auto elementslice(string toiter="[]",D,E)(D datastucture,E first,E last){
	auto r1=mixin("datastucture"~toiter);
	auto firstfilter=r1.filter!(a=>a==first).swapkeyvalue;
	if(firstfilter.empty){return datastucture[0..0];}
	auto r2=mixin("datastucture[firstfilter.front+1..$]"~toiter);
	auto secondfilter=r2.filter!(a=>a==last).swapkeyvalue;
	if(secondfilter.empty){return datastucture[firstfilter.front..$];}
	return datastucture[firstfilter.front+1..secondfilter.front+firstfilter.front+1];
}
unittest{
	import std;
	"foobar[hi(1223423)..$] = foolknnasdjlkn".elementslice!".byascii"('[',']').writeln;
}
unittest{
	import std;
	"auto keys=loadspritesheet!(\"assets/keys.png\",16,16);".elementslice!".byascii"('"','"').writeln;
	"".elementslice!".byascii"('"','"').writeln;
}