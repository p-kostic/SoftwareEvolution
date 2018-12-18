module Test::TestMain

import Main;
import Prelude;
import IO;
import Node;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

test bool TestPreprocess(){
	// Mass  = 3
	node ast1 = makeNode("a", "", [makeNode("b"), makeNode("c"), src=|project://asdfasdf|], ("src":|project://asdf|));
	println(getKeywordParameters(ast1));
	
	// Mass = 1
	node ast2 = makeNode("a", [], ("src":|project://asdf|));
	println(getKeywordParameters(ast2));
	// Mass = 5
	node ast3 = makeNode("a", [makeNode("b", [makeNode("d"), makeNode("e")]), makeNode("c")], ("src":|project://asdf|));
	
	set[node] asts = {ast1, ast2, ast3};
	int massThreshold = 2;
	
	bucketMapping = Preprocess(asts, massThreshold);
	
	println(bucketMapping);
	
	return size(bucketMapping) == 2;	
}