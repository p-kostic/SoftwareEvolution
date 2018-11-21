module Volume

import util::Math;
import IO;

str GetVolumeRank(int totalLOC){
	println("#---------------------------# Volume Rank #--------------------------------#");
	println("# For a codebase with <totalLOC> total lines of code");
	
	real kloc = toReal(totalLOC) / 1000;
	println("# This is <kloc> KLOC");
	 
	if (kloc < 66){
		println("# Volume rank of \'++\'");
		println("#--------------------------------------------------------------------------#");
		return "++";	
	}else if(kloc < 246){
		println("# Volume rank of \'+\'");
		println("#--------------------------------------------------------------------------#");
		return "+";
	}else if(kloc < 665){
		println("# Volume rank of \'o\'");
		println("#--------------------------------------------------------------------------#");
		return "o";
	}else if(kloc < 1310){
		println("# Volume rank of \'-\'");
		println("#--------------------------------------------------------------------------#");
		return "-";
	}else{
		println("# Volume rank of \'--\'");
		println("#--------------------------------------------------------------------------#");
		return "--";
	}
}

//  --------------------
// ++ | 0-8	    |  0-66
// +  | 8-30    |  66-246
// o  | 30-80	|  246-665
// -  | 80-160	|  655-1310
// -- | >160    |  >1310