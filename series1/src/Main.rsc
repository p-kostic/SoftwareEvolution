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
import Metrics::Parameters;

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
	
	// Data for Cyclomatic Complexity and Unit Size
	// Calculating risk levels is different for CC and Unit Size, so we need two seperate maps
	map[str, int] ranksCC       = ("simple": 0, "moderate"  : 0, "high" : 0,"very high" : 0);				        
	map[str, int] ranksUnitSize = ("simple": 0, "moderate"  : 0, "high" : 0,"very high" : 0);
	
	// Data for the paremeter metric				        
	int methodCount = 0;
	int totalParameterCount = 0;

	visit(asts) {
		case m:method(_,name,params,_,impl): {
			int cc 			       = cyclomaticComplexity(impl);
			int sloc 		       = countL(m);
			str levelCC 	       = determineCCAndLevelPerUnit(cc);
			str levelUnitSize      = determineRankForLines(sloc);
			ranksCC[levelCC]       += sloc;
			ranksUnitSize[levelUnitSize] += sloc;
			methodCount += 1;
			totalParameterCount += size(params);
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

	Rank CycCompScore = getCyclomaticFromASTData(totalLOC, ranksCC);        // Complexity per unit
	Rank unitSizeScore = getUnitSizeFromASTData(totalLOC, ranksUnitSize);   // Unit Size
	list[real] maintainabilityRankings = calculateFinalRank(volumeRank, duplicateScore, CycCompScore, unitSizeScore);
	
	real averageParametersPerUnit = totalParameterCount / toReal(methodCount);
	Rank parameterRank = getParameterRank(averageParametersPerUnit);	// Parameters
	
	prettyPrintFinalResults(volumeRank, duplicateScore, CycCompScore, unitSizeScore);
	prettyPrintMaintainability(maintainabilityRankings);
}
