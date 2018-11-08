module CycComplexity
import Prelude;
import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Our own modules
import Counter;

// Tuple data structure to keep track.
tuple[str name, int cc, int lines] simple   = <"simple"    , 0, 0>;
tuple[str name, int cc, int lines] moderate = <"moderate"  , 0, 0>;
tuple[str name, int cc, int lines] high     = <"high"      , 0, 0>;
tuple[str name, int cc, int lines] veryHigh = <"very hight", 0, 0>;   

void getCyclomaticFromAST() {	
	// Create model and ASTs
	M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);
	set[Declaration] asts = createAstsFromEclipseProject(|project://SimpleJava|, true);

	// Get the cyclomatic complexity of each unit. Visit is bottom-up by default
	visit(asts) {
		// TODO: does this include constructors???
		case m:method(_,_,_,_,impl): {
			int cc = cyclomaticComplexity(impl);
			str level = determineCCAndLevelPerUnit(cc);
					
			addLOCToTuples(level, countL(m));
		}
	};
	
	println(simple);
	println(moderate);
	println(high);
	println(veryHigh);

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









