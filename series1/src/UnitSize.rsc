module UnitSize
import Prelude;
import IO;
import CycComplexity;
import Utils;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;

public str getUnitSizeFromAST(set[Declaration] asts, int totalLOC) {
	
	map[str, int] ranks = ("simple": 0, "moderate"  : 0, "high" : 0,"very high" : 0);
	
	visit(asts) {
		case m:method(_,name,_,_,impl): {
			int sloc = countL(m);
			str level = determineRankForLines(sloc);
			ranks[level]+= sloc;
		}
		case c:constructor(name, _, _, impl): {
			int sloc = countL(c);
			str level = determineRankForLines(sloc);
			ranks[level] += sloc;
		}
		case i:initializer(impl): {
			int sloc = countL(i);
			str level = determineRankForLines(sloc);
			ranks[level] += sloc;
		}
	}
	str finalResult = determineRiskRank(totalLOC, ranks);
	println("# Final System Rank for Unit Size: \'<finalResult>\'");
	println("#--------------------------------------------------------------------------#");
	return finalResult;
}

public str determineRiskRank(int totalLOC, map[str, int] ranks) {

	int sum = ranks["simple"] + ranks["moderate"] + ranks["high"] + ranks["very high"];
	if (sum < totalLOC) {
		real percentageSimple   = toReal(ranks["simple"])    / toReal(totalLOC) * 100;
		real percentageModerate = toReal(ranks["moderate"])  / toReal(totalLOC) * 100;
		real percentageHigh 	= toReal(ranks["high"])      / toReal(totalLOC) * 100;
		real percentageVeryHigh = toReal(ranks["very high"]) / toReal(totalLOC) * 100;
		
		real percentageTotal = percentageSimple + percentageModerate + percentageHigh + percentageVeryHigh;
		
		println("#-----------------------------# Unit Size #--------------------------------#");
		println("# For a codebase with <totalLOC> total lines of code, <sum> belongs to units");
		println("# Rank Distribution:");
		println("# - Simple:    <percentageSimple>%");
		println("# - Moderate:  <percentageModerate>%");
		println("# - High:      <percentageHigh>%");
		println("# - Very High: <percentageVeryHigh>%");
		println("# Total percentage: <percentageTotal>% of the codebase consists of units");

		if (ranks["very high"] > 0) {
			// Guaranteed to be at least a '-' system
			
			if (percentageModerate <= 50 && percentageHigh <= 15 && percentageVeryHigh <= 5) {
				return "-";
			}
			return "--";
		} else if (percentageModerate <= 25 && percentageHigh <= 10) {
			return "++";
		}
		else if (percentageModerate <= 30 && percentageHigh <= 5) {
			return "+";
		}
		else if (percentageModerate <= 40 && percentageHigh <= 10) {
			return "o";
		}
		else if (percentageModerate <= 50 && percentageHigh <= 15) {
			return "-";
		}	
		return "Error: Something went wrong in determining the risk rank";
	} else {
		return "Error: Something went wrong in determining the risk rank";
	}
	
}

str determineRankForLines(int lines) {
	if (lines > 60) {
		return "very high";
	}
	else if (lines > 30) {
		return "high";
	}
	else if (lines > 15) {
		return "moderate";
	}
	else if (lines >= 0) {
		return "simple";
	}
}