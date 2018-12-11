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
import Map;


// Own modules
import utils::HelperFunctions;

loc project = |project://SimpleJava|;
//loc project = |project://smallsql0.21_src|;
// loc project = |project://src|; // <------ project://hsqldb-2.3.1, 
                                  // but only the src folder as specified in the assignment documentation

void Main() {
	//list[str] lines = getLinesOfCode(project);
	//int totalLOC = size(lines);
	set[Declaration] asts = createAstsFromEclipseProject(project, true);
	
	println(size(asts));
	map[int, list[node]] buckets = Preprocess2(asts);
	
	list[int] dist = [size(buckets[a]) | a <- buckets, size(buckets[a]) > 1];
	iprintln(dist);
	
	for(a <- buckets){
		if(size(buckets[a]) > 1){
			CompareBucket(buckets[a]);
		}
		
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
					
					if(nn > 2){
						if(nn in buckets){
							buckets[nn] += normalizeNodeDec(n);
						}else{
							buckets = buckets + (nn:[normalizeNodeDec(n)]);
						}
					}
				}
			}
		}
		
	}
	
	return buckets;
}


public node normalizeNodeDec(node ast) {
    return visit (ast) {
        case \method(x, _, y, z, q) => \method(lang::java::jdt::m3::AST::short(), "methodName", y, z, q)
        case \parameter(x, _, z) => \parameter(x, "paramName", z)
        case \vararg(x, _) => \vararg(x, "varArgName") 
        case \annotationTypeMember(x, _) => \annotationTypeMember(x, "annonName")
        case \annotationTypeMember(x, _, y) => \annotationTypeMember(x, "annonName", y)
        case \typeParameter(_, x) => \typeParameter("typeParaName", x)
        case \constructor(_, x, y, z) => \constructor("constructorName", x, y, z)
        case \interface(_, x, y, z) => \interface("interfaceName", x, y, z)
        case \class(_, x, y, z) => \class("className", x, y, z)
        case \enumConstant(_, y) => \enumConstant("enumName", y) 
        case \enumConstant(_, y, z) => \enumConstant("enumName", y, z)
        case \methodCall(x, _, z) => \methodCall(x, "methodCall", z)
        case \methodCall(x, y, _, z) => \methodCall(x, y, "methodCall", z) 
        case Type _ => lang::java::jdt::m3::AST::short()
        case Modifier _ => lang::java::jdt::m3::AST::\private()
        case \simpleName(_) => \simpleName("simpleName")
        case \number(_) => \number("1337")
        case \variable(x,y) => \variable("variableName",y) 
        case \variable(x,y,z) => \variable("variableName",y,z) 
        case \booleanLiteral(_) => \booleanLiteral(true)
        case \stringLiteral(_) => \stringLiteral("StringLiteralThingy")
        case \characterLiteral(_) => \characterLiteral("q")
    }
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

