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

void Main(){
	println("#-------------------------# Beginning Analysis... #------------------------#");
	println("#--------------------------------------------------------------------------#");
	// Global Variables
	M3 mmm = createM3FromEclipseProject(project);
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	int totalLOC = countAllLOC(mmm);
	set[Declaration] asts = createAstsFromEclipseProject(project, true);
	
	// Volume
	str volumeRank = GetVolumeRank(totalLOC);
	
	// Calculate duplicate metrics
	list[str] lines = filterLines([*readFileLines(e) | e <- my_classes]);
	str duplicateScore = GetDuplicateScore(lines, 6, totalLOC);
	
	// Complexity per unit
	str CycCompScore = getCyclomaticFromAST(mmm, asts, totalLOC);
	
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
	
	real analysability = (1 / 3) * duplicateRankInt + (1 / 3) * volumeRankInt +  (1 / 3) * unitSizeRankInt;
	real changeability = 0.5 * cycRankInt + 0.5 * duplicateRankInt;
	real testability   = 0.5 * cycRankInt + 0.5 * unitSizeRankInt;
	real overall       = (1/ 3) * analysability + (1 / 3) * changeability + (1 / 3) * testability; 
	
	println("#--------------------# Maintainability Report #----------------------------#");
	println("# Analysability of <analysability>   --\> \'<intToRank(toInt(analysability))>\'");
	println("# Changeability of <changeability> --\> \'<intToRank(toInt(changeability))>\'");
	println("# Testability of   <testability> --\> \'<intToRank(toInt(testability))>\'");
	println("#");
	println("# Overall:         <overall>  --\> \'<intToRank(toInt(overall))>\'");
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
			return "Error, not --, -, o, +, or ++";  
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

