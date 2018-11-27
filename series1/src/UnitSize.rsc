module UnitSize

import Prelude;
import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;

// Our own modules
import Utils;
import PrettyPrint;

public str getUnitSizeFromAST(int totalLOC, map[str, int] ranks) {
	return determineRiskRank(totalLOC, ranks);
}

public str determineRiskRank(int totalLOC, map[str, int] ranks) {

	int sum = ranks["simple"] + ranks["moderate"] + ranks["high"] + ranks["very high"];
	
	// Given that we do not count class declerations for unit complexity, sum must be smaller than totalLOC. 
	if (sum < totalLOC) {
		real percentageSimple   = calculatePercentage(ranks["simple"],    totalLOC);
		real percentageModerate = calculatePercentage(ranks["moderate"],  totalLOC);
		real percentageHigh 	= calculatePercentage(ranks["high"],      totalLOC);
		real percentageVeryHigh = calculatePercentage(ranks["very high"], totalLOC);
		
		str finalRanking = finalRiskFromDist(percentageModerate, percentageHigh, percentageVeryHigh, ranks["very high"]);
		
		// Pretty print descriptive statistics during calculation
		prettyPrintUnitSize(percentageSimple, percentageModerate, percentageHigh, percentageVeryHigh, totalLOC, sum, finalRanking);
		
		return finalRanking;
	} else {
		return "Error: Something went wrong in determining the risk rank";
	}	
}

public str finalRiskFromDist(real moderate, real high, real veryHigh, int veryHighLines) {
		if (veryHighLines > 0) {
			// Guaranteed to be at least a '-' system
			
			if (moderate <= 50 && high <= 15 && veryHigh <= 5) {
				return "-";
			}
			return "--";
		} else if (moderate <= 25 && high <= 10) {
			return "++";
		}
		else if (moderate <= 30 && high <= 5) {
			return "+";
		}
		else if (moderate <= 40 && high <= 10) {
			return "o";
		}
		else if (moderate <= 50 && high <= 15) {
			return "-";
		}	
		return "Error: Something went wrong in determining the risk rank";
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