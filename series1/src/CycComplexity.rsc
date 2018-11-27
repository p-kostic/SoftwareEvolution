module CycComplexity

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

public Rank getCyclomaticFromAST(int totalLOC, map[str, int] ranks) {
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
		prettyPrintCycComplexity(percentageSimple, percentageModerate, percentageHigh, percentageVeryHigh, totalLOC, sum, finalRanking);
		
		return finalRanking;
	} else {
		return "Error: Something went wrong in determining the risk rank";
	}
}

public Rank finalRiskFromDist(real moderate, real high, real veryHigh, int veryHighLines) {
		Rank result = -100; // -100 if there is an error
		if (veryHighLines > 0) {
			// Guaranteed to be at least a '-' system
			
			if (moderate <= 50 && high <= 15 && veryHigh <= 5) {
				result = -1;
			}
			result = -2;
		} else if (moderate <= 25 && high <= 10) {
			result = 2;
		}
		else if (moderate <= 30 && high <= 5) {
			result = 1;
		}
		else if (moderate <= 40 && high <= 10) {
			result = 0;
		}
		else if (moderate <= 50 && high <= 15) {
			result = -1;
		}	
		return result;
}

str determineCCAndLevelPerUnit(int unitComplexity) {
	if (unitComplexity > 50) {
		return "very high";
	}
	else if (unitComplexity > 20) {
		return "high";
	}
	else if (unitComplexity > 10) {
		return "moderate";
	}
	else if (unitComplexity >= 0) {
		return "simple";
	}
}

/* Source:
   Landman, D., Serebrenik, A., Bouwers, E., & Vinju, J. J. (2016). 
   Empirical analysis of the relationship between CC and SLOC in a
   large corpus of Java methods and C functions. 
   Journal of Software: Evolution and Process, 28(7), 589-618. 
*/ 
int cyclomaticComplexity(Statement impl){
	int result = 1;
	visit(impl) {
		case \if(_,_): 	          result += 1;
	    case \if(_,_,x):          result += 1;
	    case \case(_):            result += 1;
	    case \do(_,_):            result += 1;
	    case \while(_,_):         result += 1;
	    case \for(_,_,_):         result += 1;
	    case \for(_,_,_,_):       result += 1;
	    case \foreach(_,_,_):     result += 1;
	    case \catch(_,_):         result += 1;
	    case \conditional(_,_,_): result += 1;
	    case infix(_,"&&",_):     result += 1;
	    case infix(_,"||",_):     result += 1;
	    default: 				  result += 0;
	};
	return result;
}









