//note: bad
char temp;
char* where;
char* tocstring(string s){
	where=cast(char*)(&s[0])[s.length];
	temp=*where;
	return cast(char*)(&s[0]);
}
string tocstring_(string s){
	s.tocstring;
	return s;
}
void restorestring(){
	*where=temp;
}