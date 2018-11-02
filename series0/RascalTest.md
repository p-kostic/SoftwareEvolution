### Multiple choice:
Sets can be used to represent a sequence of values when 
<ol type="a">
<li>The values have duplicates.</li>  
<li>The values have no duplicates and no order.</li>  
<li>The values are unordered</li>  
</ol> 
The type of a list is determined by: 
<ol type="a">
<li>The type of the first element that was first added to the list.</li>  
<li>The upperbound of the type of two arbitrary elements.</li>  
<li>The upperbound of the type of all elements.</li>  
</ol> 


### Construct a function that determines the number of elements in a list 
```rascal
import List; 
text = ["abc", "def", "ghi"]; 
```
Run this with `<?>(text) == 3;`, where `<?>` is your program which should return `true`.

### Complete this function at `<?>` so that it determines the number of strings that contain `"a"`.
```rascal
text = ["andra", "moi", "ennepe", "Mousa", "polutropon"];
public int count(list[str] text) { 
   n = 0; 
   for(s ← text) 
      if(<?> := s) 
        n+=1; 
   return n; 
}
```
Run this as `count(text) == 2;`, which should return `true`.

### Complete this function at `<?>` so that it returns the strings that contain `"o"` in a list.
```rascal
text = ["andra", "moi", "ennepe", "Mousa", "polutropon"]; 
public list[str] find(list[str] text){ 
    return for(s ← text) if(/o/ := s) <?>; 
} 
``` 
Run this with `find(text) == ["moi", "Mousa", "polutropon"];`, which should return `true`.

### Complete this function at `<?>` so that it finds duplicates in a list of strings list 
```rascal
text = ["the", "jaws", "that", "bite", "the", "claws", "that", "catch"]; 
public list[str] duplicates(list[str] text){ 
    m = {}; 
    return for(s ← text) if(<?>) append s; else m += s; 
} 
```
To test, run `duplicates(text) == ["the", "that"];`, which should return `true`.

### Complete this function at `<?>` so that it tests that a list of words forms a palindrome.
A palindrome is a word that is symmetrical and can be read from left to right and from right to left
```rascal
import List; 
public bool isPalindrome(list[str] words){
    return words == <?>; 
} 
```
To test, run `isPalindrome(["a", "b", "b", "a"]) == true;`, which should return `true`.

### Answers
Once you are done, you can compare it with my answers [here](https://github.com/p-kostic/SoftwareEvolution/blob/master/src/RascalTest/Test.rsc)


