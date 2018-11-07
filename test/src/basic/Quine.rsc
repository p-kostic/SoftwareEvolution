module basic::Quine

import IO;
import String;

void quine(){
  // Prints the string program twice, here as is and this produces the program up to above.
  println(program);
  // Here the value of program is printed as a string (surrounded with string quotes) in order to
  // reproduce the string value of program followed by a semi-colon  
  println("\"" + escape(program, ("\"" : "\\\"", "\\" : "\\\\")) + "\";"); 
}

// this variable has the value of the module Quine up to here
str program = 
"module basic::Quine

import IO;
import String;

void quine(){
  println(program);
  println(\"\\\"\" + escape(program, (\"\\\"\" : \"\\\\\\\"\", \"\\\\\" : \"\\\\\\\\\")) + \"\\\";\");
}

str program ="; // This string has a mesmerizing amount of escapes to which we will come back in a moment.