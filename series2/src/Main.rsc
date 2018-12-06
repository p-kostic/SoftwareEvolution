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
	
	println(size(asts));
	list[map[node,node]] buckets = Preprocess(asts);
	// iprintln(buckets);
	list[int] dist = [size(a) | a <- buckets];
	iprintln(dist);
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
				int nn = countNodes(n);
				
				// Ignore small subtrees
				if(nn > 2){
					int index = nn % bucketThreshold;
					result[index] = result[index] + (n:n);				
				}
				
			}
		}
	}
	return result;
}

void CompareBucket(map[node,node] bucket){
	r = toList(bucket);
	fullRelation = r * r;
	
	
}


int countNodes(node ast) {
	int count = 0;
	visit(ast) {
		case node n: {
			count += 1;}
	}
	return count;
}

real similarity(node tree1, node tree2) {
	// Visit the subtree of the argument nodes
	// Copy them to lists t1 and t2, such that
	// We can calculate similarity scores from there
	
	list[node] t1 = [];
	list[node] t2 = [];
	
	visit(tree1) {
		case node x:
			t1 += x;
	}
	visit(tree2) {
		case node x:
			t2 += x; 
	}
	
	real s = toReal(size(t1 & t2));
	real l = toReal(size(t1 - t2));
	real r = toReal(size(t2 - t1));
	
	return (2 * s) / (2 * s + l + r);
}