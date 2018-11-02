module basic::Squares

import IO; // For println

// Print a table of squares

void squares(int N){
  println("Table of squares from 1 to <N>\n"); 	// <N> for string interpolation
  for(int I <- [1 .. N + 1])
      println("<I> squared = <I * I>");  		// <I> and <I * I> for each line     
}

// a solution with a multi line string, based on string templates. Returns a 
// string value instead of printing the results itself. 
str squaresTemplate(int N)
  = "Table of squares from 1 to <N>
    '<for (int I <- [1 .. N + 1]) {>
    '  <I> squared = <I * I><}>";