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