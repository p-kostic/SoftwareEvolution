module basic::Bottles

import IO;

// Pattern matching (auxiliary funtion)
str bottles(0)			   = "no more bottles";
str bottles(1)			   = "1 bottle";
// Pattern directed invocation will chose the default if 0 or 1 are not matched
default str bottles(int n) = "<n> bottles";

void sing(){
	for(n <- [99 .. 0]){
		println("<bottles(n)> of beer on the wall, <bottles(n)> of beer.");
		println("Take one down, pass it around, <bottles(n-1)> of beer on the wall. \n");
	}
}