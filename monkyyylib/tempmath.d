import basic;
T abs(T)(T a){
	if(a>0){return a;}
	return -a;
}
auto dis(Vector2 a,Vector2 b){
	return abs(a.x-b.x)+abs(a.y-b.y);
}
T lerp(T)(T a, T b, float t){
	return a + (b - a) * t;
}

T inverseLerp(T)(T a, T b, T value){
	if (a != b) {
		return (value - a) / (b - a);
	} else {
		return a;
	}
}

S remap(T,S)(T value, T fromLow, T fromHigh, S toLow, S toHigh){
	auto t=inverseLerp(fromLow, fromHigh, value);
	return lerp(toLow, toHigh, t);
}
T clamp(T)(ref T v,T l,T h){
	if(v<l)v=l;
	if(v>h)v=h;
	return v;
}