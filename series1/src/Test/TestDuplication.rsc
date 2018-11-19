module Test::TestDuplication
import util::Math;

import Duplication;
import Prelude;


// Full duplication, windowsize = 1
test bool TestRabinKarpCase0() {
	// 10 elements
	list[str] lines = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"];
	
	int duplicateLines = RabinKarp(lines, 1);
	int percentage = toInt(toReal(duplicateLines) / 10 * 100);
	return percentage == 90;
}

test bool TestRabinKarpCase1() {
	// 10 elements
	list[str] lines = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1"];
	
	int duplicateLines = RabinKarp(lines, 6);
	int percentage = toInt(toReal(duplicateLines) / 10 * 100);

	return percentage == 40;
}

test bool TestRabinKarpCase2() {
	list[str] lines = ["1", "1", "1", "0", "1", "1", "1"];
	int duplicateLines = RabinKarp(lines,3);
	return duplicateLines == 3;
}

test bool TestRabinKarpCase3() {
	list[str] lines = ["1", "1", "0", "0", "1","1","2","2", "0","2","2"];
	int duplicateLines = RabinKarp(lines,2);
	println(duplicateLines);
	return duplicateLines == 4;
}