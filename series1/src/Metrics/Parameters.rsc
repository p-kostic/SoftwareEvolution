module Metrics::Parameters

import IO;

// Own modules
import Services::Ranking;
import Services::PrettyPrint;

Rank getParameterRank(real averageParametersPerUnit){
	Rank result = 0;
	
	if(averageParametersPerUnit < 1){
        result = 2;
    } else if (averageParametersPerUnit < 2){
        result = 1;
    } else if (averageParametersPerUnit < 3){
        result = 0;
    } else if (averageParametersPerUnit < 4){
        result = -1;
    } else {
        result = -2;
    }
	
	prettyPrintExtraMetrics(averageParametersPerUnit, result);
	
	return result;
}
