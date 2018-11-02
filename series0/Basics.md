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
```rascal
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
```
Now to run it
```rascal
rascal>import basic::Bottles;
ok
rascal>sing();
// ...
7 bottles of beer on the wall, 7 bottles of beer.
Take one down, pass it around, 6 bottles of beer on the wall. 

6 bottles of beer on the wall, 6 bottles of beer.
Take one down, pass it around, 5 bottles of beer on the wall. 
// ...
```
## Bubble
```rascal
module basic::Bubble

import List;
import IO;

// Variations on Bubble sort

// sort1: uses list indexing and a for-loop
// classic, imnperative style implementation of bubble sort:
// it iterates over consecutive pairs of elements and when a not-yet
// storted pair is encountered, the elements are exchanged, and sort1
// is applied recursively to the whole list
list[int] sort1(list[int] numbers){
  if(size(numbers) > 0){
     for(int i <- [0 .. size(numbers)-1]){
       if(numbers[i] > numbers[i+1]){
         <numbers[i], numbers[i+1]> = <numbers[i+1], numbers[i]>;
         return sort1(numbers);
       }
    }
  }
  return numbers;
}

// sort2: uses list matching and switch with two cases
// - a case matching a list with to consecutive elements that are unsorted
//   observe that when the pattern of a case matches, the case as a whole can
//   still fail
// - a default case
list[int] sort2(list[int] numbers){
  switch(numbers){
    case [*int nums1, int p, int q, *int nums2]:
       if(p > q){
          return sort2(nums1 + [q, p] + nums2);
       } else {
       	  fail;
       }
     default: return numbers;
   }
}

// sort3: uses list matching in a more declatative style:
// as long as there are unsorted elements in the list 
// (possibly with intervening elements), exchange them
list[int] sort3(list[int] numbers){
  while([*int nums1, int p, *int nums2, int q, *int nums3] := numbers && p > q)
        numbers = nums1 + [q] + nums2 + [p] + nums3;
  return numbers;
}

// sort4: using recursion instead of iteration, and splicing instead of concat.
// identical to sort3. Note the shorter *-notation for list variables is used.
// The type declaration for the non-list variables has been omitted.
list[int] sort4([*int nums1, int p, *int nums2, int q, *int nums3]) {
  if (p > q)
    return sort4([*nums1, q, *nums2, p, *nums3]);
  else
    fail sort4;
}
default list[int] sort4(list[int] x) = x;

// sort5: Uses tail recursion to reach a fixed point insted of a while loop.
// One alternative matches lists with out-of-order elements, 
// while the default alternative returns the list if no out-of-order elements are found
// inlines the condition into a when:
list[int] sort5([*int nums1, int p, *int nums2, int q, *int nums3])
  = sort5([*nums1, q, *nums2, p, *nums3])
  when p > q;

default list[int] sort5(list[int] x) = x;
```
Putting them to the test
```rascal
rascal>import basic::Bubble;
ok

rascal>L = [9,8,7,6,5,4,3,2,1];
list[int]: [9,8,7,6,5,4,3,2,1]

rascal>sort1(L);
list[int]: [1,2,3,4,5,6,7,8,9]
rascal>sort2(L);
list[int]: [1,2,3,4,5,6,7,8,9]
rascal>sort3(L);
list[int]: [1,2,3,4,5,6,7,8,9]
rascal>sort4(L);
list[int]: [1,2,3,4,5,6,7,8,9]
rascal>sort5(L);
list[int]: [1,2,3,4,5,6,7,8,9]
```

## Even
Produces a list of even numbers
``` rascal
rascal>list[int] even0(int max) {
>>>>>>>  list[int] result = [];
>>>>>>>  for (int i <- [0..max])
>>>>>>>    if (i % 2 == 0)
>>>>>>>      result += i;
>>>>>>>  return result;
>>>>>>>}
list[int] (int): function(|prompt:///|(0,119,<1,0>,<7,1>))

rascal>even0(25);
list[int]: [0,2,4,6,8,10,12,14,16,18,20,22,24]
```
Now lets remove the temporary type declarations.
```
rascal>list[int] even1(int max) {
>>>>>>>  result = [];
>>>>>>>  for (i <- [0..max])
>>>>>>>    if (i % 2 == 0)
>>>>>>>      result += i;
>>>>>>>  return result;
>>>>>>>}
list[int] (int): function(|prompt:///|(0,105,<1,0>,<7,1>))

rascal>even1(25);
list[int]: [0,2,4,6,8,10,12,14,16,18,20,22,24]
```
To make the code shorter, we can inline the condition in the for loop:
```rascal
rascal>list[int] even2(int max) {
>>>>>>>  result = [];
>>>>>>>  for (i <- [0..max], i % 2 == 0)
>>>>>>>    result += i;
>>>>>>>  return result;
>>>>>>>}
list[int] (int): function(|prompt:///|(0,101,<1,0>,<6,1>))

rascal>even2(25);
list[int]: [0,2,4,6,8,10,12,14,16,18,20,22,24]
```
For loops can even produce lists as value with the append statement!
```rascal
rascal>list[int] even3(int max) {
>>>>>>>  result = for (i <- [0..max], i % 2 == 0)
>>>>>>>    append i;
>>>>>>>  return result;
>>>>>>>}
list[int] (int): function(|prompt:///|(0,94,<1,0>,<5,1>))

rascal>even3(25);
list[int]: [0,2,4,6,8,10,12,14,16,18,20,22,24]
```
The temporary result is not even necessary anymore!
```rascal
rascal-shellrascal>list[int] even4(int max) {
>>>>>>>  return for (i <- [0..max], i % 2 == 0)
>>>>>>>           append i;
>>>>>>>}
list[int] (int): function(|prompt:///|(0,78,<1,0>,<4,1>))

rascal>even4(25);
list[int]: [0,2,4,6,8,10,12,14,16,18,20,22,24]
```
This code is actually very close to a list comprehension already:
```rascal
rascal>list[int] even5(int max) {
>>>>>>>return [i | i <- [0..max], i % 2 == 0];
>>>>>>>}
list[int] (int): function(|prompt:///|(0,68,<1,0>,<3,1>))

rascal>even5(25);
list[int]: [0,2,4,6,8,10,12,14,16,18,20,22,24]
```
And now we can just define even using an expression only:
```rascall
rascal>list[int] even6(int max) = [i | i <- [0..max], i % 2 == 0];
list[int] (int): function(|prompt:///|(0,59,<1,0>,<1,59>))

rascal>even6(25);
list[int]: [0,2,4,6,8,10,12,14,16,18,20,22,24]
```
Or, perhaps we prefer creating a set instead of a list:
```
rascal>set[int] even7(int max) = {i | i <- [0..max], i % 2 == 0};

rascal>even7(25);
set[int]: {10,16,8,14,20,2,4,6,24,12,22,18,0}
```

Benefits
* You can program in for loops and use temporary variables if you like.
* Comprehensions are shorter and more powerful.
* There are comprehensions for lists, sets, and maps

Pitfalls
* Trainwreck alert: if you start putting too many conditions in a single for loop or comprehension the code may become unreadable.

## FizzBuzz
```rascal
rascalmodule basic::FizzBuzz

import IO;

void fizzbuzz() {
   for(int n <- [1 .. 101]){
      fb = ((n % 3 == 0) ? "Fizz" : "") + ((n % 5 == 0) ? "Buzz" : "");
      println((fb == "") ?"<n>" : fb);
   }
}

void fizzbuzz2() {
  for (n <- [1..101])
    switch(<n % 3 == 0, n % 5 == 0>) {
      case <true,true>  : println("FizzBuzz");
      case <true,false> : println("Fizz");
      case <false,true> : println("Buzz");
      default: println(n);
    }
}

void fizzbuzz3() {
  for (n <- [1..101]) {
    if (n % 3 == 0) print("Fizz");
    if (n % 5 == 0) print("Buzz");
    else if (n % 3 != 0) print(n);
    println("");
  }
}
```
Running it
```rascal
rascal>import basic::FizzBuzz
>>>>>>>;
ok
rascal>fizzbuzz();
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```
## Quine
A self-reproducing program. Takes no input and produces a copy of its own source code.
```rascal
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
```
we have to be very carefull in handling special characters like quote (") and backslash (\) in strings.
```rascal
rascal>import IO;
ok

rascal>str greeting = "\"Good Morning, Dr. Watson\", said Holmes";
str: "\"Good Morning, Dr. Watson\", said Holmes"

rascal>println("\"" + greeting + "\"");
""Good Morning, Dr. Watson", said Holmes"
ok
```
As you see the quotes inside the string are not escaped and the result is not a legal string. So what can we do? We escape all dangerous characters in the string before printing it using the [Rascal:escape] function. It takes a string and a map of characters to be escaped and returns a result in which all escaping has been carried out. Be aware that in the map, also escaping is needed! We want to say: escape " and replace it by `\"`, but since both `"` and `\` have to be escaped themselves we have to say: escape `"\""` and replace it by `"\\\""`. The effect is as follows:
```rascal
rascal>import String;
ok

rascal>println("\"" + escape(greeting, ("\"": "\\\"")) + "\"");
"\"Good Morning, Dr. Watson\", said Holmes"
ok
```
And indeed, the two quotes are now properly escaped. This is exactly what happens in the definition of quine:  
```
rascalprintln("\"" + escape(program, ("\"" : "\\\"", "\\" : "\\\\")) + "\";");
```
We escape program and replace `"` by `\"`, and `\` by `\\`. The mesmerizing amount of `\` characters can be explained due to escaping `"` and `\`.

Now let’s put `quine` to the test.
```rascal
rascal>quine();
module basic::Quine

import IO;
import String;

void quine(){
  println(program);
  println("\"" + escape(program, ("\"" : "\\\"", "\\" : "\\\\")) + "\";");
}

str program =
"module basic::Quine

import IO;
import String;

void quine(){
  println(program);
  println(\"\\\"\" + escape(program, (\"\\\"\" : \"\\\\\\\"\", \"\\\\\" : \"\\\\\\\\\")) + \"\\\";\");
}

str program =";
ok
```
