import std;
struct counter{
	int front;
	int end;
	counter pop(){
		return counter(front+1,end);
	}
	bool empty(){
		return front>=end;
	}
}
unittest{
	auto r=counter(0,10);
	while(!r.empty){
		r.front.writeln;
		r=r.pop;
	}
	auto immutable foo=counter(1,3); 
}
struct filter(alias F,R){
	R r;
	auto front()=>r.front;
	typeof(this) pop(){
		auto o=typeof(this)(r.pop);
		while( ! F(o.r.front)){
			writeln("discard",o.r.front);
			o.r=o.r.pop;
		}
		return o;
	}
	bool empty()=>r.empty;
}
unittest{
	filter!(a=>a%2,counter) r;
	r.r=counter(1,10);
	immutable auto r_=cast(immutable typeof(r))r;
	while(!r.empty){
		r.front.writeln;
		r=r.pop;
	}
}