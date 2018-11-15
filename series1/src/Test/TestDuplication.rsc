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
	println(duplicateLines);
	int percentage = toInt(toReal(duplicateLines) / 10 * 100);

	return percentage == 90;
}

test bool TestRabinKarpCase2() {
	list[str] lines = ["A", "B", "C", "A", "B", "C"];
	
	int duplicateLines = RabinKarp(lines, 2);
	println(duplicateLines);
	int percentage = toInt(toReal(duplicateLines) / 6 * 100);

	return percentage == 50;
}