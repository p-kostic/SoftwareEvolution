module Volume

import util::Math;

str GetVolumeRank(int totalLOC){
	real kloc = toReal(totalLOC) / 1000;
	if (kloc < 66){
		return "++";	
	}else if(kloc < 246){
		return "+";
	}else if(kloc < 665){
		return "o";
	}else if(kloc < 1310){
		return "-";
	}else{
		return "--";
	}
}

//  --------------------
// ++ | 0-8	    |  0-66
// +  | 8-30    |  66-246
// o  | 30-80	|  246-665
// -  | 80-160	|  655-1310
// -- | >160    |  >1310