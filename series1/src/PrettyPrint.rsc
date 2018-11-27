module PrettyPrint

import util::Math;
import Prelude;

void prettyPrintDistribution(real simple, real moderate, real high, real veryHigh, int totalLOC, int sum) {
		real percentageTotal = simple + moderate + high + veryHigh;
		println("# For a codebase with <totalLOC> total lines of code, <sum> belongs to units");
		println("# Rank Distribution:");
		println("# - Simple:    <simple>%");
		println("# - Moderate:  <moderate>%");
		println("# - High:      <high>%");
		println("# - Very High: <veryHigh>%");
		println("# Total percentage: <percentageTotal>% of the codebase consists of units");
}