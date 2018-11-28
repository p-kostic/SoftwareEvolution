module Test::TestRanking

import Prelude;
import IO; 

// Own modules
import Services::Ranking;

// Trivial test to check for correct alias implementation
test bool TestAliasRank() {
	if (PLUS_PLUS != 2)  return false;
	if (PLUS      != 1)  return false;
	if (ZERO      != 0)  return false;
	if (MIN		  != -1) return false;
	if (MIN_MIN   != -2) return false;
	return true;
}

// Given a rank, check if we return the appropriate string correctly. Trivial test.
test bool TestRankToString() {
	if (RankToString(PLUS_PLUS) != "++") return false;
	if (RankToString(PLUS)      != "+")  return false;
	if (RankToString(ZERO)      != "o")  return false;
	if (RankToString(MIN)	    != "-")  return false;
	if (RankToString(MIN_MIN)   != "--") return false;
	return true;
}




