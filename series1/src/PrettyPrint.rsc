module PrettyPrint

import util::Math;
import Prelude;

void prettyPrintCycComplexity(real simple, real moderate, real high, real veryHigh, int totalLOC, int sum, str finalResult) {
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

void prettyPrintDuplication(real windowsize, real LOC, real percentage){

}

void prettyPrintUnitSize(real simples, real moderate, real high, real veryHigh, int totalLOC, int sum, str finalResult) {
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