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

map[node, set[loc]] CompareBucket(list[node] bucket, map[node, set[loc]] clones){
	//println("Started bucket comparison");
	lrel[node,node] reflexiveClosure = bucket * bucket;
	lrel[node,node] relation = [];
	for(<node a,node b> <- reflexiveClosure) {
		if(<b,a> notin relation && a != b && getName(b) == getName(a)){
			relation += <a,b>;
		}
	}
	map[node, set[loc]] result = ();
	for(<n1, n2> <- relation){
		sim = similarity(n1, n1.src, n2, n2.src);
		if(sim[2] == 1.0){
			// Add clone tuple to clone class
			if(n1 in clones){
				clones[n1] += { sim[0], sim[1] };
			}else{
				clones += (n1 : { sim[0], sim[1] });
			}		
		}
	}
	return clones;
}


tuple[loc, loc, real] similarity(node tree1, loc l1, node tree2, loc l2) {
	tuple[loc, loc, real] result;
	// Visit the subtree of the argument nodes
	// Copy them to lists t1 and t2, such that
	// We can calculate similarity scores from there
	list[str] t1 = [];
	list[str] t2 = [];
	
	
	visit(tree1) {
		case node x: {
			str s = removeLocFromString(toString(x));
			t1 += s;
		}
	}
	visit(tree2) {
		case node x: {
			str s = removeLocFromString(toString(x));
			t2 += s;
		}
	}
	
	real s = toReal(size(t1 & t2));
	real l = toReal(size(t1 - t2));
	real r = toReal(size(t2 - t1));
	
	real sim = 0.0;
	if(s > 0){
		sim = (2 * s) / (2 * s + l + r);
	}
	
	result = <l1, l2, sim>;
	
	return result;
}

str removeLocFromString(str input){
	return visit(input) { 
		case /([|](.*?)[|])([\(](.*?)[\)])|([|](.*?)[|])/ => ""
	};
}