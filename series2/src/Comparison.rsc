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

void CompareBucket(map[node,node] bucket){
	println("Started bucket comparison");
	set[node] nodes = domain(bucket);
	rel[node,node] relation = nodes * nodes;
	
	result = [];
	for(<n1, n2> <- relation){
		if(n1.src != n2.src){
			sim = similarity(n1, n1.src, n2, n2.src);
			result += sim;
			//println(sim);
			//if(sim[2] > 0.99){  }		
		}
	}
	
	result = sort(result, bool(tuple[loc, loc, real] a, tuple[loc, loc, real] b){ return a[2] > b[2]; });
	for(sim <- result){
		if(sim[0] == sim[1]){
			println(sim);
		}
	}
	
	
	println("Converted bucket to relation");
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
	
	result = <l1, l2, (2 * s) / (2 * s + l + r)>;
	
	
	
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