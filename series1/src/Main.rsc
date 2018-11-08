module Main
import IO;
import Prelude;
import Duplication;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

loc project = |project://SimpleJava|;

void Main(){
	M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	list[str] lines = [*readFileLines(e) | e <- my_classes];
	filteredLines = [trim(e) | e <- lines, !isEmpty(trim(e))];
	println(filteredLines);
	println(FindDuplicates(filteredLines, 2));

}


void countMethods(){
	M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	my_methods = (e : size(declaredMethods(mmm)[e]) | e <- my_classes);
	for(m <- my_methods)
		println("<m> : <my_methods[m]>");
}


