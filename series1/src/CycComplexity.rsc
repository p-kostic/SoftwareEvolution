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

str getCyclomaticFromAST(M3 mmm, set[Declaration] asts, int totalLOC) {
	
	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,0>,
										        "moderate"  : <0,0>,
										        "high"      : <0,0>,
										        "very high" : <0,0>);
	
	// Get the cyclomatic complexity of each unit. Visit is bottom-up by default
	visit(asts) {
		// TODO: does this include constructors???
		case m:method(_,name,_,_,impl): {
			int cc = cyclomaticComplexity(impl);
			int sloc = countL(m);
			str level = determineCCAndLevelPerUnit(cc);
			ranks[level].cc    += 1;
			ranks[level].lines += sloc;
			// println("Method <name> with complexity <cc> and <sloc> lines of code");
		}
	};
	// iprintln(ranks);
	return determineRiskRank(totalLOC, ranks);
}

str determineRiskRank(int totalLOC, map[str, tuple[int cc, int lines]] ranks) {
	real percentageSimple   = toReal(ranks["simple"].lines)    / toReal(totalLOC) * 100;
	real percentageModerate = toReal(ranks["moderate"].lines)  / toReal(totalLOC) * 100;
	real percentageHigh 	= toReal(ranks["high"].lines)      / toReal(totalLOC) * 100;
	real percentageVeryHigh = toReal(ranks["very high"].lines) / toReal(totalLOC) * 100;
	
	real percentageTotal = percentageSimple + percentageModerate + percentageHigh + percentageVeryHigh;
	println("Percentage Distribution: simple: <percentageSimple>%, moderate: <percentageModerate>%, high: <percentageHigh>%, very high: <percentageVeryHigh>%");
	println("Total percentage: <percentageTotal>% methods");
	
	if (ranks["very high"].lines > 0) {
		// Guaranteed to be at least a '-' system
		
		if (percentageModerate <= 50 && percentageHigh <= 15 && percentageVeryHigh <= 5) {
			return "-";
		}
		return "--";
	}
	else if (percentageModerate <= 25 && percentageHigh <= 10) {
		return "++";
	}
	else if (percentageModerate <= 30 && percentageHigh <= 5) {
		return "+";
	}
	else if (percentageModerate <= 40 && percentageHigh <= 0) {
		return "-";
	}	
	return "--";
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
	int result = 0;
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









