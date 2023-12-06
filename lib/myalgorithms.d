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
