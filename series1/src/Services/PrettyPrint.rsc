module Services::PrettyPrint

import util::Math;
import Prelude;
import Services::Utils;
import Services::Ranking;

void prettyPrintBegin() {
	println("#-------------------------# Beginning Analysis... #------------------------#");
	println("#--------------------------------------------------------------------------#");
}

void prettyPrintCycComplexity(real simple, real moderate, real high, real veryHigh, int totalLOC, int sum, Rank finalResult) {
		real percentageTotal = simple + moderate + high + veryHigh;
		
		println("#----------------------# Cyclomatic Complexity #---------------------------#");
		println("# For a codebase with <totalLOC> total lines of code, <sum> belongs to units");
		println("# Rank Distribution:");
		println("# - Simple:    <simple>%");
		println("# - Moderate:  <moderate>%");
		println("# - High:      <high>%");
		println("# - Very High: <veryHigh>%");
		println("# Total percentage: <percentageTotal>% of the codebase consists of units");
		println("# Final System Rank for Complexity per unit: \'<RankToString(finalResult)>\'");
		println("#--------------------------------------------------------------------------#");
}

void prettyPrintDuplication(int windowsize, int totalLOC, int duplicatePercentage, Rank rank){
	println("#---------------------------# Duplication #--------------------------------#");
	println("# For a codebase with <totalLOC> lines");
	println("# With a window size of         <windowsize>");
	println("# Overall Duplicate percentage: <duplicatePercentage>%");
	println("# Duplication rank of \'<RankToString(rank)>\'");
	println("#--------------------------------------------------------------------------#");
}

void prettyPrintUnitSize(real simples, real moderate, real high, real veryHigh, int totalLOC, int sum, Rank finalResult) {
	real percentageTotal = simples + moderate + high + veryHigh;

	println("#-----------------------------# Unit Size #--------------------------------#");
	println("# For a codebase with <totalLOC> total lines of code, <sum> belongs to units");
	println("# Rank Distribution:");
	println("# - Simple:    <simples>%");
	println("# - Moderate:  <moderate>%");
	println("# - High:      <high>%");
	println("# - Very High: <veryHigh>%");
	println("# Total percentage: <percentageTotal>% of the codebase consists of units");
	println("# Final System Rank for Unit Size: \'<RankToString(finalResult)>\'");
	println("#--------------------------------------------------------------------------#");
}

void prettyPrintFinalResults(Rank volumeRank, Rank duplicateScore, Rank CycCompScore, Rank unitSizeScore) {
	println("#-------------------------# Final Results #--------------------------------#");
	println("# Volume:              \'<RankToString(volumeRank)>\'");
	println("# Duplication:         \'<RankToString(duplicateScore)>\'");
	println("# Complexity per unit: \'<RankToString(CycCompScore)>\'");
	println("# Unit Size:           \'<RankToString(unitSizeScore)>\'");
	println("#--------------------------------------------------------------------------#");
}

// [analysability, changeability, testability, overall]
void prettyPrintMaintainability(list[real] maintainabilityRanking) {
	println("#--------------------# Maintainability Report #----------------------------#");
	println("# Analysability of <maintainabilityRanking[0]> --\> \'<RankToString(toInt(round(maintainabilityRanking[0])))>\'");
	println("# Changeability of <maintainabilityRanking[1]> --\> \'<RankToString(toInt(round(maintainabilityRanking[1])))>\'");
	println("# Testability of   <maintainabilityRanking[2]> --\> \'<RankToString(toInt(round(maintainabilityRanking[2])))>\'");
	println("#");
	println("# Overall:         <maintainabilityRanking[3]> --\> \'<RankToString(toInt(round(maintainabilityRanking[3])))>\'");
	println("#--------------------------------------------------------------------------#");
}

void prettyPrintExtraMetrics(real paramPerUnit, Rank paramRank){
	println("#-------------------------# Extra Metrics #--------------------------------#");
	println("# Parameters --------------------------------------------------------------#");
	println("# Average Per Unit: <paramPerUnit>");
	println("# Rank:            \'<RankToString(paramRank)>\'");
	println("#--------------------------------------------------------------------------#");
}