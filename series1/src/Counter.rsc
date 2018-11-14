module Counter

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import Prelude;

// As reported by:
/* 
	Heitlager, I., Kuipers, T., & Visser, J. (2007, September). 
	A practical model for measuring maintainability. In null (pp. 30-39). IEEE.
	
	"Simple line of code metric (LOC), which counts all lines of source code that are not comments or blank lines."
*/

// HACK 
// A Declaration method has
// Type \return, str name, list[Declaration] parameters, list[Expression] exception, and Statement impl
// If we visit the declaration for each location and see where it falls under our project (l.scheme == project);
// We add these to a set, where there can be no duplicates
// The size of this set will be equal to the number of begin and end lines.   
public int countL(Declaration d) {
    set[int] methodLines = {};
	visit(d) {
		case /loc l: {
			if (l.scheme == "project") {
				methodLines += {l.begin.line};
				methodLines += {l.end.line};
			}
		}
	}
	return size(methodLines);
}

public int countAllLOC(M3 mmm){
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	list[str] lines = [*readFileLines(e) | e <- my_classes];
	list[str] filteredLines = [];
	
	
	for(line <- lines){
		bool blockComment = false;
		line = trim(line);
		
		if(line == ""){
			continue;
		}
	
		if(/^\/\// := line){
			continue;
		}
		
		if(/^\/\*/ := line){
			blockComment = true;
			continue;
		}
		
		if(/^\*\// := line){
			blockComment = false;
			continue;
		}
		
		if(blockComment){
			continue;
		}
		
		filteredLines += line;
	}
	
	return size(filteredLines);
}