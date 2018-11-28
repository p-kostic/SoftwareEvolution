module Test::TestDuplication
import util::Math;

import Metrics::Duplication;
import Prelude;


// Full duplication, windowsize = 1
test bool TestRabinKarpCase0() {
	// 10 elements
	list[str] lines = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"];
	
	int duplicateLines = RabinKarp(lines, 1);
	return duplicateLines == 9;
}

// 6 originals, 4 duplicates (partial window)
test bool TestRabinKarpCase1() {
	// 10 elements
	list[str] lines = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"];
	
	int duplicateLines = RabinKarp(lines, 6);
	return duplicateLines == 4;
}

// Entire window fits
test bool TestRabinKarpCase4() {
	// 12 elements
	list[str] lines = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"];
	
	int duplicateLines = RabinKarp(lines, 6);
	return duplicateLines == 6;
}


test bool TestRabinKarpCase2() {
	list[str] lines = ["1", "1", "1", "0", "1", "1", "1"];
	int duplicateLines = RabinKarp(lines,3);
	return duplicateLines == 3;
}

test bool TestRabinKarpCase3() {
	list[str] lines = ["1", "1", "0", "0", "1","1","2","2", "0","2","2"];
	int duplicateLines = RabinKarp(lines,2);
	return duplicateLines == 4;
}