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
import Comparison;
import Prelude;


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
	
	println(size(asts));
	list[map[node,node]] buckets = Preprocess(asts);
	// iprintln(buckets);
	
	CompareBucket(buckets[0]);
	//list[int] dist = [size(a) | a <- buckets];
	//iprintln(dist);
}

// Buckets of sub trees
list[map[node,node]] Preprocess(set[Declaration] asts) {
	
	int totalNodes = 0;
	for (ast <- asts) {
		totalNodes += countNodes(ast);	
	}
	
	// 10% of average max subtree mass buckets
	int bucketThreshold = toInt(totalNodes / size(asts) * 0.1); 
	list[map[node, node]] result = [() | s <- [1..bucketThreshold + 1] ];
	
	//bucketThreshold = 5;
	for (ast <- asts) {
		visit(ast) {
			case node n: {
				if(("src" in getKeywordParameters(n))){
					int nn = countNodes(n);
					
					// Ignore small subtrees and check if the node has a source location
					if(nn > 2){
						int index = nn % bucketThreshold;
						result[index] = result[index] + (n:n);				
						
					}
					
				}
				
			}
		}
	}
	return result;
}




int countNodes(node ast) {
	int count = 0;
	visit(ast) {
		case node n: {
			count += 1;}
	}
	return count;
}

