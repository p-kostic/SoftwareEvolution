module Services::Ranking


public alias Rank = int;
public Rank PLUS_PLUS = 2;
public Rank PLUS = 1;
public Rank ZERO = 0;
public Rank MIN = -1;
public Rank MIN_MIN = -2;

// Convert the numeric Rank to their string representation
public str RankToString(Rank r){
	str result = "o";
	switch(r){
		case -2: result = "--";
		case -1: result = "-";
		case 0: result = "o";
		case 1: result = "+";
		case 2: result = "++";
	}
	
	return result;
}

public Rank finalRiskFromDist(real moderate, real high, real veryHigh, int veryHighLines) {
		Rank result = -100; // -100 if there is an error
		if (veryHighLines > 0) {
			// Guaranteed to be at least a '-' system
			
			if (moderate <= 50 && high <= 15 && veryHigh <= 5) {
				result = -1;
			}
			result = -2;
		} else if (moderate <= 25 && high <= 10) {
			result = 2;
		}
		else if (moderate <= 30 && high <= 5) {
			result = 1;
		}
		else if (moderate <= 40 && high <= 10) {
			result = 0;
		}
		else if (moderate <= 50 && high <= 15) {
			result = -1;
		}	
		return result;
}