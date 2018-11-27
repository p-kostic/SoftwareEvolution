module Utils

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import Prelude;
import IO;
import util::FileSystem;

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
		
		if(/^\/\*/ := line) { 
			blockComment = true;
			if (/\*\// := line)
				blockComment = false;
			continue;
		}
		
		if(/^\*\// := line) {
			blockComment = false;
			continue;
		}
		
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