module Main
import IO;
import Prelude;
import Duplication;
import String;
import Utils;
import Volume;
import CycComplexity;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

loc project = |project://SimpleJava|;
loc smallSqlProject = |project://smallsql0.21_src|;


void Main(){
	// Global Variables
	M3 mmm = createM3FromEclipseProject(smallSqlProject);
	my_classes = {e | <c, e> <- declaredTopTypes(mmm), isClass(e)};
	
	int totalLOC = countAllLOC(mmm);
	set[Declaration] asts = createAstsFromEclipseProject(|project://SimpleJava|, true);
	
	
	// Volume
	str volumeRank = GetVolumeRank(totalLOC);
	println("Volume: <volumeRank>");
	
	// Calculate duplicate metrics
	list[str] lines = filterLines([*readFileLines(e) | e <- my_classes]);
	str duplicateScore = GetDuplicateScore(lines, 6, totalLOC);
	println("Duplication: <duplicateScore>");
	
	// Complexity per unit
	str CycCompScore = getCyclomaticFromAST(mmm, asts, totalLOC);
	println("Complexity per unit: <CycCompScore>");
	

}