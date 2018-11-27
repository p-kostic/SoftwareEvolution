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

public str getCyclomaticFromAST(int totalLOC, map[str, tuple[int cc, int lines]] ranks) {
	println("#----------------------# Cyclomatic Complexity #---------------------------#");
	str finalResult = determineRiskRank(totalLOC, ranks);
	println("# Final System Rank for Complexity per unit: \'<finalResult>\'");
	println("#--------------------------------------------------------------------------#");
	return finalResult;
}

public str determineRiskRank(int totalLOC, map[str, tuple[int cc, int lines]] ranks) {

	int sum = ranks["simple"].lines + ranks["moderate"].lines + ranks["high"].lines + ranks["very high"].lines;
	
	// Given that we do not count class declerations for unit complexity, sum must be smaller than totalLOC. 
	if (sum < totalLOC) {
		real percentageSimple   = calculatePercentage(ranks["simple"].lines,    totalLOC);
		real percentageModerate = calculatePercentage(ranks["moderate"].lines,  totalLOC);
		real percentageHigh 	= calculatePercentage(ranks["high"].lines,      totalLOC);
		real percentageVeryHigh = calculatePercentage(ranks["very high"].lines, totalLOC);
		
		// Pretty print descriptive statistics during calculation
		prettyPrintDistribution(percentageSimple, percentageModerate, percentageHigh, percentageVeryHigh, totalLOC, sum);
		
		return finalRiskFromDist(percentageModerate, percentageHigh, percentageVeryHigh, ranks["very high"].lines);
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









