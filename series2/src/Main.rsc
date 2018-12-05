module Main

import IO;
import Prelude;
import String;
import util::Math;
import Node;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Own modules
import utils::HelperFunctions;

// loc project = |project://SimpleJava|;
loc project = |project://smallsql0.21_src|;
// loc project = |project://src|; // <------ project://hsqldb-2.3.1, 
                                  // but only the src folder as specified in the assignment documentation

void Main() {
	list[str] lines = getLinesOfCode(project);
	int totalLOC = size(lines);
	set[Declaration] asts = createAstsFromEclipseProject(project, true);
	
	list[list[Declaration]] buckets = Preprocess(asts);
}

// Buckets of sub trees
list[list[Declaration]] Preprocess(set[Declaration] asts) {
	
	int totalNodes = 0;
	for (ast <- asts) {
		totalNodes += countNodes(ast);	
	}
	
	int bucketThreshold = toInt(totalNodes * 0.1); // 10% of N buckets
	list[list[Declaration]] result = [[] | s <- [1..bucketThreshold] ];
	
	for (ast <- asts) {
		visit(ast) {
			case Node: {
				int index = countNodes(ast) / bucketThreshold;
				result[index] = result[index] + ast;
			}
		}
	}
	return result;
}

int countNodes(Declaration ast) {
	int count = 0;
	visit(ast) {
		case Node: 
			count += 1;
	}
	return count;
}