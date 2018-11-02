module RascalTest::Test

import List;

// By Petar Kostic


// ----------------------------------------------- 

int countList (list[&T] xs) {
	int count = 0;
	for (i <- xs) // ????,  sugar that probably uses size(), which we are implementing...
		 count+=1;
	return count;		
}

int countList2 (list[&T] lst) {
	return size(lst);
}

// rascal> text = ["abc", "def", "ghi"];
// list[str]: ["abc", "def", "ghi"]
// 
// rascal> countList(text) == 3;
// bool: true
// 
// rascal> countList2 == 3;
// bool: true

// ----------------------------------------------- 
// :=, meaning that We need to PatternMatch here.
public int count(list[str] text) { 
   n = 0; 
   for(s <- text) 
      if(/a/ := s) 
        n+=1; 
   return n; 
}

// rascal>text = ["andra", "moi", "ennepe", "Mousa", "polutropon"];
// list[str]: ["andra","moi","ennepe","Mousa","polutropon"]
// 
// rascal> count(text) == 2;
// bool: true

// ----------------------------------------------- 

public list[str] find(list[str] text){ 
    return for(s <- text) if(/o/ := s) append s; 
} 

// rascal> text = ["andra", "moi", "ennepe", "Mousa", "polutropon"]; 
// list[str]: ["andra", "moi", "ennepe", "Mousa", "polutropon"]
// 
// rascal> find(text) == ["moi", "Mousa", "polutropon"];
// bool: true

// ----------------------------------------------- 
// Sets cannot contain duplicates.. sooo
public list[str] duplicates(list[str] text){ 
    m = {}; 
    return for(s <- text) if(s in m) append s; else m += s; 
} 

// rascal> text = ["the", "jaws", "that", "bite", "the", "claws", "that", "catch"]; 
// list[str]: ["the", "jaws", "that", "bite", "the", "claws", "that", "catch"]
//
// rascal> duplicates(text) == ["the", "that"];
// bool: true

// ----------------------------------------------- 
public bool isPalindrome(list[str] words) {
	return words == reverse(words);
}

// rascal> isPalindrome(["a", "b", "b", "a"]) == true;
// bool: true
