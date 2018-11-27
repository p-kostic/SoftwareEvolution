module Test::TestUtils

import Prelude;
import Utils;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Simple Java Testing project for the unit tests that need either ASTs or M3s
loc simpleJava = |project://SimpleJava|;

test bool TestFilterLinesCase1() {
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
	return size(filterLines(goodLinesToFilter)) == 9;
}

test bool TestFilterLinesCase2() {
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
	return size(filterLines(javaDoc)) == 3;
}

test bool TestFilterLinesCase3() {
	// An edgecase where the comment is commented out.
	list[str] edgeCase = [
		"// /*",            // ignore
		"some_code();",	    
		"// */"];			// ignore
	return size(filterLines(edgeCase)) == 1;
}

test bool TestFilterLinesCase4() {
	list[str] edgeCase = [
		"/* someCode(); */", // Ignore
		"someCode();",		 // 1
		"someCode();"		 // 2
	];
	return size(filterLines(edgeCase)) == 2;
}

test bool TestFilterLinesCase5(){
	list[str] edgeCase = [
		"/* Comment */ SomeCode();", // 1
		"someCode();" 				 // 2
	];
	return size(filterLines(edgeCase)) == 2;
}

test bool TestFilterLinesCase6(){
	list[str] edgeCase = [
		"\" /* SomeCode();", // 1
		"someCode();*/ \"" 	 // 2
	];
	return size(filterLines(edgeCase)) == 2;
}

test bool TestFilterLinesCase7(){
	list[str] edgeCase = [
		"SomeCode(); /*", 	// 1
		"someCode(); */",
		"SomeCode();"		// 2
	];
	return size(filterLines(edgeCase)) == 2;
}

test bool TestFilterLinesCase8(){
	list[str] edgeCase = [
		"SomeCode(); /* Comment */ SomeCode();", 	// 1
		"SomeCode();"								// 2
	];
	return size(filterLines(edgeCase)) == 2;
}

test bool TestFilterLinesCase9(){
	list[str] edgeCase = [
		"SomeCode(); /* Comment */", 	// 1
		"SomeCode();"					// 2
	];
	return size(filterLines(edgeCase)) == 2;
}

test bool TestCountAllLOCCase1() {
	// If counted by hand, we get 31 for the SimpleJava project. Check if the implementation is correct
	return size(getLinesOfCode(simpleJava)) == 31;
}

//test bool TestCountAllLOCCase2() {
//	// To check if countAllLoc plays nicely with filteredLines,
//	// filteredLines should be in-between size 0 and the maximum size.
//	// countAllLOC is guaranteed to be 
//	int filteredLines = size(getLinesOfCode(simpleJava));
//	return filteredLines > 0 && filteredLines < size(lines); 
//}

// From a simple example, test if it does indeed count everything for this AST
test bool TestCountLCase1() {
	Declaration d = createAstFromFile(|project://SimpleJava/src/Test.java|, true);
	return countL(d) == 5;
}
