module Metrics::Duplication
import String;
import List;
import Set;
import util::Math;
import IO;

// Own Modules
import Services::Utils;
import Services::PrettyPrint;
import Services::Ranking;

public Rank GetDuplicateRank(list[str] lines, int windowsize, int totalLOC){
	int duplicateLOC = RabinKarp(lines, windowsize);
	int duplicatePercentage = round(toReal(duplicateLOC) / toReal(totalLOC) * 100);
	Rank result = 0;
	if(duplicatePercentage < 3) {
		result = 2;
	} else if (duplicatePercentage < 5) {
		result = 1;
	} else if (duplicatePercentage < 10) {
		result = 0;
	} else if (duplicatePercentage < 20) {
		result = -1;
	} else if (duplicatePercentage < 100) {
		result = -2;
	}
	
	prettyPrintDuplication(windowsize, totalLOC, duplicatePercentage, result);
	return result;
}

public int RabinKarp(list[str] lines, int windowsize){
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
	bool inDuplicateBlock = false;
	for(int i <- [1..lastWindowPos]){
		// Roll the hash in constant time
		hash -= lineHashes[i-1] * toInt(pow(761, (windowsize - 1)));
		hash *= 761;
		hash += lineHashes[i + windowsize - 1];
		
		if(hash in corpus){
			// Check for window overlap with the previous hit, minimize for the windowsize
			result += min(i - windowPosition, windowsize);
			windowPosition = i; // keep track of where the last hit was.
			continue;
		}
		
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