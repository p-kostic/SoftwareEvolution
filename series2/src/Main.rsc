module Main

import IO;
import Prelude;
import String;
import util::Math;
import Node;
import DateTime;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import Comparison;
import Prelude;
import Map;


// Own modules
import utils::HelperFunctions;

// loc project = |project://SimpleJava|;
loc project = |project://smallsql0.21_src|;
// loc project = |project://src|; // <------ project://hsqldb-2.3.1, 
                                  // but only the src folder as specified in the assignment documentation

void Main() {
	//list[str] lines = getLinesOfCode(project);
	//int totalLOC = size(lines);
	
	datetime begin = now();
	

	set[Declaration] asts = createAstsFromEclipseProject(project, true);
	
	println(size(asts));
	map[int, list[node]] rawbuckets = Preprocess2(asts);
	map[int, list[node]] buckets = (b : rawbuckets[b] | b <- rawbuckets, size(rawbuckets[b]) > 1);
	
	list[int] keys = sort(domain(buckets));
	
	//println(keys);
	//return;
	
	list[int] dist = [size(buckets[a]) | a <- buckets];
	iprintln(dist);
	
	rel[loc,loc] result = {};
	int s = size(buckets);
	int counter = 0;
	for(i <- [(size(keys) - 1)..-1]){
		Duration runningTime = createDuration(begin,now());
		println("<counter>/<s> with size <size(buckets[keys[i]])> and time <toString(runningTime.minutes)>:<(runningTime.seconds)>");
		result += CompareBucket(buckets[keys[i]], result);
		counter += 1;
	}
}

// TODO:
// - Buckets alleen  gelijke grote bevatten van subtrees
//   Dus |b| = |unieke subtree sizes|
map[int, list[node]] Preprocess2(set[Declaration] asts){
	map[int, list[node]] buckets = ();
	
	for (ast <- asts) {
		visit(ast){
			case node n: {
				if(("src" in getKeywordParameters(n))){
					int nn = countNodes(n);
					
					if(nn > 25){
						if(nn in buckets){
							buckets[nn] += n;
						}else{
							buckets = buckets + (nn:[n]);
						}
					}
				}
			}
		}
		
	}
	
	return buckets;
}

// Buckets of sub trees
list[map[node,node]] Preprocess(set[Declaration] asts) {
	
	int totalNodes = 0;
	for (ast <- asts) {
		totalNodes += countNodes(ast);	
	}
	
	// 10% of average max subtree mass buckets
	int bucketThreshold = toInt(totalNodes / size(asts) * 0.1); 
	//int bucketThreshold = 1;
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

