module Main
import IO;
import Prelude;
import String;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Metric modules
import Metrics::Volume;
import Metrics::CycComplexity;
import Metrics::UnitSize;
import Metrics::Duplication;

// Other own modules
import Services::Utils;
import Services::PrettyPrint;
import Services::Ranking;

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
	
	// Volume
	Rank volumeRank = GetVolumeRank(totalLOC);
	
	// Calculate duplicate metrics
	Rank duplicateScore = GetDuplicateRank(lines, 6, totalLOC);
		
	map[str, int] ranksCC       = ("simple": 0, "moderate"  : 0, "high" : 0,"very high" : 0);				        
	map[str, int] ranksUnitSize = ("simple": 0, "moderate"  : 0, "high" : 0,"very high" : 0);
																	        
	
	visit(asts) {
		case m:method(_,name,_,_,impl): {
			int cc 			       = cyclomaticComplexity(impl);
			int sloc 		       = countL(m);
			str levelCC 	       = determineCCAndLevelPerUnit(cc);
			str levelUnitSize      = determineRankForLines(sloc);
			ranksCC[levelCC]       += sloc;
			ranksUnitSize[levelUnitSize] += sloc;
		}
		case c:constructor(name, _, _, impl): {
			int cc                 = cyclomaticComplexity(impl);
			int sloc               = countL(c);
			str levelCC            = determineCCAndLevelPerUnit(cc);
			str levelUnitSize      = determineRankForLines(sloc);
			ranksCC[levelCC]       += sloc;
			ranksUnitSize[levelUnitSize] += sloc;
		}
		case i:initializer(impl): {
			int cc                 = cyclomaticComplexity(impl);
			int sloc               = countL(i);
			str levelCC            = determineCCAndLevelPerUnit(cc);
			str levelUnitSize      = determineRankForLines(sloc);
			ranksCC[levelCC]       += sloc;
			ranksUnitSize[levelUnitSize] += sloc;
		}
	}

	// Complexity per unit
	Rank CycCompScore = getCyclomaticFromAST(totalLOC, ranksCC);
	
	// Unit Size
	Rank unitSizeScore = getUnitSizeFromAST(totalLOC, ranksUnitSize);
	
	println("#-------------------------# Final Results #--------------------------------#");
	println("# Volume:              \'<RankToString(volumeRank)>\'");
	println("# Duplication:         \'<RankToString(duplicateScore)>\'");
	println("# Complexity per unit: \'<RankToString(CycCompScore)>\'");
	println("# Unit Size:           \'<RankToString(unitSizeScore)>\'");
	println("#--------------------------------------------------------------------------#");
	calculateFinalScore(volumeRank, duplicateScore, CycCompScore, unitSizeScore);
}

// Note: Equal weights
// Analysability: Volume, Duplication, Unit Size, Unit Testing = total of 4 (3 no bonus)
// Changeability: Complexity, Duplication					   = total of 2 
// Stability:     Unit Testing								   = total of 1 (0 no bonus)
// Testability:   Complexity, Unit Size, Unit Testing		   = total of 2 (2 no bonus)
void calculateFinalScore(Rank volumeRank, Rank duplicateRank, Rank cycCompScore, Rank unitSizeRank) {
	real volumeRankInt    = toReal(volumeRank);
	real duplicateRankInt = toReal(duplicateRank);
	real cycRankInt       = toReal(cycCompScore); 
	real unitSizeRankInt  = toReal(unitSizeRank);
	
	real analysability = (1 / 3.0) * duplicateRankInt + (1 / 3.0) * volumeRankInt +  (1/ 3.0) * unitSizeRankInt;
	real changeability = 0.5 * cycRankInt + 0.5 * duplicateRankInt;
	real testability   = 0.5 * cycRankInt + 0.5 * unitSizeRankInt;
	real overall       = (1/ 3.0) * analysability + (1 / 3.0) * changeability + (1 / 3.0) * testability; 
	
	println("#--------------------# Maintainability Report #----------------------------#");
	println("# Analysability of <analysability>   --\> \'<RankToString(toInt(round(analysability)))>\'");
	println("# Changeability of <changeability> --\> \'<RankToString(toInt(round(changeability)))>\'");
	println("# Testability of   <testability> --\> \'<RankToString(toInt(round(testability)))>\'");
	println("#");
	println("# Overall:         <overall>  --\> \'<RankToString(toInt(round(overall)))>\'");
	println("#--------------------------------------------------------------------------#");
}
