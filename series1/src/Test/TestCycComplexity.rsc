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

	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,500>,
										        "moderate"  : <0,500>,
										        "high"      : <0,500>,
										        "very high" : <0,500>);
	int totalLOC = 1000;
	str result = determineRiskRank(totalLOC, ranks);
	return result != "++" || result != "+" || result != "o" || result != "-" || result != "--";
}


// Case: Barely "++"
// 24% moderate risk, 0% high and 0% very high
test bool TestDetermineRiskRankCase2() {
	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,760>,
										        "moderate"  : <0,239>,
										        "high"      : <0,0>,
										        "very high" : <0,0>);
	int totalLOC = 1000;
	str result = determineRiskRank(totalLOC, ranks);
	println(result);
	return result == "++";
}

// Case: Barely "+"
// 30% moderate, 4% high, and 0% very high
test bool TestDetermineRiskRankCase3() {
	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,661>,
										        "moderate"  : <0,299>,
										        "high"      : <0,40>,
										        "very high" : <0,0>);
	int totalLOC = 1001;
	str result = determineRiskRank(totalLOC, ranks);
	println(result);
	return result == "+";
}

// Case: Barely "o"
// 31% moderate, 4% high, and 0% very high
test bool TestDetermineRiskRankCase4() {
	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,658>,
										        "moderate"  : <0,302>,
										        "high"      : <0,40>,
										        "very high" : <0,0>);
	int totalLOC = 1001;
	str result = determineRiskRank(totalLOC, ranks);
	println(result);
	return result == "o";
}

// Case: Barely "-", i.e. contains very high, but below 5%
test bool TestDetermineRiskRankCase5() {
	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,658>,
										        "moderate"  : <0,302>,
										        "high"      : <0,40>,
										        "very high" : <0,1>);
	int totalLOC = 1010;
	str result = determineRiskRank(totalLOC, ranks);
	println(result);
	return result == "-";
}

// Case: Barely "--", i.e. contains more than 5% very high
test bool TestDetermineRiskRankCase6() {
	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,658>,
										        "moderate"  : <0,200>,
										        "high"      : <0,40>,
										        "very high" : <0,60>);
	int totalLOC = 1001;
	str result = determineRiskRank(totalLOC, ranks);
	println(result);
	return result == "--";
}

// Test the risk evaluation for a given cc, test all branches, trivial test.
test bool TestDetermineCCAndLevelPerUnit() {
	if (determineCCAndLevelPerUnit(0) != "simple")     return false;
	if (determineCCAndLevelPerUnit(11) != "moderate")  return false;
	if (determineCCAndLevelPerUnit(21) != "high")      return false;
	if (determineCCAndLevelPerUnit(51) != "very high") return false;
	return true;
}

// TODO: figure out a way to pass Statements for individual cases to test the 
//       correctness of CC determination
test bool TestCyclomaticComplexity() {
	return true;	
}







