module Duplication
import String;
import List;
import Set;
import util::Math;
import IO;

public str GetDuplicateScore(list[str] lines, int windowsize, int totalLOC){
	int duplicateLOC = RabinKarp(lines, windowsize);
	int duplicatePercentage = toInt(toReal(duplicateLOC) / toReal(totalLOC) * 100);
	println("Duplicate percentage: <duplicatePercentage>");
	if(duplicatePercentage < 3) {
		return "++";
	} else if (duplicatePercentage < 5) {
		return "+";
	} else if (duplicatePercentage < 10) {
		return "o";
	} else if (duplicatePercentage < 20) {
		return "-";
	} else if (duplicatePercentage < 100) {
		return "--";
	}
}

int RabinKarp(list[str] lines, int windowsize){
	if(windowsize > size(lines)){
		return 0;
	}
	
	// Preprocess variables
	int totalAmountOfWindows = size(lines) - windowsize + 1;
	list[int] lineHashes = PreprocessLines(lines);
	int result = 0; // Lines of code that are duplicate
	
	// Initialize Rabin Karp
	int hash = 0;
	set[int] corpus = {};
	int lastWindowPos = size(lines) - windowsize + 1;
	
	for(int i <- [0..windowsize]){
		hash += lineHashes[i] * toInt(pow(761, (windowsize - 1) - i));
	}

	// Add the initial hash to the hash corpus
	corpus += hash;
	
	// Rolling Hash
	int windowPosition = 0;
	for(int i <- [1..lastWindowPos]){
		hash -= lineHashes[i-1] * toInt(pow(761, (windowsize - 1)));
		hash *= 761;
		hash += lineHashes[i + windowsize - 1];
		if(hash in corpus){
			if((i - windowPosition) < windowsize){
				result += windowsize - (i - windowPosition);
			}else{
				result += windowsize;			
			}
			continue;
		}
		
		windowPosition = i;
		corpus += hash;
	}
	
	return result;

}

// Converts a list of lines to a list of their hashes.
list[int] PreprocessLines(list[str] lines){
	list[int] result = [];
	
	for(line <- lines){
		int lineHash = 0;
		for(int i <- [0..size(line)]){
			lineHash += toInt(charAt(line, i)) * toInt(pow(761, i));
		}		
		result += lineHash;
	}
	
	return result;
}