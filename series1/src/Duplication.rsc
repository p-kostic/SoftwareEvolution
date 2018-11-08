module Duplication
import String;
import List;
import Set;
import util::Math;
import IO;

/// <summary>

// </summary>
public int FindDuplicates(list[str] lines, int windowsize){
	return RabinKarp(lines, windowsize);
}

int RabinKarp(list[str] lines, int windowsize){
	if(windowsize > size(lines)){
		return 0;
	}
	
	list[int] lineHashes = [];
	for(line <- lines){
		int lineHash = 0;
		for(int i <- [0..size(line)]){
			lineHash += toInt(charAt(line, i)) * toInt(pow(251, i));
		}
		lineHashes += lineHash;
	}
	
	// Initialize Rabin Karp
	int hash = 0;
	set[int] corpus = {};
	int lastWindowPos = size(lines) - windowsize + 1;
	
	for(int i <- [0..windowsize]){
		hash += lineHashes[i] * toInt(pow(251, (windowsize - 1) - i));
	}
	corpus += hash;
	
	// Rolling Hash
	for(int i <- [1..lastWindowPos]){
		hash -= lineHashes[i-1] * toInt(pow(251, (windowsize - 1)));
		hash *= 251;
		hash += lineHashes[i + windowsize - 1];
		corpus += hash;
	}
	
	
	return size(lines) - windowsize + 1 - size(corpus);

}