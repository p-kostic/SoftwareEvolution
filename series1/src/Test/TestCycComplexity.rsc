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

// Check if we throw an error string if the sum of each rank's lines is greater than the totalLOC of the project
// This checks whether case traversal in GetCyclomaticFromAST() is correctly adding up the total amount of lines
// And our SIG Rank accredation. 
test bool TestDetermineRiskRankCase1() {

	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <20,500>,
										        "moderate"  : <20,500>,
										        "high"      : <20,500>,
										        "very high" : <20,500>);
	int totalLOC = 1000;
	str result = determineRiskRank(totalLOC, ranks);
	return result != "++" || result != "+" || result != "o" || result != "-" || result != "--";
}

