module Metrics::Volume

import util::Math;
import IO;

// Own modules
import Services::Utils;
import Services::Ranking;
import Services::PrettyPrint;

Rank GetVolumeRank(int totalLOC){
	real kloc = toReal(totalLOC) / 1000;
	Rank result = -100;
	
	if (kloc < 66){
		result = PLUS_PLUS;	
	}else if(kloc < 246){
		result = PLUS;
	}else if(kloc < 665){
		result = ZERO;
	}else if(kloc < 1310){
		result = MIN;
	}else{
		result = MIN_MIN;
	}
	
	prettyPrintVolume(totalLOC, kloc, result);
	return result;
}