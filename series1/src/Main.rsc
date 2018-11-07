module Main
import IO;
import Prelude;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

void countMethods(){
	M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	my_methods = (e : size(declaredMethods(mmm)[e]) | e <- my_classes);
	for(m <- my_methods)
		println("<m> : <my_methods[m]>");
}