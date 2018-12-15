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
	
	for(<node a,node b> <- reflexiveClosure){
		if(<b,a> notin relation && a != b && getName(b) == getName(a)){
			relation += <a,b>;
		}
	}
	
	map[node, set[loc]] result = ();
	for(<n1, n2> <- relation){
		sim = similarity(n1, n1.src, n2, n2.src);
		if(sim[2] > 0.99){
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


bool checkSubclones(loc l1, loc l2, set[loc] clones){
	for(<a1,a2> <- clones){
		return (betweenLocSameFile(a1, l1) && betweenLocSameFile(a2, l2)) 
		|| (betweenLocSameFile(a1, l2) && betweenLocSameFile(a2, l1));
	}
	return false;
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
			//node n = normalizeNodeDec(x);
			//println(n);
			t1 += s;
		}
	}
	visit(tree2) {
		case node x: {
			str s = removeLocFromString(toString(x));
			t2 += s;//normalizeNodeDec(x); 
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
	//result = <l1, l2, sim>;
	
	
	//println("START COMPARISON");
	//iprintln(t1);
	//println("----------------------------------------------------------------------");
	//iprintln(t2);
	//println("END COMPARISOPN");
	
	return result;
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
        case node x => x
    }
}

str removeLocFromString(str input){
	input = visit(input){ 
		case /([|])(?:(?=(\\?))\2.)*?\1/ => ""
		
	}
	
	//input = visit(input){
	//	case /(?\<=\()(.*?)(?=\))/ => ""
	//}
	
	return input;
}