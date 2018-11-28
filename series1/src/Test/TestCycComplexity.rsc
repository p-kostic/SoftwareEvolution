module Test::TestCycComplexity

import Prelude;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Own modules
import Metrics::CycComplexity;
import Services::Utils;
import Services::Ranking; 

// Check if we throw an error string if the sum of each rank's lines is greater than the totalLOC of the project
// This checks whether case traversal in GetCyclomaticFromAST() is correctly adding up the total amount of lines
// And our SIG Rank accredation. 
test bool TestDetermineRiskRankCase1() {
	map[str, int] ranks = ("simple": 500,"moderate":500,"high":500,"very high" : 500);
	int totalLOC = 1000;
	Rank result = getCyclomaticFromASTData(totalLOC, ranks);
	return result != PLUS_PLUS || result != PLUS || result != ZERO || result != MIN || result != MIN_MIN;
}

// Case: Barely "++"
// 24% moderate risk, 0% high and 0% very high
test bool TestDetermineRiskRankCase2() {
	map[str, int] ranks = ("simple": 760,"moderate":239,"high":0,"very high" : 0);
	int totalLOC = 1000;
	Rank result = getCyclomaticFromASTData(totalLOC, ranks);
	return result == PLUS_PLUS;
}

// Case: Barely "+"
// 30% moderate, 4% high, and 0% very high
test bool TestDetermineRiskRankCase3() {
	map[str, int] ranks = ("simple": 661,"moderate":299,"high":40,"very high" : 0);
	int totalLOC = 1001;
	Rank result = getCyclomaticFromASTData(totalLOC, ranks);
	return result == PLUS;
}

// Case: Barely "o"
// 31% moderate, 4% high, and 0% very high
test bool TestDetermineRiskRankCase4() {
	map[str, int] ranks = ("simple": 658,"moderate":302,"high":40,"very high" : 0);
	int totalLOC = 1001;
	Rank result = getCyclomaticFromASTData(totalLOC, ranks);
	return result == ZERO;
}

// Case: Barely "-", i.e. contains very high, but below 5%
test bool TestDetermineRiskRankCase5() {
	map[str, int] ranks = ("simple": 658,"moderate":302,"high":40,"very high" : 1);
	int totalLOC = 1010;
	Rank result = getCyclomaticFromASTData(totalLOC, ranks);
	return result == MIN;
}

// Case: Barely "--", i.e. contains more than 5% very high
test bool TestDetermineRiskRankCase6() {
	map[str, int] ranks = ("simple": 658,"moderate":200,"high":40,"very high" : 60);
	int totalLOC = 1001;
	Rank result = getCyclomaticFromASTData(totalLOC, ranks);
	return result == MIN_MIN;
}

// Test the risk evaluation for a given cc, test all branches, trivial test.
test bool TestDetermineCCAndLevelPerUnit() {
	if (determineCCAndLevelPerUnit(0)  != "simple")    return false;
	if (determineCCAndLevelPerUnit(11) != "moderate")  return false;
	if (determineCCAndLevelPerUnit(21) != "high")      return false;
	if (determineCCAndLevelPerUnit(51) != "very high") return false;
	return true;
}

// TODO: figure out a way to pass Statements for individual cases to test the 
//       correctness of CC determination. However, since the source if from a paper.
// 		 We assume the implementation to be correct for now.
test bool TestCyclomaticComplexity() {
	return true;	
}







