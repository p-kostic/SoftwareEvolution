module Test::TestCycComplexity

import Prelude;
import CycComplexity;
import Utils; 
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

test bool TestGetCyclomaticFromAST() {
	// Gather arguments
	loc fileLocation = |project://SimpleJava/src/Test.java|;
	M3 mmm = createM3FromFile(fileLocation);
	Declaration ast = createAstFromFile(fileLocation, true);
	set[Declaration] asts = {ast};
	int totalLOC = countAllLOC(mmm);
	
	// We know what the risk rank is for such a simple case and we can
	// calculate it by hand. As such, our test is done by measuring against the
	// expected value.
	return getCyclomaticFromAST(mmm, asts, totalLOC) == "++";
}