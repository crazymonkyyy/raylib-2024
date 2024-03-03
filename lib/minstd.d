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

range interface:
front
pop
empty
index
opindex
opdollar
opsilce
len
maxlen
indexisnull
*/

/* fundemental functions */

//tuple - combine elements into a unit
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
}
auto totuple(T)(T a) if(is(typeof(a.istuple)))=>a;
auto totuple(T)(T a) if( ! is(typeof(a.istuple)))=>tuple(a);
//seq - type list
alias seq(T...)=T;
unittest{
	seq!(int,float) foo=tuple(1,1.35);
}
//swap - swaps 2 elements
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
//min - min of 2 elements casts 2nd one
auto min(T,S)(T a,S b){
	if(a<b){return a;}
	return cast(T)b;
}
//max
auto max(T,S)(T a,S b){
	if(a>b){return a;}
	return cast(T)b;
}
//tochar -turn int into a char
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

struct nullable(T){
	T me; alias me this;
	bool isnull=true;
}


/* data structures */

//[]torange
auto torange(T)(T[] array...){
	struct range{
		T[] array;
		int index;
		auto front()=>array[index];
		auto pop()=>range(array,index+1);
		auto empty()=>index>=array.length;
		auto opIndex(T)(T i)=> array[i];
		auto opDollar()=>cast(int)array.length;
		auto opSilce(T,S)(T i,S j)=>range(array[0..j],i);
		auto len()=>array.length;
		//maxlen
		bool indexisnull(int i)=>i<0||i>array.length;
	}
	return range(array);
}
unittest{
	//torange(1,2,3).print;
	//[1,2,3,4,5].torange.print;
}
//T[S] torange
auto torange(T,S)(T[S] array){
	struct range{
		T[S] array;
		int i;
		auto front()=>array[index];
		auto pop()=>range(array,i+1);
		auto empty()=>array.length<=i;
		auto index()=>array.keys[i];
		auto opIndex(T)(T i)=>array[i];
		//auto opDollar()=>array.keys[$-1]; //idk complicated to do, even if I have a 'incorrect' idea its cutting
		//opsilce
		auto len()=>array.length-i;
		//maxlen
		//bool indexisnull(T)(T i)
	}
	return range(array);
}
unittest{
	[1:'a',2:'b'].torange.print;
}
//unicode
//ascii
//nullable array
//counter
struct counter{
	int end;
	int front=0;
	counter pop()=>counter(end,front+1);
	bool empty()=>end<=front;
	int opIndex(int i)=>max(front,min(i,end-1));
	auto len()=>max(0,end-front);
	auto opDollar()=>end;
	bool indexisnull(int i)=>!(front<=i&&i<end);
}
unittest{
	auto foo=counter(10);
	assert(foo.front==0);
	assert(foo.indexisnull(10)==true);
	foo=foo.pop;
	assert(foo.front==1);
}
unittest{
	static assert(isrange!counter);
}

/* core algorithms */

//print
void print(R)(R r) if(isrange!R){
	'('.print;
	while( ! r.empty){
		r.front.print;
		r=r.pop;
	}
	")\n".print;
}
void print(E)(E e) if ( ! isrange!E){
	import std.stdio;
	write(e,',');
}
void forceprint(R)(R r){
	import std;
	r.writeln;
	while( ! r.empty){
		"next".writeln;
		r.front.writeln; 
		"attempting pop".writeln;stdout.flush;
		r=r.pop;
	}
}
//unittest{
//	counter(5).print;
//}
//map
auto map(alias F,R)(R r){
	struct Map{
		R r;
		auto front()=> F(r.front);
		auto pop()=>Map(r.pop);
		auto empty()=>r.empty;
		auto index()()=>r.index;
		auto opIndex(T)(T i)=> F(r[i]);
		auto opDollar(int i)()=>r.opDollar;
		
		//opsilce
		auto len()()=>r.len;
		//maxlen
		//indexisnull
	}
	return Map(r);
}
unittest{
	auto foo=counter(10,5).map!(a=>a*a);
	//foo.print;
	assert(foo[7]==49);
	assert(foo[$-2]==64);
}
//filter
auto filter(alias F,R)(R r){
	struct Filter{
		R r;
		auto front()=>r.front;
		auto pop(){
			auto o=r.pop;
			while( ! o.empty && F(o)){o=o.pop;}
			return Filter(o);
		}
		auto empty()=>r.empty;
		auto index()()=>r.index;
		auto opIndex(T)(T i)=>r[i];
		auto opDollar(int i)()=>r.opDollar;
		auto opSilce()()=>this[r.index..$];
		auto opSlice()(typeof(r.index) l, typeof(r.index) h){
			auto o=this;
			while(o.indexisnull(l)){
				l++;
			}
			return Filter(r[l..h]);
		}
		auto maxlen()()=>r.len;
		bool indexisnull(T)(T i)=> ! F(r[i..$]);
	}
	return Filter(r);//[];//todo detect array vs non array types to prime
}
unittest{
	counter(10).filter!(a=>a.front%2).print;
	//counter(10).filter!(a=>a.index==4).print; errors out... i geuss thats correct?
	counter(10).cache.filter!(a=>a.index==4).print;
	counter(10).cache.filter!(a=>a.index==4)[3..5].print;
}
//acc
//last
auto last(R)(R r){
	auto store=r;
	r=r.pop;
	while( ! r.empty){
		store=r;
		r=r.pop;
	}
	return store;
}
unittest{
	//counter(10).filter!(a=>a.front!=5).last.print;
}
//cache
auto cache(R)(R r){
	typeof(r.front)[] o;
	static if(is(r.maxlen)){
		o.capsity=r.maxlen;
	}
	static if(is(r.len)){
		o.capsity=r.len;
	}
	while( ! r.empty){
		o~=r.front;
		r=r.pop;
	}
	return o.torange;
}
unittest{
	//counter(10,5).cache[2].print;
}

auto takemap(alias F,R,A...)(R r,A args){
	struct Takemap{
		R r;
		A args;
		nullable!int curlength;
		auto front(){
			if(r.empty){
				return r[0..0];
			}
			if(curlength.isnull){
				r=r.pop;
			}
			return r[0..curlength];
		}
		auto pop(){
			auto o=this;
			if( ! curlength.isnull){
				o=o[0..curlength];
			}
			loop:
			auto temp=F(o,o.args).totuple;
			o.curlength=temp[0];
			o.args=temp[1..$]; 
			if(o.curlength>0){
				return;
			}
			if(o.curlength<0){
				o.r=o.r[-o.curlength..$];
				goto loop;
			}
		}//todo
		//empty
		//index
		//opindex
		//opdollar
		//opsilce
		//len
		//maxlen
		//indexisnull
	}
	return Takemap(r,args);
}
//todo test

//reindex
//slide
//zip

/* composate algorthims*/