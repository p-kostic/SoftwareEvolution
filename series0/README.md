# 1. Basics

## File structure
`projectfolder/src/basic/Squares.rsc`  
Where Squares.rsc's module is named `module basic::Squares`  
Open the terminal in src, so that `import basic::Squares` works. 


## Hello
```rascal
rascal> import IO;
ok
rascal> println("Hello world, this is my first Rascal program");
Hello world, this is my first Rascal program
ok
```
### Hello as function
```rascal
rascal>import IO;
ok
rascal>void hello() {
>>>>>>>   println("Hello world, this is my first Rascal program");
>>>>>>>}
void (): function(|prompt:///|(0,77,<1,0>,<3,1>))
rascal>hello();
Hello world, this is my first Rascal program
ok
```

### Hello as module
File -> New -> Rascal Module
```rascal
module demoHello::basic::Hello

import IO;

void hello() {
	println("Hello world, this is my first Rascal program");
}
```
Now to import in the terminal. In Eclipse, right click on the module under `src` that you just created and click on `Rascal Console`. Type the following into this console:
```rascal
rascal>import demoHello::basic::Hello;
ok
rascal>hello();
Hello world, this is my first Rascal program
ok
```

## Factorial
```rascal
module demoFactorial::basic::Factorial

// Fac is defined using a conditional expression to distinguish cases
int fac(int N) = N <= 0 ? 1 : N * fac(N - 1);

// Fac2 distinguishes cases using pattern-based dispatch. Here, the case for 0 is defined
int fac2(0) = 1;
default int fac2(int N) = N * fac2(N - 1);

// Fac3 shows a more imperative implementation of factorial
int fac3(int N) {
  if (N == 0)
  	return 1;
  return N * fac3(N - 1);
}
```
Now to run `fac` in the terminal
```rascal
rascal>import demo::basic::Factorial;
ok
rascal>fac(47);
int: 258623241511168180642964355153611979969197632389120000000000
rascal>fac2(47);
int: 258623241511168180642964355153611979969197632389120000000000
```
## Squares
```rascal
module basic::Squares

import IO; // For println

// Print a table of squares

void squares(int N){
  println("Table of squares from 1 to <N>\n");  // <N> for string interpolation
  for(int I <- [1 .. N + 1])
      println("<I> squared = <I * I>");  // <I> and <I * I> for each line     
}

// a solution with a multi line string, based on string templates. Returns a 
// string value instead of printing the results itself. 
str squaresTemplate(int N)
  = "Table of squares from 1 to <N>
    '<for (int I <- [1 .. N + 1]) {>
    '  <I> squared = <I * I><}>";
```
Now run it in the terminal
```rascal
rascal>squares(9);
Table of squares from 1 to 9

1 squared = 1
2 squared = 4
3 squared = 9
4 squared = 16
5 squared = 25
6 squared = 36
7 squared = 49
8 squared = 64
9 squared = 81
ok
```
`squaresTemplate` gives a similar result but now as a string:
```rascal
rascal>squaresTemplate(9);
str: "Table of squares from 1 to 9\r\n\r\n  1 squared = 1\r\n  2 squared = 4\r\n  3 squared = 9\r\n  4 squared = 16\r\n  5 squared = 25\r\n  6 squared = 36\r\n  7 squared = 49\r\n  8 squared = 64\r\n  9 squared = 81
rascal>println(squaresTemplate(9));
Table of squares from 1 to 9

  1 squared = 1
  2 squared = 4
  3 squared = 9
  4 squared = 16
  5 squared = 25
  6 squared = 36
  7 squared = 49
  8 squared = 64
  9 squared = 81
ok
```
## Bottles of beer
