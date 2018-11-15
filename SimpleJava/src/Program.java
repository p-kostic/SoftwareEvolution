
public class Program {

	public static void main(String[] args) {
		WriteHelloWorld();
		
		int meme = 0; 
		if (meme == 0) {
			WriteHelloWorld();
			WriteHelloWorld("test");
		}
	}
	
	public static void WriteHelloWorld() {
		System.out.println("Hello World");
		System.out.println("Hello World");
		System.out.println("Hello World");
		System.out.println("Hello World");
	}
	
	public static void WriteHelloWorld() {
		System.out.println("Hello World");
		System.out.println("Hello World");
		System.out.println("Hello World");
		System.out.println("Hello World");
	}
	
	public static void WriteHelloWorld() {
		System.out.println("Hello World");
		System.out.println("Hello World");
		System.out.println("Hello World");
		System.out.println("Hello World");
	}
	
	public static void WriteHelloWorld(String test) {
		System.out.println(test);
	}
	
	public static void Method5Lines1Comment(String test) {
		// This is a comment
		System.out.println(test);
		System.out.println(test);
		System.out.println(test);
	}

}
