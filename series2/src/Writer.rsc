module Writer
import lang::csv::IO;

void OutputData(list[set[loc]] classes, loc destination){
	rel[int id, str path, int beginLine, int beginColumn, int endLine, int endColumn] result = {};
	int i = 0;
	for(class <- classes){
		for(l <- class){
			result += <i, l.path, l.begin.line, l.begin.column, l.end.line, l.end.column>;
		}
		i += 1;
	}
	
	writeCSV(result, destination);
}