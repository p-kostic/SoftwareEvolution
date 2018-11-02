module basic::FizzBuzz

import IO;

// for n = 0; n < 101, n ++
// if it is divisible by 3 -> "Fizz", else nothing
// if it is divisible by 5 -> "Buzz", else nothing

void fizzbuzz() {
	for(int n <- [1 .. 101]) {
		fb = ((n % 3 == 0 ) ? "Fizz" : "") + ((n % 5 == 0) ? "Buzz" : "");
		println((fb == "") ? "<n>" : fb);
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