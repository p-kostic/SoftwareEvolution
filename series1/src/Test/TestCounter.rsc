module Test::TestCounter

import Prelude;
import Counter;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);

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

test bool TestCountAllLOCCase1() {
	// If counted by hand, we get 31 for the SimpleJava project. Check if the implementation is correct
	return countAllLOC(mmm) == 31;
}

test bool TestCountAllLOCCase2() {
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	list[str] lines = [*readFileLines(e) | e <- my_classes];	
	int filteredLines = countAllLOC(mmm);
	return filteredLines > 0 && filteredLines < size(lines); 
}
