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
import Set;
import Writer;


// Own modules
import utils::HelperFunctions;

//loc project = |project://SimpleJava|;
loc project = |project://smallsql0.21_src|;
// loc project = |project://src|; // <------ project://hsqldb-2.3.1, 
                                  // but only the src folder as specified in the assignment documentation

loc csvDestination = |project://series2/src/data.csv|;

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
	
	map[node, set[loc]] resultClones = ();
	int s = size(buckets);
	int counter = 0;
	for(i <- [(size(keys) - 1)..-1]){
		Duration runningTime = createDuration(begin,now());
		println("<counter>/<s> with size <size(buckets[keys[i]])> and time <toString(runningTime.minutes)>:<(runningTime.seconds)>");
		resultClones = CompareBucket(buckets[keys[i]], resultClones);
		counter += 1;
		
	}
	
	println("Start filtering subclones");
	resultClones = filterSubclones(resultClones);
	println("End filtering");
	
	println("Start Writing");
	values = [ resultClones[cl] | cl <- resultClones ];
	OutputData(values, csvDestination);
	println("End Writing");
	
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

