module CycComplexity
import Prelude;
import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;

// Our own modules
import Counter;

// Tuple data structure to keep track.
tuple[str name, int cc, int lines] simple   = <"simple"    , 0, 0>;
tuple[str name, int cc, int lines] moderate = <"moderate"  , 0, 0>;
tuple[str name, int cc, int lines] high     = <"high"      , 0, 0>;
tuple[str name, int cc, int lines] veryHigh = <"very high", 0, 0>;   

void getCyclomaticFromAST() {	
	// Create model and ASTs
	M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);
	set[Declaration] asts = createAstsFromEclipseProject(|project://SimpleJava|, true);

	// Get the cyclomatic complexity of each unit. Visit is bottom-up by default
	visit(asts) {
		// TODO: does this include constructors???
		case m:method(_,name,_,_,impl): {
			int cc = cyclomaticComplexity(impl);
			str level = determineCCAndLevelPerUnit(cc);
			int sloc = countL(m);
			println("Method <name> with <sloc> lines of code");
			addLOCToTuples(level, countL(m));
		}
	};
	
	println(simple);
	println(moderate);
	println(high);
	println(veryHigh);
	println(determineRiskRank());
}

str determineRiskRank() {
	
	M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);
	int totalLOC = countAllLOC(mmm);
	println("Total Project LOC: <totalLOC>");
	// For each risk leve, calculate what percentage of lines of code it is
	
	// To be rated as a '++' system
	// -- No more than 25% LOC with moderate risk
	// -- No more than 0% LOC with high risk 
	// -- No more than 0% LOC with very high risk
	
	// To be rated as a '+' system
	// -- No more than 30% LOC with moderate risk
	// -- No more than 5% LOC with high risk
	// -- No more than 0% LOC with very high risk
	
	// To be rated as a 'o' system
	// -- No more than 40% LOC with moderate risk 
	// -- No more than 10% LOC with high risk
	// -- No more than 0% LOC with very high risk
	
	// To be rated as a '-' system
	// -- No more than 50% LOC with moderate risk
	// -- No more than 15% LOC with high risk
	// -- No more than 5% LOC with very high risk
	
	// To be rated as a '--' system 
	// -- Even worse than the above
	
	// TODO: percent from math library returns int... so is it precise enough for our usecase? 
	int percentageSimple   = percent(simple.lines  , totalLOC);
	int percentageModerate = percent(moderate.lines, totalLOC);
	int percentageHigh 	   = percent(high.lines    , totalLOC);
	int percentageVeryHigh = percent(veryHigh.lines, totalLOC);
	
	int percentageTotal = percentageSimple + percentageModerate + percentageHigh + percentageVeryHigh;
	println("Percentage Distribution: simple: <percentageSimple>%, moderate: <percentageModerate>%, high: <percentageHigh>%, very high: <percentageVeryHigh>%");
	println("Total percentage: <percentageTotal>%, should be 100%");
	
	
	// TODO, dit moet beter kunnen, minder complexity (ironic lol)
	if (veryHigh.lines > 0) {
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
		veryHigh.cc += 1;
		return "very high";
	}
	else if (unitComplexity > 20) {
		high.cc += 1;
		return "high";
	}
	else if (unitComplexity > 10) {
		moderate.cc += 1;
		return "moderate";
	}
	else if (unitComplexity >= 0) {
		simple.cc += 1;
		return "simple";
	}
	return ""; // Should not happen
}

void addLOCToTuples(str level, int unitCount) {
	switch (level) {
		case "very high": veryHigh.lines += unitCount;
		case "high"		: high.lines     += unitCount;
		case "moderate" : moderate.lines += unitCount;	
		case "simple"   : simple.lines   += unitCount;
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









