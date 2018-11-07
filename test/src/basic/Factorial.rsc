module basic::Factorial

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