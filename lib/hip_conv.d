//module hip.util.conv;
//import hip.util.string;
//import std.typecons;
//import std.traits:isArray, isCallable;
//public import hip.util.to_string_range;
//public import hip.util.string:toStringz;

/*
Copyright: Marcelo S. N. Mancini (Hipreme|MrcSnm), 2018 - 2021
License:   [https://creativecommons.org/licenses/by/4.0/|CC BY-4.0 License].
Authors: Marcelo S. N. Mancini

	Copyright Marcelo S. N. Mancini 2018 - 2021.
Distributed under the CC BY-4.0 License.
   (See accompanying file LICENSE.txt or copy at
	https://creativecommons.org/licenses/by/4.0/
*/



version(WebAssembly) version = UseDRuntimeDecoder;
//version(CustomRuntimeTest) version = UseDRuntimeDecoder;
//version(PSVita) version = UseDRuntimeDecoder;

pure int indexOf (TString)(inout TString str,inout TString toFind, int startIndex = 0) nothrow @nogc @safe
{
    if(!toFind.length)
        return -1;
    int left = 0;

    for(int i = startIndex; i < str.length; i++)
    {
        if(str[i] == toFind[left])
        {
            left++;
            if(left == toFind.length)
                return (i+1) - left; //Remember that left is already out of bounds
        }
        else if(left > 0)
            left--;
    }
    return -1;
}

pure bool startsWith(TString)(inout TString str, inout TString withWhat) nothrow @nogc @safe
{
    if(withWhat.length > str.length)
        return false;
    int index = 0;
    while(index < withWhat.length && str[index] == withWhat[index])
        index++;
    return index == withWhat.length;
}

/**
*   Same thing as startsWith, but returns the part after the afterWhat
*/
pure string after(TString)(TString str, immutable TString afterWhat) nothrow @nogc @safe
{
    bool has = str.startsWith(afterWhat);
    if(!has)
        return null;
    return str[afterWhat.length..$];
}

pure inout(TString) findAfter(TString)(inout TString str, inout TString afterWhat, int startIndex = 0) nothrow @nogc @safe
{
    int afterWhatIndex = str.indexOf(afterWhat, startIndex);
    if(afterWhatIndex == -1)
        return null;
    return str[afterWhatIndex+afterWhat.length..$];
}

/**
*   Returns the content that is between `left` and `right`:
```d
string test = `string containing a "thing"`;
writeln(test.between(`"`, `"`)); //thing
```
*/
pure inout(TString) between(TString)(inout TString str, inout TString left, inout TString right, int start = 0) nothrow @nogc @safe
{
    int leftIndex = str.indexOf(left, start);
    if(leftIndex == -1) return null;
    int rightIndex = str.indexOf(right, leftIndex+1);
    if(rightIndex == -1) return null;

    return str[leftIndex+1..rightIndex];
}

pure int indexOf(TChar)(inout TChar[] str, inout TChar ch, int startIndex = 0) nothrow @nogc @trusted
{
    char[1] temp = [ch];
    return indexOf(str, cast(TChar[])temp, startIndex);
}


TString repeat(TString)(TString str, size_t repeatQuant)
{
    TString ret;
    for(int i = 0; i < repeatQuant; i++)
        ret~= str;
    return ret;
}

pure int count(TString)(inout TString str, inout TString countWhat) nothrow @nogc @safe
{
    int ret = 0;
    int index = 0;

    //Navigates using indexOf
    while((index = str.indexOf(countWhat, index)) != -1)
    {
        index+= countWhat.length;
        ret++;
    }
    return ret;
}

alias countUntil = indexOf;

int lastIndexOf(TString)(inout TString str,inout TString toFind, int startIndex = -1) pure nothrow @nogc @safe
{
    if(startIndex == -1) startIndex = cast(int)(str.length)-1;

    int maxToFind = cast(int)toFind.length - 1;
    int right = maxToFind;
    if(right < 0) return -1; //Empty string case 
    
    
    for(int i = startIndex; i >= 0; i--)
    {
        if(str[i] == toFind[right])
        {
            right--;
            if(right == -1)
                return i;
        }
        else if(right < maxToFind)
            right++;
    }
    return -1;
}
int lastIndexOf(TChar)(TChar[] str, TChar ch, int startIndex = -1) pure nothrow @nogc @trusted
{
    TChar[1] temp = [ch];
    return lastIndexOf(str, cast(TChar[])temp, startIndex);
}

T toDefault(T)(string s, T defaultValue = T.init)
{
    if(s == "")
        return defaultValue;
    T v = defaultValue;
    try{v = to!(T)(s);}
    catch(Exception e){}
    return v;
}
/+
string fromStringz(const char* cstr) pure nothrow @nogc
{
    import core.stdc.string:strlen;
    size_t len = strlen(cstr);
    return (len) ? cast(string)cstr[0..len] : null;
}
+/
/+
const(char)* toStringz(string str) pure nothrow
{
    return (str~"\0").ptr;
}
+/
pragma(inline, true) char toLowerCase(char c) pure nothrow @safe @nogc 
{
    if(c < 'A' || c > 'Z')
        return c;
    return cast(char)(c + ('a' - 'A'));
}
/+
string toLowerCase(string str)
{
    char[] ret = new char[](str.length);
    for(uint i = 0; i < str.length; i++)
        ret[i] = str[i].toLowerCase;
    return cast(string)ret;
}

pragma(inline, true) char toUpper(char c) pure nothrow @nogc @safe
{
    if(c < 'a' || c > 'z')
        return c;
    return cast(char)(c - ('a' - 'A'));
}

string toUpper(string str) pure nothrow @safe
{
    char[] ret = new char[](str.length);
    for(uint i = 0; i < str.length; i++)
        ret[i] = str[i].toUpper;
    return ret;
}
+/
TChar[][] split(TChar)(TChar[] str, TChar separator) pure nothrow
{
    TChar[1] sep = [separator];
    return split(str, cast(TChar[])sep);
}

TString[] split(TString)(TString str, TString separator) pure nothrow @safe
{
    TString[] ret;
    int last = 0;
    int index = 0;
    do
    {
        index = str.indexOf(separator, index);
        if(index != -1)
        {
            ret~= str[last..index];
        	last = index+= separator.length;
        }
    }
    while(index != -1);
    if(last != index)
        ret~= str[last..$];
    return ret;
}

auto splitRange(TString, TStrSep)(TString str, TStrSep separator) pure nothrow @safe @nogc
{
    struct SplitRange
    {
        TString strToSplit;
        TStrSep sep;
        TString frontStr;
        int lastFound, index;

        bool empty(){return frontStr == null && index == -1 && lastFound == -1;}
        TString front()
        {
            if(frontStr == "") popFront();
            return frontStr;
        }
        void popFront()
        {
            if(index == -1 && lastFound == -1)
            {
                frontStr = null;
                return;
            }
            index = indexOf(cast(TString)strToSplit, cast(TString)sep, index);
            //When finding, take the string[lastFound..index]
            if(index != -1)
            {
                frontStr = strToSplit[lastFound..index];
                lastFound = index+= sep.length;
            }
            //If index not found and there was a last, take the string[lastFound..$]
            else if(lastFound != 0)
            {
                frontStr = strToSplit[lastFound..$];
                lastFound = -1;
            }
            //Just say there is no string
            else
                lastFound = -1;
        }
    }

    return SplitRange(str, separator);
}


bool isNumber(TString)(in TString str) pure nothrow @nogc
{
    if(!str)
        return false;
    bool isFirst = true;
    bool hasDecimalSeparator = false;
    foreach(c; str)
    {
        //Check for negative
        if(isFirst)
        {
            isFirst = false;
            if(c == '-')
                continue;
        }
        //Can only check for '.' once.
        if(!hasDecimalSeparator && c == '.')
            hasDecimalSeparator = true;
        else if(c < '0' || c > '9')
            return false;

    }
    return true;
}

/**
This function will get the number at the end of the string. Used when you have numbered items such as frames:
walk_01, walk_02, etc
```d
"test123".getNumericEnding == "123"
"123abc".getNumericEnding == ""
"123".getNumericEnding == "123"
```
*/
string getNumericEnding(string s)
{
    if(!s)
        return "";
    ptrdiff_t i = cast(ptrdiff_t)s.length - 1;
    while(i >= 0)
    {
        if(!isNumeric(s[i]))
            return s[i+1..$];
        i--;
    }
    return s;
}


pragma(inline, true) bool isUpperCase(TChar)(TChar c) @nogc nothrow pure @safe
{
    return c >= 'A' && c <= 'Z';
}
pragma(inline, true) bool isLowercase(TChar)(TChar c) @nogc nothrow pure @safe
{
    return c >= 'a' && c <= 'z';
}

pragma(inline, true) bool isAlpha(TChar)(TChar c) @nogc nothrow pure @safe
{
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

pragma(inline, true) bool isEndOfLine(TChar)(TChar c) @nogc nothrow pure @safe
{
    return c == '\n' || c == '\r';
}

pragma(inline, true) bool isNumeric(TChar)(TChar c) @nogc nothrow pure @safe
{
    return (c >= '0' && c <= '9') || (c == '-');
}
pragma(inline, true) bool isWhitespace(TChar)(TChar c) @nogc nothrow pure @safe
{
    return (c == ' ' || c == '\t' || c.isEndOfLine);
}

TString[] pathSplliter(TString)(TString str)
{
    TString[] ret;

    TString curr;
    for(uint i = 0; i < str.length; i++)
        if(str[i] == '/' || str[i] == '\\')
        {
            ret~= curr;
            curr = null;
        }
        else
            curr~= str[i];
    ret~= curr;
    return ret;
}


TString trim(TString)(TString str) pure nothrow @safe @nogc
{
    if(str.length == 0)
        return str;
    
    size_t start = 0;
    size_t end = str.length - 1;
    while(start < str.length && str[start].isWhitespace)
        start++;
   
    while(end > 0 && str[end].isWhitespace)
        end--;
    
    return str[start..end+1];
}

TString join(TString)(TString[] args, TString separator = "")
{
	if(args.length == 0) return "";
	TString ret = args[0];
	for(int i = 1; i < args.length; i++)
		ret~=separator~args[i];
	return ret;
}

unittest
{
    assert(join(["hello", "world"], ", ") == "hello, world");
    assert(split("hello world", " ").length == 2);
    assert(toDefault!int("hello") == 0);
    assert(lastIndexOf("hello, hello", "hello") == 7);
    assert(indexOf("hello, hello", "hello") == 0);
    assert(replaceAll("\nTest\n", '\n') == "Test");

    assert(trim(" \n  \thello there  \n \t") == "hello there");
    assert(between(`string containing a "thing"`, `"`, `"`) == "thing");

    assert("test123".getNumericEnding == "123");
    assert("123abc".getNumericEnding == "");
    assert("123".getNumericEnding == "123");
}
/+
string toString(dstring dstr) pure nothrow @safe
{
    try
    {
        string ret;
        foreach(ch; dstr)
            ret~= ch;
        return ret;
    }
    catch(Exception e){return "";}
}
+/
string toString(char[] arr) pure nothrow @trusted @nogc {return cast(string)arr;}
string toString(T)(T[] arr) pure nothrow @safe if(!is(T == char))
{
    string ret = "[";
    for(int i = 0; i < arr.length; i++)
    {
        if(i)
            ret~= ",";
        ret~= toString(arr[i]);
    }
    return ret~"]";
}

/+
string toString(T)(T structOrTupleOrEnum) pure nothrow @safe if(!isArray!T)
{
    static if(isTuple!T)
    {
        alias tupl = structOrTupleOrEnum;
        string ret;
        foreach(i, v; tupl)
        {
            if(i > 0)
                ret~= ", ";
            ret~= to!string(v);
        }
        return T.stringof~"("~ret~")";
    }
    else static if(is(T == struct))//For structs declaration
    {
        import hip.util.reflection;
        static if(__traits(hasMember, T, "toString") && hasUDA!(__traits(getMember, T, "toString"), "format"))
        {
            import hip.util.format;
            return formatFromType(structOrTupleOrEnum);
        }
        else
        {
            alias struct_ = structOrTupleOrEnum;
            string s = "(";
            static foreach(i, alias m; T.tupleof)
            {
                if(i > 0)
                    s~= ", ";
                s~= to!string(struct_.tupleof[i]);
            }
            return T.stringof~s~")";
        }
    }
    else static if(is(T == enum))
    {
        foreach(mem; __traits(allMembers, T))
            if(__traits(getMember, T, mem) == structOrTupleOrEnum)
                return T.stringof~"."~mem;
        return T.stringof~".|MEMBER_NOT_FOUND|";
    }
    else static assert(0, "Not implemented for "~T.stringof);
}
+/


string dumpStructToString(T)(T struc) if(is(T == struct))
{
    string s = "\n(";
    static foreach(i, alias m; T.tupleof)
    {
        s~= "\n\t "~m.stringof~": ";
        s~= toString(struc.tupleof[i]);
    }
    return T.stringof~s~"\n)";
}

/+
T toStruct(T)(string struc) pure nothrow
{
    T ret;
    string[] each;
    string currentArg;

    bool isInsideString = false;
    for(size_t i = 1; i < (cast(int)struc.length)-1; i++)
    {
        if(!isInsideString && struc[i] == ',')
        {
            each~= currentArg;
            currentArg = null;
            if(struc[i+1] == ' ')
            	i++;
            continue;
        }
        else if(struc[i] == '"')
        {
            isInsideString = !isInsideString;
            continue;
        }
        currentArg~= struc[i];
    }
    if(currentArg.length != 0)
        each~=currentArg;

    static foreach(i, m; __traits(allMembers, T))
    {{
        alias member = __traits(getMember, ret, m);
        member = to!(typeof(member))(each[i]);
    }}
    return ret;
}
+/

bool toBool(string str) pure nothrow @safe @nogc {return str == "true";}

///Use that for making toStruct easier
string toString(string str) pure nothrow @safe @nogc {return str;}


string toString(bool b) pure nothrow @safe @nogc
{
    return b ? "true" : "false";
}

TO to(TO, FROM)(FROM f) pure nothrow
{
    static if(is(TO == string))
    {
        static if(is(FROM == const(char)*) || is(FROM == char*))
            return fromStringz(f);
        else static if(is(FROM == enum))
            return toString!FROM(f);
        else
            return toString(f);
    }
    else static if(is(TO == int))
    {
        static if(!is(FROM == string))
            return toInt(f.toString);
        else
            return toInt(f);
    }
    else static if(is(TO == uint) || is(TO == size_t) || is(TO == ubyte) || is(TO == ushort))
    {
        static if(!is(FROM == string))
            return cast(TO)toInt(f.toString);
        else
            return cast(TO)toInt(f);
    }
    else static if(is(TO == float))
    {
        static if(!is(FROM == string))
            return toFloat(f.toString);
        else
            return toFloat(f);
    }
    else static if(is(TO == bool))
    {
        static if(!is(FROM == string))
            return toBool(f.toString);
        else
            return toBool(f);
    }
    else
    {
        static if(!is(FROM == string))
            return toStruct!TO(f.toString);
        else
            return toStruct!TO(f);
    }
}

/// This function can be called at compilation time without bringing runtime
/+
string toString(long x) pure nothrow @safe
{
    enum numbers = "0123456789";
    bool isNegative = x < 0;
    if(isNegative)
        x*= -1;
    size_t div = 10;
    int length = 1;
    int count = 1;
    while(div <= x)
    {
        div*=10;
        length++;
    }
    if(isNegative) length++;
    char[] ret = new char[](length);
    if(isNegative)
        ret[0] = '-';
    div = 10;
    while(div <= x)
    {
        count++;
        ret[length-count]=numbers[cast(size_t)((x/div)%10)];
        div*=10;
    }
    ret[length-1] = numbers[cast(size_t)(x%10)];
    return ret[0..$];
}
+/

string toString(float f) pure nothrow @safe 
{
    if(f != f) return "nan";
    else if(f == -float.infinity) return "-inf";
    else if(f == float.infinity) return "inf";

    bool isNegative = f < 0;
    if(isNegative)
        f = -f;
    
    float decimal = f - cast(int)f;
    string ret = (cast(int)f).toString;
    if(isNegative)
        ret = "-"~ret;
    
    if(decimal == 0)
        return ret;
    ret~= '.';
    long multiplier = 10;
    while(cast(long)(decimal*multiplier) < (decimal*multiplier))
    {
        if(cast(long)(decimal*multiplier) == 0)
        	ret~= '0';
        multiplier*=10;
    }
    return ret ~ (cast(long)(decimal*multiplier)).toString;
}

pure string toString(void* ptr) @safe nothrow
{
    return ptr is null ? "null" : toHex(cast(size_t)ptr);
}


pure string toHex(size_t n) @safe nothrow
{
    enum numbers = "0123456789ABCDEF";
    int preAllocSize = 1;
    ulong div = 16;
    while(div <= n)
    {
        div*= 16;
        preAllocSize++;
    }
    div/= 16;
    char[] ret = new char[](preAllocSize);
    int i = 0;

    while(div >= 16)
    {
        ret[i++] = numbers[(n/div)%16];
        div/= 16;
    }
    ret[i] = numbers[n%16];
    return ret[0..$];
}


string fromUTF16(wstring str) pure nothrow
{
    string ret;
    foreach(c;str) ret~= c;
    return ret;
}

int toInt(string str) pure nothrow @safe @nogc
{
    if(str.length == 0) return 0;
    str = str.trim;

    int i = (cast(int)str.length)-1;

    int last = 0;
    int multiplier = 1;
    int ret = 0;
    if(str[0] == '-')
    {
        last++;
        multiplier*= -1;
    }
    for(; i >= last; i--)
    {
        if(str[i] >= '0' && str[i] <= '9')
            ret+= (str[i] - '0') * multiplier;
        else
            return ret;
        multiplier*= 10;
    }
    return ret;
}


float toFloat(string str) pure nothrow @safe @nogc
{
    if(str.length == 0) return 0;
    str = str.trim;
    if(str == "nan" || str == "NaN") return float.init;
    if(str == "inf" || str == "infinity" || str == "Infinity") return float.infinity;

    int integerPart = 0;
    int decimalPart = 0;
    int i = 0;    
    bool isNegative = str[0] == '-';
    if(isNegative)
        str = str[1..$];
    bool isDecimal = false;
    for(; i < str.length; i++)
    {
        if(str[i] =='.')
        {
            isDecimal = true;
            continue;
        }
        if(isDecimal)
            decimalPart++;
        else
            integerPart++;
    }
    
    if(decimalPart == 0)
        return (isNegative ? -1 : 1) * cast(float)str.toInt;

    i = 0;
    float decimal= 0;
    float integer  = 0;
    int integerMultiplier = 1;
    float floatMultiplier = 1.0f/10.0f;

    while(integerPart > 0)
    {
        //Iterate the number from backwards towards the greatest value
        integer+= (str[integerPart - 1] - '0') * integerMultiplier;
        integerMultiplier*= 10;
        integerPart--;
        i++;
    }
    i++; //Jump the .
    while(decimalPart > 0)
    {
        decimal+= (str[i] - '0') * floatMultiplier;
        floatMultiplier/= 10;
        decimalPart--;
        i++;
    }
    return (integer + decimal) * (isNegative ? -1 : 1);
}
