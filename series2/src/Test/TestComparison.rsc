module Test::TestComparison

import Prelude;
import Node;
import Comparison;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;

// Test the empty case
test bool TestCompareBucketCase1() {
	list[node] bucket = [];
	map[node, set[loc]] clones = ();
	return CompareBucket(bucket, clones) == ();
}

// Test the single case, nothing to compare
// such that the clones should be empty
test bool TestCompareBucketCase2() {
	node tree1 = class("a", [], [], [], src=|project://test|);
	list[node] bucket = [tree1];
	map[node, set[loc]] clones = ();
	return CompareBucket(bucket, clones) == ();
}

// Test the duo case, 1 comparison, guaranteed to be 
// non-identical, but with a similariy of 1. Check if the 
// correct clone hashmap is returned
test bool TestCompareBucketCase3() {

	// Locations of the file
	loc l1 = |project://test|;
	loc l2 = |project://test2|;
	
	// Construct the ASTs
	Declaration tree1 = class("ab", [], [], [], src=l1);
	node tree2 = class("a", [], [], [tree1, tree1], src=l1);
	node tree3 = class("a", [], [], [tree1, tree1], src=l2);
	
	list[node] bucket = [tree2, tree3];
	map[node, set[loc]] clones = ();
	return CompareBucket(bucket, clones) == (tree2:{l1,l2});
}

// Test the duo case, 1 comparison, guaranteed to be
// non-identical, but with a similarity of <1.0. Check if the 
// correct empty hashmap is returned
test bool TestCompareBucketCase4() {

	// Locations of the file
	loc l1 = |project://test|;
	loc l2 = |project://test2|;
	
	// Construct the ASTs
	Declaration tree1 = class("ab", [], [], [], src=l1);
	node tree2 = class("a", [], [], [tree1, tree1], src=l1);
	node tree3 = class("b", [], [], [tree1, tree1], src=l2);
	
	list[node] bucket = [tree2, tree3];
	map[node, set[loc]] clones = ();
	return CompareBucket(bucket, clones) == ();
}

// Identical trees, similarity should be 1.0
test bool TestSimilarityCase1() {
	node tree1 = class("a", [], [], [], src=|project://test|);
	loc l1 = |project://test|(1,1,<1,1>,<1,1>);
	node tree2 = class("a", [], [], [], src=|project://test|);
	loc l2 = |project://test|(1,1,<1,1>,<1,1>);
	tuple[loc, loc, real] sim = similarity(tree1, l1, tree2, l2);

	if (sim != <l1, l2, 1.>) return false;
	return true;
}

// Different name for trees, similarity should be 0.0
test bool TestSimilarityCase2() {
	node tree1 = class("a", [], [], [], src=|project://test|);
	loc l1 = |project://test|(1,1,<1,1>,<1,1>);
	node tree2 = class("b", [], [], [], src=|project://test|);
	loc l2 = |project://test|(1,1,<1,1>,<1,1>);
	tuple[loc, loc, real] sim = similarity(tree1, l1, tree2, l2);

	if (sim != <l1, l2, 0.0>) return false;
	return true;
}

// Different name for trees, but contents are the same similarity should be 0.5
test bool TestSimilarityCase3() {
	Declaration ast = class("c", [], [], [], src=|project://test|);
	node tree1 = class("a", [], [], [ast], src=|project://test|);
	loc l1 = |project://test|(1,1,<1,1>,<1,1>);
	node tree2 = class("b", [], [], [ast], src=|project://test|);
	loc l2 = |project://test|(1,1,<1,1>,<1,1>);
	tuple[loc, loc, real] sim = similarity(tree1, l1, tree2, l2);
	
	if (sim != <l1, l2, 0.5>) return false;
	return true;
}

// Identical nested, similarity should be 1.0
test bool TestSimilarityCase4() {
	Declaration ast = class("b", [], [], [], src=|project://test|);
	node tree1 = class("a", [], [], [ast,ast], src=|project://test|);
	loc l1 = |project://test|(1,1,<1,1>,<1,1>);
	node tree2 = class("a", [], [], [ast,ast], src=|project://test|);
	loc l2 = |project://test|(1,1,<1,1>,<1,1>);
	tuple[loc, loc, real] sim = similarity(tree1, l1, tree2, l2);

	if (sim != <l1, l2, 1.>) return false;
	return true;
}

// Non-identical nested, similarity should be 2/3
test bool TestSimilarityCase5() {
	Declaration ast = class("c", [], [], [], src=|project://test|);
	
	node tree1 = class("a", [], [], [ast,ast], src=|project://test|);
	loc l1 = |project://test|(1,1,<1,1>,<1,1>);
	node tree2 = class("b", [], [], [ast,ast], src=|project://test|);
	loc l2 = |project://test|(1,1,<1,1>,<1,1>);
	tuple[loc, loc, real] sim = similarity(tree1, l1, tree2, l2);
	
	if (sim != <l1, l2, toReal(2)/toReal(3)>) return false;
	return true;
}


// Test a range of different cases for removing location declarations
// from a string with multiple edge cases
// Trivial test cases, as such, no seperate test methods required to easily
// identify the case that is failing.
test bool TestRemoveLocFromString() {
	// Empty string
	if(removeLocFromString("") != "") return false;
	
	// No location, return the same string
	if(removeLocFromString("nothing") != "nothing") return false;
	
	// Nothing but a location, should return the empty string
	if(removeLocFromString("|project://test|") != "") return false;
	
	// location between characters, should only return the characters
	if(removeLocFromString("asd|project://test|asd") != "asdasd") return false;
	
	// preceding characters and location with elements, should only return the characters
	if(removeLocFromString("asd|project://test|(12,23,\<10,2\>,\<10,2\>)") != "asd") return false;
	
	// Location with elements between characters, should only return characters 
	if(removeLocFromString("asd|project://test|(12,23,\<10,2\>,\<10,2\>)asd") != "asdasd") return false;
	
	// multiple locations without elements should only return characters
	if(removeLocFromString("|project://test|asd|project://test|") != "asd") return false;
	
	// Multiple locations with elements should only return characters since we visit the string
	str longLine = "asd|project://test|(1,1,\<1,2\>,\<1,1\>)asd|project://test|(1,1,\<1,2\>,\<1,1\>)asd";
	if(removeLocFromString(longLine) != "asdasdasd") return false;
	return true;
}


test bool TestIsSubTreeCase1(){
	node cloneA = class("a", [], [], [class("b", [], [], [], src=|project://test|)], src=|project://test|);
	node cloneB = class("b", [], [], [], src=|project://test|);
	
	return isSubTree(cloneB, cloneA);
}

test bool TestIsSubTreeCase2(){
	node cloneA = class("a", [], [], [class("b", [], [], [], src=|project://test|)], src=|project://test|);
	node cloneB = class("a", [], [], [], src=|project://test|);
	
	return !isSubTree(cloneB, cloneA);
}

