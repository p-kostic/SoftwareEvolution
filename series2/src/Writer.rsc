module Writer
import lang::csv::IO;
import Prelude;
import util::Math;

void OutputData(list[set[loc]] classes, loc destination){
//	id,parent,parent,beginLine,beginColumn,endLine,endColumn,CCid
//	/src/,,1,1,1,1,0
//	Test.java,/src/, 2,1,2,24,0
//	Program.java,/src/,2,1,2,24,0
	
	rel[int order, str id, str parent, int beginLine, int beginColumn, int endLine, int endColumn, int CCid] result = {};
	int i = 0;
	for(class <- classes){
		for(l <- class){
			list[str] pathSegments = [s | s <- split("/", l.path), s != ""];
			pathSegments = pathSegments + [toString(l.begin.line)];
			println(pathSegments);
			result += GetHierarchy(pathSegments);
			
			str id = pathSegments[size(pathSegments) - 1];
			str parent = pathSegments[size(pathSegments) - 2];
			
			result += <size(pathSegments) - 1, id, parent, l.begin.line, l.begin.column, l.end.line, l.end.column, i>;
		}
		i += 1;
	}
	
	writeCSV(result, destination);
}

rel[int order, str id, str parent, int beginLine, int beginColumn, int endLine, int endColumn, int CCid] GetHierarchy(list[str] pathSegments){
	rel[int order, str id, str parent, int beginLine, int beginColumn, int endLine, int endColumn, int CCid] result = {};
	
	for(int i <- [(size(pathSegments) - 2)..0]){
		tup = <i, pathSegments[i], pathSegments[i - 1], 0,0,0,0, -1>;
		result += tup;
	}
	// Always add the root node
	result += <0, pathSegments[0], "", 0, 0, 0, 0, -1>;
	return result;
}