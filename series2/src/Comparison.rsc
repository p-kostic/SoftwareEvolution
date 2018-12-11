module Comparison
import IO;
import Map;
import List;
import Set;
import Node;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import List;

void ProcessBuckets(list[map[node,node]] buckets){
	for(b <- buckets){
		CompareBucket(b);
	}
}

void CompareBucket(list[node] bucket){
	println("Started bucket comparison");
	lrel[node,node] reflexiveClosure = bucket * bucket;
	lrel[node,node] relation = [];
	
	for(<a,b> <- reflexiveClosure){
		if(<b,a> notin relation && b != a){
			relation += <a,b>;
		}
	}
	
	result = [];
	for(<n1, n2> <- relation){
		sim = similarity(n1, n1.src, n2, n2.src);
			
			
			
		result += sim;
				
		
	}
	
	result = sort(result, bool(tuple[loc, loc, real] a, tuple[loc, loc, real] b){ return a[2] > b[2]; });
	for(sim <- result){
		println(sim);
		
	}
	
	
	println("Converted bucket to relation");
}

tuple[loc, loc, real] similarity(node tree1, loc l1, node tree2, loc l2) {
	tuple[loc, loc, real] result;
	println("started simularity check");
	// Visit the subtree of the argument nodes
	// Copy them to lists t1 and t2, such that
	// We can calculate similarity scores from there
	
	list[node] t1 = [];
	list[node] t2 = [];
	
	visit(tree1) {
		case node x: {
			//str s = removeLocFromString(toString(x));
			t1 += x;
		}
	}
	visit(tree2) {
		case node x: {
			//str s = removeLocFromString(toString(x));
			t2 += x; 
		}
	}
	
	real sim = 0.0;
	if(t1 == t2){
		sim = 1.0;
	}
	real s = toReal(size(t1 & t2));
	real l = toReal(size(t1 - t2));
	real r = toReal(size(t2 - t1));
	
	result = <l1, l2, (2 * s) / (2 * s + l + r)>;
	//result = <l1, l2, sim>;
	
	
	//println("START COMPARISON");
	//iprintln(t1);
	//println("----------------------------------------------------------------------");
	//iprintln(t2);
	//println("END COMPARISOPN");
	
	return result;
}



str removeLocFromString(str input){
	input = visit(input){ 
		case /([|])(?:(?=(\\?))\2.)*?\1/ => "|project://blabla|"
		
	}
	
	input = visit(input){
		case /(?\<=\()(.*?)(?=\))/ => ""
	}
	
	return input;
}