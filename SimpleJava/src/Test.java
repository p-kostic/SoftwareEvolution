public class Test {
	public void Method() {} // Clone pair 1
	
	// Clone Pair 2
	public void Method2() {
		
		// Comment and whitespace should be ignored for comparison
		System.out.println("Hello world");
	}
	
	public void Method3() {
		System.out.println("Should not count"); // Duplicate should be avoided because massTreshold
		System.out.println("Should not count");
	}
}