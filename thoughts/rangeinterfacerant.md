# changing ranges

New std means an opptunity to make breaking changes ranges, this should be siezed and drasticly done.

rough goals:

1. degrade doubly linked lists ("bidirectional") to be less important then arrays, hash maps, strings, databases, litterally any data stucture.

2. different "paths" an ideal array is very different from a skiplist

2. reduce function count of the "ideal" range(lowest depth on current path) if possible

3. incremental improvement of the quality of the range being thoerically possible, first you impliment the main 3 functions, if you use binarny sreach you should only impliment a few functions not 20

4. string iterators are first class ranges and not just bad doublely linked list that get thier own functions

5. helper functions are assumed to exist, such as "popBack" for arrays can just be `auto popBack(R) if (rangeIsGoodArray!R)(R r)=>r[0..$-1];` as opposed to users reimplimenting it every time

6. much much more optional functions

7. allow trees? some ugly hack of aliasSeq's? sumtype[] as entity compoint systems?

## hard clean break

I always hated popFront over pop and if bidirectionality is being degraded the rational of the naming scheme falls apart, having a small easy to wrap change may also have value.

I suggest the fundmental range pattern should be changed to

```d
while(!r.empty){
	r.front.writeln;
	r=r.pop;
}
```

(note pop's change in api, my instincts say that this will help saftyphiles and functional style considerations)

altrunityly:

head/tail/empty
fst/pop/ety ( :D )
head/tail/done

## ideal function lists

while there shouldnt be a tree that forces an exact prototype on an user, I can't think of the mess of all possible datastructures * simple algorthims at the same time; there should be an offical list of "initsatuations" of the range api to clarify: end users appoching implimenting a data stucture, alogorthim writers navagating the api and writing docs, the design.

assume front/pop/empty or whatever the fundmental interface is

array:

* length

* opDollar(alias of length, enforced?)

* index (index should be able to do some set of math operations)

* opSlice(index..index) 

* opSlice(int..int) (if different)

* opIndex(index)

string(unicode):

* maxlength

* minlength

* opDollar(smart type)

* index(programable, char*, char[], int as codepoint count, int as true index)

* opSlice(index..opDollar-int)

* opIndex(index)

Hashmap:

* index (key)

* enum notarray=true(disambiguate T[] and T[int])

* opIndex(index)

* half1/half2 (parrellism primitive)

tree(would this work?):

* front(root)

* pop(sets a "stop using" flag)

* half1/half2 (binarny sreach)

skip list(or some other better linked list):

* ... idk

file io:

* enum avoidcopies=true;

Note these are NOT for a new hierachy, but instead fixed points to constuct a ven diagram.

## estimated lengths

filters and unicode strings have length infomation even if its not a promise; using max length to set a capisity seems extermely sensable to me, minlength + maxlength seems like a good api to me

Filter, **instantly** making your array-like range not random access was quite bad, something should be here.

## tiers of bidirectionality

I think there should be 3 tiers of bidirectionality

1. can find a (nullable) last element(filters, unicode)

2. doubly linked lists

3. slicing with a mathable opDollar

## half1/half2

while hashmaps and databases probaly cant promise exact spilts, its not hard to imagine wanting to parrellize 10,000 elements with an off by 1 error 4999 and 5001 spilt.

Also binary sreach, and maybe trees.

There should be a helper function for arrays so nd/2d arrays don't need to make an extra set of opIdex calls on top of thier 30 they are already writting. that may be a little tricky with 2d indexs(tuple int,int?) but I believe doable

## paths

given a unit cube with vertexs such as (0,0,0) where you can walk in a strictly increasing(swapping 0 to 1) until you get to (1,1,1); you get a graph with a single starting point and single endpoint, but lots(6>2) of flexiblity and complexity inbetween; this is also true to template interfaces where you are adding functions,(if you had 3 functions); Now imagine a 10d-cube and its graph, what happens to poor programmer brains if theres 10 optional range functions(which would be a very optimistic reduction of from the last range interface)

Some of these edges will be colored (such as maxlength should NEVER exist with a length)

There should be some way to think/communicate about a subset of interconnected functions without it being a hierachy(meaning graphs with limited parentage here) I don't know of software for drawing that, uml sux

How think?

## paths, ven diagrams, fixed points; oh my

I don't fault aa for coping stl's flaws, but we have more template features and allot more practice now

Templates are best when they use good interfaces, few constaints and let the logic play out, and this is the most important interface in the std

Definations:

paths: way to communicate to users how to impliment algorthims(static if's of rangeinterfaces) or an acceptable way to impliment a data stucture "isNumbericIndex" would be a question for ranges with indexs, a fork in a road between arrays and hashmap; terminates in fixedpoints

Vendiagram: visual repasation of all range.interface functions with a "is" prefix

Fixedpoints: example datastuctures with a bunch of clarifing assumptions and assertions of where it is in the vendiagram