/* minium viable std
every possible trade off to just get it done
orginaztion? nah mega file
more then 1 unittest? nah
docs? what for you have unittest
comprosmizes with other view points? nah everyone else wrong
effent code? nah, who needs it computers fast
good overloads? nah, just use it well
good error messages? nah just dont make typos
template meta programming to make things easier for the end user? no that would take 100x as long

range:
	front
	pop
	empty
	key
	cap

dense:
	opindex(index)
	opslice
	opdollar

sparce:
	half1/half2
	opindex(key)
	opIn //bool opBinaryRight(string s:"in",K)(K k) ... hot take, opIn shouldnt have been depercated
*/

/* fundemental functions */

auto tuple(T...)(T args){
	struct Tuple{
		enum istuple=true;
		T me; alias me this;
	}
	return Tuple(args);
}
unittest{
	auto foo=tuple(1,"hi");
	assert(foo[0]==1);
	assert(foo[1]=="hi");
	auto bar=tuple();
}
auto totuple(T)(T a) if(is(typeof(a.istuple)))=>a;
auto totuple(T)(T a) if( ! is(typeof(a.istuple)))=>tuple(a);
auto maybetuple(T...)(T a){
	static if(T.length==1){
		return a[0];
	} else {
		return tuple(a);
}}
alias seq(T...)=T;
unittest{
	seq!(int,float) foo=tuple(1,1.35);
}
alias identity=a=>a;
void swap(T,S)(ref T a,ref S b){
	T t=a;
	a=cast(T)b;
	b=cast(S)t;
}
unittest{
	float a=13.37;
	int b=10;
	swap(a,b);
	assert(a==10.0);
	assert(b==13);
}
auto min(T,S)(T a,S b){
	if(a<b){return a;}
	return cast(T)b;
}
auto max(T,S)(T a,S b){
	if(a>b){return a;}
	return cast(T)b;
}
enum magicstring="0123456789ABCDEFGHIZZZZZZZZ";
char tochar(T)(T i)=>magicstring[i%$];
unittest{
	assert(1.tochar=='1');
}

enum isrange(R)=is(typeof((R r){
	while(r.empty){
		auto a=r.front;
		r=r.pop;
	}
}));
enum isdense(R)=is(typeof((R r){
	auto a=r[$-1];
	auto b=r[0..2];
	auto c=r[1..$-2];
	auto d=r[].front;
}));
enum issparce(R)=is(typeof((R r){
	auto k=r[].key;
	auto v=r[k];
	auto h=r.half1;
	auto h2=r.half2;
	bool a=k in r;
	auto r_=r[];
}));
enum iselement(T)= 
	( ! isrange!T)&
	( ! isdense!T)&
	( ! issparce!T);
template element(R){//this seems verbose but theres edge cases I only half understand 
	auto foo(R)(R r){
		auto bar=r.front;
		return bar;
	}
	alias element=typeof(foo(R.init).init);
}
auto ref weak(T,alias A)(){
	static if(is(T:typeof(A))){
		return A;
	} else {
		return T.init;
}}
auto ref weak(T,S)(auto ref S a){
	static if(is(T:S)){
		return a;
	} else {
		return T.init;
}}

auto replacewhen(alias F,T)(T a,T b)=>F(a)?b:a;

/* data structures */


//[]torange
auto torange(T)(T[] array...) if( ! __traits(isAssociativeArray,T)){// oh my god: https://issues.dlang.org/show_bug.cgi?id=24437
	struct range{
		T[] array;
		int key;
		auto front()=>array[key];
		auto pop()=>range(array,key+1);
		auto empty()=>key>=array.length;
		auto cap()=>array.length-key;
	}
	return range(array);
}
unittest{
	//torange(1,2,3).print;
	//[1,2,3,4,5].torange.print;
}
auto toshape(T)(T[] array...) if( ! __traits(isAssociativeArray,T)){// oh my god: https://issues.dlang.org/show_bug.cgi?id=24437
	struct shape{
		T[] array;
		auto opIndex(I)(I i)=>array[i];
		auto opSlice(I,J)(I i,J j)=>shape(array[i..j]);
		auto opDollar()=>array.length;
		auto opSlice()=>array.torange;
	}
	return shape(array);
}
//unittest{
//	auto foo=[1,2,3];
//	isdense!(typeof(foo)).print;// false, unforuante but Im not matching the api to the base types
//	auto bar=foo.toshape;
//	isdense!(typeof(bar)).print;
//	isdense!(typeof(toshape(1,2,3))).print;
//}

//T[S] torange
auto torange(T,S,R_=S[])(T[S] array,R_ r=weak!(R_,S[].init)){
	struct range(R){
		T[S] array;
		R r;
		int i;
		T front()=>array[r.front];
		auto pop()=>range(array,r.pop);
		auto empty()=>r.empty;
		auto key()=>r.front;
		auto cap()=>r.cap;
	}
	static if(is(R_==S[])){
		if(r==[]){
			return range!(typeof(r.torange))(array,array.keys.torange);
		} else {
			return range!(typeof(r.torange))(array,r.torange);
		}
	} else {
		return range!R_(array,r);
	}
}
auto toshape(T,S,R_=S[])(T[S] array,R_ r=weak!(R_,S[].init)){
	struct shape(R){
		T[S] array;
		R r;
		auto half1()=>assert(0,"AAAHHHHHH im so fucking overwhelmed todo");
		auto half2()=>assert(0);
		auto opIndex(S k)=>array[k];
		bool opBinaryRight(string s:"in",T)(T k){
			if( ! k in array){return false;}
			return r.any!(a=>a==k);
		}
		auto opSlice(){
			return array.torange(r);
		}
	}
	static if(is(R_==S[])){
		if(r==[]){
			return shape!(typeof(r.torange))(array,array.keys.torange);
		} else {
			return shape!(typeof(r.torange))(array,r.torange);
		}
	} else {
		return shape!R_(array,r);
	}
}
unittest{
	//[1:'a',2:'b',3:'c'].torange.print;
	//[1:'a',2:'b',3:'c'].torange([1,3]).print;
	//[1:'a',2:'b',3:'c'].torange(counter(1,4)).print;
	//[1:'a',2:'b',3:'c'].toshape.print;
	//[1:'a',2:'b',3:'c'].toshape([1,3]).print;
	//[1:'a',2:'b',3:'c'].toshape(counter(1,4)).print;
}
//unicode TODO
auto ascii(string s)=>s.torange;
unittest{
	//"hello world".ascii.print;//bad but im not replacing stdio here
}
struct nullablearray(T,int N){
	T[N] array;
	bool[N] isnull=true;
	alias THIS=typeof(this);
	auto opSlice()=>zip(array.toshape,isnull.toshape).filter!(a=> ! a[1]).map!(a=>a[0]);// lazy and a bit meme-y, but its good this is possible
	auto opIndexAssign(V,I)(V v,I i){
		array[i]=v;
		isnull[i]=false;
	}
	auto opIndexAssign(I)(typeof(null),I i){
		isnull[i]=true;
	}
	this(T)(T[] a...) if(iselement!T){
		foreach(i,e;a){
			this[i]=e;
	}}
	this(R)(R r) if(isrange!R){
		static if(is(typeof(r.key))){
			while( ! r.empty){
				this[r.key]=r.front;
				r=r.pop;
			}
		} else {
			int i;
			while( ! r.empty){
				this[i]=r.front;
				r=r.pop; i++;
			}
		}
	}
}
unittest{
	//nullablearray!(int,10) foo;
	//foo[3]=10;
	//foo[].print;
	//auto bar= nullablearray!(int,10)(true,false,true);
	//bar[].print;
	//auto foobar= nullablearray!(int,10)(counter(3));
	//foobar[].print;
	//auto barfoo= nullablearray!(int,10)(counter(10).cache.filter!(a=>a%3).map!(a=>a*a)[]);
	//counter(10).cache.filter!(a=>a%3).map!(a=>a*a)[].key.print;
	//barfoo[].print;
}
auto counter(A...)(A args){
	struct Counter(T){
		T end=T.max;
		T front=T(0);
		T step=T(1);
		auto pop()=>Counter!T(end,front+step,step);
		bool empty()=>end<=front;
		auto cap()=>(end-front)/step;
	}
	//auto args_=args.totuple;
	static if(A.length>1){
		auto args_=tuple(args[1],args[0],args[2..$]);
	} else {
		auto args_=tuple(args,int.init);
	}
	return Counter!(typeof(args_[0]))(args_[0..A.length]);
}
unittest{
	auto foo=counter();
	assert(foo.front==0);
	foo=foo.pop;
	assert(foo.front==1);
}
unittest{
	auto foo=counter(10);
	assert(foo.front==0);
	foo=foo.pop;
	assert(foo.front==1);
}
unittest{
	auto foo=counter(0,10);
	assert(foo.front==0);
	foo=foo.pop;
	assert(foo.front==1);
}
unittest{
	auto foo=counter(0,10,2);
	assert(foo.front==0);
	foo=foo.pop;
	assert(foo.front==2);
}
unittest{
	auto foo=counter(0.0,1.0,.2);
	assert(foo.front==0);
	foo=foo.pop;
	assert(foo.front==.2);
}
unittest{
	static assert(isrange!(typeof(counter())));
}
/* core algorithms */

//print
void print(R)(R r) if(isrange!R){
	'('.print;
	while( ! r.empty){
		r.front.print;
		r=r.pop;
		print(',');
	}
	")\n".print;
}
void forceprint(R)(R r){
	R.stringof.print;':'.print;
	typeof(r.front()).stringof.print;
	if( ! isrange!R){
		"isnt a range ;__;".print;
		is(typeof((R r)=>r.empty)).print;
		is(typeof((R r){r=r.pop;})).print;
		is(typeof((R r)=>r.front)).print;
	}
	'('.print;
	while( ! r.empty){
		r.front.print;
		r=r.pop;
		print(',');
	}
	")\n".print;
}
void print(R)(R r_) if(isdense!R){
	auto r=r_[];
	'['.print;
	while( ! r.empty){
		r.front.print;
		if(r_[r.key]!=r.front){print("\nindex mismatch ;__;\n");}
		r=r.pop;
		print(',');
	}
	"]\n".print;
}
void forcedenseprint(R)(R r_){
	if( ! isdense!R){
		"isnt dense ;__; \n".print;
		is(typeof((R r){auto a=r[$-1];   })).print;
		is(typeof((R r){auto b=r[0..2];  })).print;
		is(typeof((R r){auto c=r[1..$-2];})).print;
		is(typeof((R r){auto d=r[].front;})).print;
	}
	auto r=r_[];
	'['.print;
	while( ! r.empty){
		r.front.print;
		if(r_[r.key]!=r.front){
			print("\nindex mismatch ;__;"); 
			r_[r.key].print; "!=".print; r.front.print;
			'\n'.print;}
		r=r.pop;
		print(',');
	}
	"]\n".print;
}
void print(R)(R r_) if(issparce!R){
	auto r=r_[];
	'{'.print;
	while( ! r.empty){
		r.key.print;
		':'.print;
		r.front.print;
		if(r_[r.key]!=r.front){print("\nindex mismatch ;__;\n");}
		r=r.pop;
		print(',');
	}
	"}\n".print;
}
void forcesparceprint(R)(R r_){
	static if( ! issparce!R){
		"isnt sparce ;__; \n".print;
		is(typeof((R r){auto k=r[].key; })).print;
		is(typeof((R r){auto k=r[].key;auto v=r[k];    })).print;
		is(typeof((R r){auto h=r.half1; })).print;
		is(typeof((R r){auto h2=r.half2;})).print;
		is(typeof((R r){auto k=r[].key;bool a=k in r;  })).print;
	}
	//static if(is(r_[])){
	auto r=r_[];
	'{'.print;
	while( ! r.empty){
		r.key.print;
		':'.print;
		r.front.print;
		if(r_[r.key]!=r.front){print("\nindex mismatch ;__;\n");}
		r=r.pop;
		print(',');
	}
	"}\n".print;
}//}
unittest{
	//toshape(1,2,3).print;
}
void print(E)(E e) if (iselement!E){
	import std.stdio;
	write(e);
}

auto map(alias F/*,alias keyF=identity*/,R)(R r)if(isrange!R){
	struct Map{
		R r;
		auto front()=>F(r.front);
		auto pop()=>Map(r.pop);
		auto empty()=>r.empty;
		auto key()()=>r.key;//keyF(r.key);
		auto cap()()=>r.cap;
	}
	return Map(r);
}
auto map(alias F/*,alias keyF=identity//disabled for laziness*/,R)(R r) if(isdense!R){
	struct Map{
		R r;
		auto opIndex(I)(I i)=>F(r[i]);
		auto opSlice(I,J)(I i,J j)=>r[i..j].map!F;
		auto opDollar()=>r.opDollar;
		auto opSlice()=>r[].map!F;
	}
	return Map(r);
}
auto map(alias F,R)(R r) if(issparce!R){
	struct Map{
		R r;
		auto half1()=> Map(r.half1);
		auto half2()=> Map(r.half2);
		auto opIndex(I)(I i)=> F(r[i]);
		bool opBinaryRight(string s:"in",K)(K k)=> k in r;
		auto opSlice()=>r[].map!F;
	}
	return Map(r);
}
unittest{
	//counter(10).map!(a=>a*a).print;
	//counter(10).cache.map!(a=>a*a).print;
	//counter(10).cache.filter!(a=>a%2).map!(a=>a*a).forcesparceprint;
}
auto filter(alias F,R)(R r) if(isrange!R){
	struct Filter{
		R r;
		auto front()=>r.front;
		auto pop(){
			auto o=r.pop;
			while( ! o.empty && ! F(o.front)){
				o=o.pop;
			}
			return Filter(o);
		}
		auto empty()=>r.empty;
		auto key()()=>r.key;
		auto cap()()=>r.cap;
	}
	auto t=Filter(r);
	if( ! F(t.front)){t=t.pop;}
	return t;
}
auto filter(alias F,R)(R r) if(isdense!R){
	struct Filter{
		R r;
		auto opIndex(I)(I i)=>r[i];
		/*disabled to simplify sparce api*///auto opSlice(I,J)(I i,J j)=>Filter(r[i..j]);
		//auto opDollar()=>r.opDollar;
		auto half1()=>Filter(r[0..$/2]);
		auto half2()=>Filter(r[$/2..$]);
		bool opBinaryRight(string s:"in",I)(I i){
			if(i<=r[].key){return false;}
			if(i>=r[$-1..$][].key){return false;}//todo check for off by one
			return ! F(r[i]);
		}
		auto opSlice()=>r[].filter!F;
	}
	return Filter(r);
}
unittest{
	//counter(10).filter!(a=>a%2).print;
	//counter(10).cache.filter!(a=>a%2).print;
}
//TODO sparce filter

auto acc(alias F,int returncount=255,R,A...)(R r,A args) if(isrange!R){
	alias E=typeof(F(r.front,args));
	struct accumulate{
		R r;
		E store;
		auto front()=>maybetuple(store.totuple[0..min($,returncount)]);
		auto pop(){
			auto r_=r.pop;
			return accumulate(r_,r_.empty?store:F(r_.front,store));
		}
		auto empty()=>r.empty;
	}
	return accumulate(r,F(r.front,args));
}
unittest{
	//counter(10).acc!((a,b)=>a+b)(0).print;
	//counter(1,10).acc!((a,int b=1)=>a*b).print;
	//counter(10).map!(a=>a+1).acc!((a,int b=0)=>a+b).print;
	//[1,2,3].torange.acc!((a,int b=1)=>a*b).print;
	//todo test a more complex call
}
auto last(R)(R r) if(isrange!R){
	auto store=r;
	r=r.pop;
	while( ! r.empty){
		store=r;
		r=r.pop;
	}
	return store;
}
auto last(R)(R r) if(isdense!R){
	return r[$-1];
}
//last for sparce should condictionally exist but im not making any api for that rn
unittest{
	//counter(10).acc!((a,b)=>a+b)(0).last.print;
}
auto cache(R)(R r) if(isrange!R){
	alias E=element!R;
	E[] o;
	static if(is(r.cap)){
		o.capsity=r.cap;
	}
	while( ! r.empty){
		o~=r.front;
		r=r.pop;
	}
	return o.toshape;
}
auto cache(R)(R r) if(isdense!R){return r;}
auto cache(R)(R r) if(issparce!R){return r;}
unittest{
	//counter(5,10).cache.print;
}
auto takemap(alias F,R)(R r){
	struct Takemap{
		R r;
		int i;
		auto front(){
			struct reftake{
				R* r;
				int cap;
				element!R front()=>r.front;
				auto pop(){
					*r=r.pop;
					return reftake(r,cap-1);
				}
				auto empty()=>cap==0 || r.empty;
				auto key()()=>r,key;
			}
			return reftake(&r,i);
		}
		auto pop(){
			auto r_=r;
			auto i_=0;
			bool wasneg=false;
			loop:
			if(r_.empty){return this;}
			i_=F(r_);
			wasneg=false;
			while(i_<0){
				r_=r_.pop;
				i++;
				wasneg=true;
			}
			if(wasneg){ goto loop;}
			return Takemap(r_,i_);
		}
		auto empty()=>r.empty || i==0;
	}
	return Takemap(r).pop;
}
unittest{
	//auto foo=[1,3,5,0,0,0,0,1,0,9].torange.takemap!(a=>3);
	//auto foo=[1,3,5,0,0,0,0,1,0,9].torange
	//	.takemap!(a=>a.enumerate.filter!(b=>b==0).key.replacewhen!(a=>a==0)(-1));//broken idk
	//foo.print;
}
//auto reindex(alias F,R,S)(R r,S s=weak!(S,()=>counter(r.opDollar))){ //I want this ;__;
auto reindex(alias F,R)(R r)=>r.reindex!F(counter(r.opDollar));
auto reindex(alias F,R,S)(R r,S s){
	static assert(isdense!R);
	struct Reindex{
		R r; S s;
		auto opIndex(I)(I i)=>r[F(i)];
		auto opSlice(I,J)(I i,J j)=>assert(0,"idk todo");//Reindex(r[F(i)..F(j)], I want to write s[i..j] but thats not in the api
		auto opDollar()=>s.cap;
		auto opSlice(){
			struct Reindex{
				R r; S s;
				auto front()=>r[F(s.front)];
				auto pop()=>Reindex(r,s.pop);
				auto empty()=>s.empty;
				auto key()()=>s.front;
				auto cap()()=>s.cap;
			}
			return Reindex(r,s);
		}
	}
	return Reindex(r,s);
}
unittest{
	//auto foo=counter(10).cache.reindex!(a=>(a*2+a/5)%10);
	//foo[5].print;
	//foo.print;
}
auto slide(R)(R r) if(isrange!R){
	struct Slide{
		R r;
		auto front()=>r;
		auto pop()=>Slide(r.pop);
		auto empty()=>r.empty;
		auto key()()=>r.key;
	}
	return Slide(r);
}
auto slide(R)(R r) if(isdense!R){
	struct Slide{
		R r;
		auto opIndex(I)(I i)=>r[i..$][];
		auto opSlice(I,J)(I i,J j)=>assert(0,"todo complex");
		auto opDollar()=>r.opDollar;
		auto opSlice()=>r[].slide;
	}
	return Slide(r);
}
auto slide(R)(R r) if(issparce!R){ static assert(0,"slide on hash map is probaly wrong");}
unittest{
	//counter(3).slide.print;
	//counter(3).cache.slide.forcedenseprint; //erounous index mismatches todo
}
auto zip(R,S)(R r,S s) if(isrange!R && isrange!S){
	struct Zip{
		R r; S s;
		auto front()=>tuple(r.front,s.front);
		auto pop()=>Zip(r.pop,s.pop);
		auto empty()=>r.empty || s.empty;
		auto key()(){
			assert(r.key==s.key);
			return r.key;
		}
		auto cap()()=>min(r.cap,s.cap);
	}
	return Zip(r,s);
}
auto zip(R,S)(R r,S s) if(isdense!R && isdense!S){
	struct Zip{
		R r; S s;
		auto opIndex(I)(I i)=>tuple(r[i],s[i]);
		auto opSlice(I,J)(I i,J j)=>zip(r[i..j],s[i..j]);
		auto opDollar()=>min(r.opDollar,s.opDollar);
		auto opSlice()=>zip(r[],s[]);
	}
	return Zip(r,s);
}
//TODO sparce zip
auto zip(R,S)(R r,S s) if(isrange!R && ! isrange!S)=> zip(r,s[]);
auto zip(R,S)(R r,S s) if( ! isrange!R &&isrange!S)=> zip(r[],s);
unittest{
	//zip(counter(3,7),counter(15,20)).print;
	//auto foo=zip(counter(3,7).cache,counter(15,20).cache);
	//foo.print;
	//foo[2].print;
}

/* I consider sorting, radix sorting and binary sreach to be fundmental algorthims but for sorting 
I think that be a whole debate how to impliment and hard(detecting if radix sort works, 
making "schwartz sort" work natively, etc), and I have no specail insight in how to make binarchy sreach
*/

/* hacks (things poeple need but break assumptions)*/

auto swapkeyvalue(R)(R r) if(isrange!R){
	struct swap{
		R r;
		auto front()=>r.key;
		auto pop()=>swap(r.pop);
		auto key()=>r.front;
		auto empty()=>r.empty;
	}
	return swap(r);
}
auto swapkeyvalue(R)(R r) if( ! isrange!R){
	struct swap{
		R r;
		alias r this;
		auto opSlice()=>r[].swapkeyvalue;
	}
	return swap(r);
}
unittest{
	//auto foo=toshape(['a':1,'b':2,'c':3]);
	//foo[].print;
	//foo.swapkeyvalue[].print;
}

auto repeat(E,I)(E e,I i)=>counter(i).map!(a=>e);
unittest{ assert(5.repeat(3).cache.array==[5,5,5]);}

auto enumerate(R)(R r){
	struct Enumerate{
		R r;
		typeof(counter()) c;
		auto front()=>r.front;
		auto pop()=>Enumerate(r.pop,c.pop);
		auto key()=>c.front;
		auto empty()=>r.empty;
		auto cap()()=>r.cap;
	}
	return Enumerate(r,counter());
}
unittest{
	//nullablearray!(int,10)(counter(10).map!(a=>a*a).enumerate.filter!(a=>a%2))[].print;
}
auto half1(R)(R r) if(isdense!R)=>r[0..$/2];
auto half2(R)(R r) if(isdense!R)=>r[$/2..$];


/* composate algorthims*/

auto reduce(alias F,R)(R r)=>r.acc!F.last.front;
unittest{ assert(counter(10).reduce!((a,int b=0)=>a+b)==45);}

auto all(alias F,R)(R r)=>r.map!F.filter!(a=>!a).empty;
unittest{ assert([1,3,5,7,9].torange.all!(a=>a%2));}

auto any(alias F,R)(R r)=> ! r.filter!F.empty;
unittest{ assert([1,2,3,4,15].torange.any!(a=>a==15));}

auto count(R)(R r)=>r.reduce!((a,int b=0)=>b+1);
unittest{ assert(counter(10).filter!(a=>a%2).count==5);}

auto find(alias F,R)(R r)=>r[r[].filter!F.key..$];
unittest{ assert(counter(1,10).cache.find!(a=>a%5==0).cache.array==[5,6,7,8,9]);}
auto find(R,E)(R r,E e)=>r.find!(a=>a==e);
unittest{ assert(counter(1,10).cache.find(5).cache.array==[5,6,7,8,9]);}

auto indexes(alias F,R)(R r)=>r.filter!F.swapkeyvalue;
unittest{ assert([1,4,6,78,9].torange.indexes!(a=>a%2).cache.array==[0,4]);}

auto balenced(R,E)(R r,E left,E right){
	int cmp(E_)(E_ e){
		if(e==left) return 1;
		if(e==right)return -1;
		return 0;
	}
	auto temp=r.map!(a=>cmp(a)).acc!((a,int b=0)=>a+b);
	return temp.all!(a=>a>=0) && temp.last.front==0;
}
auto balenced(R)(R r)=>r.balenced('(',')');//todo get rid of extra defination
unittest{
	//"()()(flrhnajkhbfglk)".ascii.balenced.print;
	//"((()))".ascii.balenced.print;
}

auto issorted(R)(R r)=>r.slide.filter!(a=> ! a.pop.empty).all!(a=>a.front<a.pop.front);
unittest{ assert([1,2,3,4,5].torange.issorted); assert( ! [1,2,3,9999,5].torange.issorted);}

auto max(R)(R r)=>r.reduce!((a,element!R b=element!R.min)=>max(a,b));
unittest{ assert([1,5,3].torange.max==5);}

auto min(R)(R r)=>r.reduce!((a,element!R b=element!R.max)=>min(a,b));
unittest{ assert([1,5,3].torange.min==1);}

auto sum(R)(R r)=>r.reduce!((a,element!R b=element!R(0))=>a+b);
unittest{ assert([1,5,3].torange.sum==9);}

auto product(R)(R r)=>r.reduce!((a,element!R b=element!R(1))=>a*b);
unittest{ assert([1,5,3].torange.product==15);}

auto stride(R,I)(R r,I i)=>r.reindex!(a=>a*i)(counter(r.opDollar/i+(r.opDollar%i!=0)));
unittest{ assert(counter(10).cache.stride(3)[].cache.array==[0,3,6,9]);}

auto cycle(R)(R r)=>r.reindex!(a=>a%r.opDollar)(counter);
unittest{ assert( [1,2,3].toshape.cycle[].take(9).array==[1,2,3,1,2,3,1,2,3]);}

auto chunk(R)(R r,int i)=>r.takemap!(a=>i);
unittest{ assert(counter(10).chunk(3).map!(a=>a.cache.array).cache.array==[[0,1,2],[3,4,5],[6,7,8],[9]]);}

auto take(R)(R r,int i)=>r.chunk(i).front.cache;//escaping reference to stack allocated value... todo
unittest{ assert(counter(10).take(3).array==[0,1,2]);}

auto drop(R)(R r,int i){//should be made with takemap but idk
	while( ! r.empty && i>0){
		i--;
		r=r.pop;
	}
	return r;
}
unittest{ assert([1,2,3,4,5].torange.drop(3).cache.array==[4,5]);}

auto backwards(R)(R r)=>r.reindex!(i=>r.opDollar-i-1);
unittest{ assert([1,2,3].toshape.backwards[].cache.array==[3,2,1]);}

//auto splitter(alias F,R)(R r)=>r.takemap!(a=>a.enumerate.filter!F.key.replacewhen!(a=>a==0)(-1));
//unittest{ "hi,foo,bar,,,,".ascii.splitter!(a=>a==',').print;} //still broken opps

/* todo
joiner
chain
strip left/right
pad leftright
center
*/