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
import Map;
import Set;

// Own modules
import utils::HelperFunctions;
import Comparison;

// loc project = |project://SimpleJava|;
loc project = |project://smallsql0.21_src|;
// loc project = |project://src|; // <------ project://hsqldb-2.3.1, 
                                  // but only the src folder as specified in the assignment documentation
loc csvDestination = |project://series2/src/data.csv|;
void Main() {

	set[Declaration] asts = createAstsFromEclipseProject(project, true);
	
	map[int, list[node]] buckets = Preprocess(asts, 25);
	
	// Print the bucket distribution
	list[int] dist = [size(buckets[a]) | a <- buckets];
	iprintln(dist);
	
	map[node, set[loc]] resultClones = Process(buckets);
	
	println("Start filtering subclones");
	resultClones = filterSubclones(resultClones);
	println("End filtering");
	
	calculateAndPrettyPrintMetrics(resultClones, project, csvDestination);
}

map[node, set[loc]] Process(map[int, list[node]] buckets){
	map[node, set[loc]] resultClones = ();
	list[int] keys = sort(domain(buckets));

	// Variables for statistics
	datetime begin = now(); // Measure process time
	int s = size(buckets);  // Measure how many buckets left
	int counter = 0;	
	
	// Traverse the buckets, biggest nodes first
	for(i <- [(size(keys) - 1)..-1]){
		Duration runningTime = createDuration(begin,now());
		println("<counter>/<s> with size <size(buckets[keys[i]])> and time <toString(runningTime.minutes)>:<(runningTime.seconds)>");
		resultClones = CompareBucket(buckets[keys[i]], resultClones);
		counter += 1;
	}
	
	return resultClones;
}


// Returns a mapping from (node_size : [nodes])
// Every node is compared to each other node in the same bucket
// This means that only nodes of equal size are compared.
map[int, list[node]] Preprocess(set[node] asts, int massThreshold){
	map[int, list[node]] buckets = ();
	
	for (ast <- asts) {
		visit(ast){
			case node n: {
				if(("src" in getKeywordParameters(n))){
					int nn = countNodes(n);
					
					if(nn > massThreshold){
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

	// Filter out all singular buckets (they can't compare to anything then themselves)	
	map[int, list[node]] filteredBuckets = (b : buckets[b] | b <- buckets, size(buckets[b]) > 1);
	return filteredBuckets;
}

map[node, set[loc]] filterSubclones(map[node, set[loc]] clones){
	int i = 0;
	for(a <- clones){
		bool subClone = false;
		loc testLoc = takeOneFrom(clones[a])[0];
		
		for(b <- clones){
			if(a == b){continue;}
			
			for(l <- clones[b]){
				subClone = subClone || betweenLocSameFile(l, testLoc);
			}
		}
		
		if(subClone){
			i += 1;
			clones = delete(clones, a);
		}
	}
	println("<i> clones filtered");
	return clones;
}

// True if l2 inbetween l1 for the same file
bool betweenLocSameFile(loc l1, loc l2) {
	// Between
	if (l1.path == l2.path) {
		if (l1.begin.line <= l2.begin.line && l1.end.line >= l2.end.line)
			return true;
	}
	return false;
}

int countNodes(node ast) {
	int count = 0;
	visit(ast) {
		case node n: {
			count += 1;}
	}
	return count;
}

