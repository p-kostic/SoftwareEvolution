module Utils

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import Prelude;
import IO;
import util::FileSystem;


public alias Rating = int;
public Rating PLUS_PLUS = 2;
public Rating PLUS = 1;
public Rating ZERO = 0;
public Rating MIN = -1;
public Rating MIN_MIN = -2;

// Convert the numeric rating to their string representation
public str RatingToString(Rating r){
	str result = "o";
	switch(r){
		case -2: result = "--";
		case -1: result = "-";
		case 0: result = "o";
		case 1: result = "+";
		case 2: result = "++";
	}
	
	return result;
}

// As reported by:
/* 
	Heitlager, I., Kuipers, T., & Visser, J. (2007, September). 
	A practical model for measuring maintainability. In null (pp. 30-39). IEEE.
	
	"Simple line of code metric (LOC), which counts all lines of source code that are not comments or blank lines."
*/
// Given a list of strings, remove all types of comments and whitespace 
public list[str] filterLines(list[str] lines) {
	list[str] filteredLines = [];

	bool blockComment = false;
	
	for(line <- lines) {
		line = trim(line);
		
		if(line == "") {
			continue;
		}
	
		if(/^\/\// := line) {
			continue;
		}
		
		// Line starts with an /*
		if(/^\/\*/ := line) { 
			blockComment = true;
			// same line contains */, such that there is no block covering multiple lines
			if (/\*\// := line) {
				blockComment = false;
			}
		}
		
		// Closing block comment anywhere on line
		if (/\*\// := line) {
			blockComment = false;
		}
		
		// line starts with /* and ends with */, so this line can safely be skipped
		if (/(\*\/)$/ := line) {
			continue;
		}
		
		// Skip every line in a block comment
		if(blockComment) {
			continue;
		}
		
		filteredLines += line;
	}
	return filteredLines;
}

// Gets the filtered LOC for a given mmm (e.g. whole project) 
public list[str] getLinesOfCode(loc projectLocation) {
	set[loc] files = {f | f <- visibleFiles(projectLocation), /\.java/ := f.file};
	list[str] lines = [*readFileLines(f) | f <- files];
	return filterLines(lines);   
}

// Gets the filtered LOC for a given Declaration (e.g. Method)
public int countL(Declaration d) {
    loc source = d.src;
	list[str] lines = readFileLines(source);
    return size(filterLines(lines));
}

// Given two integer, convert them to a Real number calculate the percentage value of the first argument
// relative to the second argument.  
public real calculatePercentage(int part, int total) {
	return toReal(part) / toReal(total) * 100;
}