module PrettyPrint

import util::Math;
import Prelude;
import Utils;

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
		println("# Final System Rank for Complexity per unit: \'<finalResult>\'");
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
		println("# Final System Rank for Unit Size: \'<finalResult>\'");
		println("#--------------------------------------------------------------------------#");
}