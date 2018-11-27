module Main
import IO;
import Prelude;
import Duplication;
import String;
import Utils;
import Volume;
import CycComplexity;
import UnitSize;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

//loc project = |project://SimpleJava|;
loc project = |project://smallsql0.21_src|;
//loc project = |project://hsqldb-2.3.1|;
// loc project = |project://src|;

void Main(){
	println("#-------------------------# Beginning Analysis... #------------------------#");
	println("#--------------------------------------------------------------------------#");
	// Global Variables
	
	list[str] lines = getLinesOfCode(project);
	int totalLOC = size(lines);
	set[Declaration] asts = createAstsFromEclipseProject(project, true);
	
	println(totalLOC);
	// Volume
	str volumeRank = GetVolumeRank(totalLOC);
	
	// Calculate duplicate metrics
	str duplicateScore = GetDuplicateScore(lines, 6, totalLOC);
	println(duplicateScore);
	return;
	
	
		
	map[str, tuple[int cc, int lines]] ranks = ("simple"    : <0,0>,
										        "moderate"  : <0,0>,
										        "high"      : <0,0>,
										        "very high" : <0,0>);
	
	visit(asts) {
		case m:method(_,name,_,_,impl): {
			int cc = cyclomaticComplexity(impl);
			int sloc = countL(m);
			str level = determineCCAndLevelPerUnit(cc);
			ranks[level].cc    += 1;
			ranks[level].lines += sloc;
			// println("Method <name> with complexity <cc> and <sloc> lines of code");
		}
		case c:constructor(name, _, _, impl): {
			int cc = cyclomaticComplexity(impl);
			int sloc = countL(c);
			str level = determineCCAndLevelPerUnit(cc);
			ranks[level].cc    += 1;
			ranks[level].lines += sloc;
		}
		case i:initializer(impl): {
			int cc = cyclomaticComplexity(impl);
			int sloc = countL(i);
			str level = determineCCAndLevelPerUnit(cc);
			ranks[level].cc    += 1;
			ranks[level].lines += sloc;
		}
	}

	
	// Complexity per unit

	str CycCompScore = getCyclomaticFromAST(totalLOC, ranks);
	
	// Unit Size
	str unitSizeScore = getUnitSizeFromAST(asts, totalLOC);
	
	println("#-------------------------# Final Results #--------------------------------#");
	println("# Volume:              \'<volumeRank>\'");
	println("# Duplication:         \'<duplicateScore>\'");
	println("# Complexity per unit: \'<CycCompScore>\'");
	println("# Unit Size:           \'<unitSizeScore>\'");
	println("#--------------------------------------------------------------------------#");
	calculateFinalScore(volumeRank, duplicateScore, CycCompScore, unitSizeScore);
}

// Note: Equal weights
// Analysability: Volume, Duplication, Unit Size, Unit Testing = total of 4 (3 no bonus)
// Changeability: Complexity, Duplication					   = total of 2 
// Stability:     Unit Testing								   = total of 1 (0 no bonus)
// Testability:   Complexity, Unit Size, Unit Testing		   = total of 2 (2 no bonus)
void calculateFinalScore(str volumeRank, str duplicateRank, str cycCompScore, str unitSizeRank) {
	real volumeRankInt    = toReal(rankToInt(volumeRank));
	real duplicateRankInt = toReal(rankToInt(duplicateRank));
	real cycRankInt       = toReal(rankToInt(cycCompScore)); 
	real unitSizeRankInt  = toReal(rankToInt(unitSizeRank));
	
	real analysability = (1 / 3.0) * duplicateRankInt + (1 / 3.0) * volumeRankInt +  (1/ 3.0) * unitSizeRankInt;
	real changeability = 0.5 * cycRankInt + 0.5 * duplicateRankInt;
	real testability   = 0.5 * cycRankInt + 0.5 * unitSizeRankInt;
	real overall       = (1/ 3.0) * analysability + (1 / 3.0) * changeability + (1 / 3.0) * testability; 
	
	println("#--------------------# Maintainability Report #----------------------------#");
	println("# Analysability of <analysability>   --\> \'<intToRank(toInt(round(analysability)))>\'");
	println("# Changeability of <changeability> --\> \'<intToRank(toInt(round(changeability)))>\'");
	println("# Testability of   <testability> --\> \'<intToRank(toInt(round(testability)))>\'");
	println("#");
	println("# Overall:         <overall>  --\> \'<intToRank(toInt(round(overall)))>\'");
	println("#--------------------------------------------------------------------------#");
}

int rankToInt(str rank) {
	switch(rank) {
		case "--": 
			return -2;
		case "-": 
			return -1;
		case "o": 
			return 0;
		case "+":
			return 1;
		case "++":
			return 2;
		default:
			return 1000;  
	}
}

str intToRank(int rankInt) {
	switch(rankInt) {
		case -2: 
			return "--";
		case -1: 
			return "-";
		case 0: 
			return "o";
		case 1:
			return "+";
		case 2:
			return "++";
		default:
			return "Error, not -2, -1, 0, 1, or 2";  
	}
}

