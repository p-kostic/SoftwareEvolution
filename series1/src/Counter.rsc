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
*/

//  simple line of code metric (LOC), which counts all lines of source code that are not comment or blank lines


// A Declaration method has
// Type \return, str name, list[Declaration] parameters, list[Expression] exception, and Statement impl
// If we visit the decleration and see where it falls under our project (l.scheme == project);
// We add these to a set, where there can be no duplicates  
public int countL(Declaration d) {
    set[int] methodLines = {};
	visit(d) {
		case /loc l: {
			if (l.scheme == "project") {
				iprintln(l.begin.line);
				iprintln(l.end.line);
				methodLines += {l.begin.line};
				methodLines += {l.end.line};
			}
		}
	}
	return size(methodLines);
}