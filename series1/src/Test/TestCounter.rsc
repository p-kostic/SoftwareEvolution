module Test::TestCounter

import Prelude;
import Counter;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

bool TestFilterLines() {
	// A case where all 3 things we check for in the implementation occur
	list[str] goodLinesToFilter = ["a",			   // 1
							       "b",			   // 2
							       "// Comment",   // -- ignore
							       "c",			   // 3
								   "d",			   // 4
								   "",			   // -- ignore
								   "e",			   // 5 
								   "f",	    	   // 6
								   "g",			   // 7
								   "/*",		   // -- ignore
								   "commentBlock", // -- ignore
								   "*/",		   // -- ignore
								   "a",			   // 8
								   "b"			   // 9
								   ];
	bool case1 = size(filterLines(goodLinesToFilter)) == 9;
	
	// A case with a JavaDoc example with stars for the multiline comment
	list[str] javaDoc = [
		"/**************",
		"* Brief description. Full description of the method, generally without",
		"* implementation details.",
		"* \<p\>",
		"* Note: Additional information, e.g. your implementation notes or remarks.",
		"* \</p\>*",
		"* @param input description of the parameter",
		"* @return description of return value",
		"*", 
		"* @since version",
		"* @author name of the author",
		"*/",
		"public boolean doSomething(String input)", // 1
		"{",                                        // 2
		"   // your code",
		"}",                                        // 3
		"/* TestComment */"
	];
	bool case2 = size(filterLines(javaDoc)) == 3;
	
	// An edgecase where the comment is commented out.
	list[str] edgeCase = [
		"// /*",            // ignore
		"some_code();",	    
		"// */"];			// ignore
	bool case3 = size(filterLines(edgeCase)) == 1;
			
	return case1 && case2 && case3;
}

