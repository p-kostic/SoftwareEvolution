module utils::HelperFunctions

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import Prelude;
import IO;
import util::FileSystem;
import Writer;

public int getLinesOfCode(loc projectLocation) {
	set[loc] files = {f | f <- visibleFiles(projectLocation), /\.java/ := f.file};
	return size([*readFileLines(f) | f <- files]);
}

public int getLinesFromLoc(loc testLine) {
	return testLine.end.line - testLine.begin.line + 1;
}

public void calculateAndPrettyPrintMetrics(map[node, set[loc]] resultClones, loc project, loc csvDestination) {
	int numberOfCloneClasses = size(resultClones); // Number of clone classes
	int numberOfClones = 0; // To keep track of the number of clones
	int biggest = 0;	// To keep track of the biggest clone
	loc biggestLoc; // To keep track of the location of the biggest clone
	int totalLines = 0; // To keep track of the total number of lines with clones
	
	loc biggestCCLoc;
	int biggestCCSize = 0;
	int totalLinesOverall = getLinesOfCode(project);
	
	for(n <- resultClones) {
	
		// Amount of clones
		numberOfClones += size(resultClones[n]);
		
		// Biggest Clone Class
		if (size(resultClones[n]) > biggestCCSize) {
			biggestCCSize = size(resultClones[n]);
			biggestCCLoc = n.src;
		}
		
		// Total LOC in each clone
		for (locs <- resultClones[n]) {
		 	totalLines += getLinesFromLoc(locs);
		}
		
		// Biggest LOC class
		loc temp = getOneFrom(resultClones[n]);
		if (getLinesFromLoc(temp) > biggest) {
			biggest = getLinesFromLoc(temp);
			biggestLoc = temp;
		}
	}
	
	println("#------------------# DUPLICATION #----------------------#");
	println("- Total amount of duplicate lines        = <totalLines>");
	println("- Total aount of lines overall           = <totalLinesOverall>");
	println("- Total amount of duplication percentage = <toReal(totalLines) / toReal(totalLinesOverall) * 100.0>%");
	println("#-----------------# CLONE METRICS #---------------------#");
	println("- Number of clone classes                = <numberOfCloneClasses>");
	println("- Number of clones                       = <numberOfClones>");
	println("- Biggest clone with size <biggest> and loc <biggestLoc>");
	iprintln("- Biggest clone class with <biggestCCSize> clones and location <biggestCCLoc>");
	println("#---------------# Started Writing to File #-------------#");
	values = [ resultClones[cl] | cl <- resultClones ];
	OutputData(values, csvDestination);
	println("#--------------# Finished Writing to File #-------------#");
}
