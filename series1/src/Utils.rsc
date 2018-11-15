module Utils

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import Prelude;
import IO;

// As reported by:
/* 
	Heitlager, I., Kuipers, T., & Visser, J. (2007, September). 
	A practical model for measuring maintainability. In null (pp. 30-39). IEEE.
	
	"Simple line of code metric (LOC), which counts all lines of source code that are not comments or blank lines."
*/
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

public int countAllLOC(M3 mmm) {
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	list[str] lines = [*readFileLines(e) | e <- my_classes];	
	return size(filterLines(lines));
}

public int countL(Declaration d) {
    loc source = d.src;
	list[str] lines = readFileLines(source);
    return size(filterLines(lines));
}