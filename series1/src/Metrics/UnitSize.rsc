module Metrics::UnitSize

import Prelude;
import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;

// Our own modules
import Services::Utils;
import Services::PrettyPrint;
import Services::Ranking;

public Rank getUnitSizeFromAST(int totalLOC, map[str, int] ranks) {
	return determineRiskRank(totalLOC, ranks);
}

public Rank determineRiskRank(int totalLOC, map[str, int] ranks) {

	int sum = ranks["simple"] + ranks["moderate"] + ranks["high"] + ranks["very high"];
	
	// Given that we do not count class declerations for unit complexity, sum must be smaller than totalLOC. 
	if (sum < totalLOC) {
		real percentageSimple   = calculatePercentage(ranks["simple"],    totalLOC);
		real percentageModerate = calculatePercentage(ranks["moderate"],  totalLOC);
		real percentageHigh 	= calculatePercentage(ranks["high"],      totalLOC);
		real percentageVeryHigh = calculatePercentage(ranks["very high"], totalLOC);
		
		Rank finalRanking = finalRiskFromDist(percentageModerate, percentageHigh, percentageVeryHigh, ranks["very high"]);
		
		// Pretty print descriptive statistics during calculation
		prettyPrintUnitSize(percentageSimple, percentageModerate, percentageHigh, percentageVeryHigh, totalLOC, sum, finalRanking);
		
		return finalRanking;
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

