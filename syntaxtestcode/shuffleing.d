import std;
int rng(T)(int max,auto ref T seed) {
	const uint mod = 0x7FFFFFFF; // 2^31 - 1
	const uint mul = 0x41C64E6D; // 16,807
	seed = (seed * mul) % mod;
	return cast(int)(seed % max);
}
int rng_(T)(int max,T seed) {
	const uint mod = 0x7FFFFFFF; // 2^31 - 1
	const uint mul = 0x41C64E6D; // 16,807
	seed = (seed * mul) % mod;
	return cast(int)(seed % max);
}
void swap(T)(ref T a, ref T b){
	T t=a;
	a=b;
	b=t;
}
ref T[] shuffle(T)(ref T[] array,ulong seed){
	foreach(i;0..array.length){
		swap(array[i],array[i..$][rng_(cast(int)$,seed)]);
	}
	return array;
}
//ref T[] partshuffle(T)(ref T[] array,float part,ulong seed){
//	foreach(i;0..array.length){
//		swap(array[i],array[i..$][rng_(cast(int)($*part)+1,seed)]);
//	}
//	return array;
//}
ref T[] shufflereverse(T)(ref T[] array,ulong seed){
	foreach_reverse(i;0..array.length){
		swap(array[i],array[i..$][rng_(cast(int)$,seed)]);
	}
	return array;
}
ref T[] inverseshuffle(alias F,T)(ref T[] array,ulong seed){
	auto indexes=iota(array.length).array;
	F(indexes,seed);
	bool finished=false;
	while( ! finished){
		finished=true;
		foreach(i;0..array.length){
			if(indexes[i]!=i){
				finished=false;
				swap(array[indexes[i]],array[i]);
				swap(indexes[indexes[i]],indexes[i]);
			}
		}
	}
	return array;
}
ref T[] nonsenseshuffle(T)(ref T[] array,ulong seed){
	foreach(i;0..array.length){
		swap(array[i],array[i..$][rng_(cast(int)$,seed)]);
	}
	swap(array[3],array[6]);
	swap(array[4],array[7]);
	swap(array[5],array[8]);
	swap(array[6],array[9]);
	return array;
}
ref T[] partshuffle(T)(ref T[] array,float part,ulong seed){
	bool[] store;//todo change to ringarray
	store.length=array.length;
	foreach(i;0..array.length){
		array.writeln;
		auto j=rng(min(cast(int)(array.length*part),array.length-i),seed);
		if(store[i]){continue;}
		swap(array[i],array[i..$][j%$]);
		store[min(i+j,$-1)]=true;
	}
	return array;
}
void main(){
	int[] a=[1,2,3,4,5,6,7,8,9,10];
	a.shuffle(100).inverseshuffle!shuffle(100).writeln;
	a.nonsenseshuffle(100).inverseshuffle!nonsenseshuffle(100).writeln;
	a.partshuffle(.5,101).writeln;
}