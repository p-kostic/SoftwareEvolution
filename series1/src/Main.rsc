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

// loc project = |project://SimpleJava|;
loc project = |project://smallsql0.21_src|;
// loc project = |project://hsqldb-2.3.1|;
// loc project = |project://src|;

void Main(){
	prettyPrintBegin();
	
	list[str] lines = getLinesOfCode(project);
	int totalLOC = size(lines);
	set[Declaration] asts = createAstsFromEclipseProject(project, true);
	
	Rank volumeRank = GetVolumeRank(totalLOC);                  // Volume
	Rank duplicateScore = GetDuplicateRank(lines, 6, totalLOC); // Calculate duplicate metrics
	
	// Calculating risk levels is different for CC and Unit Size, so we need two seperate maps
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

	Rank CycCompScore = getCyclomaticFromAST(totalLOC, ranksCC);        // Complexity per unit
	Rank unitSizeScore = getUnitSizeFromAST(totalLOC, ranksUnitSize);   // Unit Size
	
	prettyPrintFinalResults(volumeRank, duplicateScore, CycCompScore, unitSizeScore);
	
	list[real] maintainabilityRankings = calculateFinalRank(volumeRank, duplicateScore, CycCompScore, unitSizeScore);
	prettyPrintMaintainability(maintainabilityRankings);
}
