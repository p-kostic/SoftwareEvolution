module CycComplexity
import Prelude;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

// Grouperingen:
// 1-10  - without much risk
// 11-20 - moderate risk
// 21-50 - high risk
// > 50  - very high risk
// Per groep bijhouden hoeveel lines of codes het zijn
// 
void getCyclomaticFromAST() {
	result = ("moderate": 0, "high":0, "very high": 0 );


	M3 mmm = createM3FromEclipseProject(|project://SimpleJava|);
	my_classes = classes(mmm);
	my_methods = methods(mmm);
	println(my_methods);
	for(loc class <- my_classes) {
		Declaration ast = createAstFromFile(class, true);
		//println(ast);
		visit(ast) {
			case \method(_,_,_,_,impl): { 
				println("hallo");
				int c = cyclomaticComplexity(impl);
				println(c);
				//if (c <= 10) {
				//	result[
				//}
				if (c >= 11 && c <= 20) {
					result["moderate"] +=  1;
				}
				if (c >= 21 && c <= 50) {
					result["high"] +=  1;
				}
				if (c >= 50) {
					result["very high"] +=  1;
				}
			}				
		};
	}
	println(result);
}

// Source:
// Landman, D., Serebrenik, A., Bouwers, E., & Vinju, J. J. (2016). 
// Empirical analysis of the relationship between CC and SLOC in a
// large corpus of Java methods and C functions. 
// Journal of Software: Evolution and Process, 28(7), 589-618.
int cyclomaticComplexity(Statement impl){
	int result = 0;
	visit(impl) {
		//case \block(xs): {
		//	for (x <- xs) {
		//		result += cyclomaticComplexity(x);}}
		case \if(_,_): 	          result+=1;
	    case \if(_,_,x):          result+=1;
	    case \case(_):            result+=1;
	    case \do(_,_):            result+=1;
	    case \while(_,_):         result+=1;
	    case \for(_,_,_):         result+=1;
	    case \for(_,_,_,_):       result+=1;
	    case \foreach(_,_,_):     result+=1;
	    case \catch(_,_):         result+=1;
	    case \conditional(_,_,_): result+=1;
	    case infix(_,"&&",_):     result+=1;
	    case infix(_,"||",_):     result+=1;
	};
	return result;
}

int locMethods(){
	list[int] lines = [size(readFileLines(e)) | e <- my_classes];
	println(sum(lines));
}










