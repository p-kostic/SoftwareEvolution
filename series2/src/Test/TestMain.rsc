module Test::TestMain

import Main;
import Prelude;
import IO;
import Node;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Test the amount of buckets returned by the preprocess case 1
test bool TestPreprocessCase1(){
	// Mass 1
	Declaration ast1 = class("a", [], [], [], src=|project://asdf|);
	
	// Mass 3
	Declaration ast2 = class("a", [],[],[ast1, ast1], src=|project://asdf|);
	
	// Mass 5
	Declaration ast3 = class("a", [],[],[class("b", [], [], [ast1, ast1], src=|project://asdf|), ast1], src=|project://asdf|);
	
	set[node] asts = {ast1, ast2, ast3};
	int massThreshold = 2;
	
	bucketMapping = Preprocess(asts, massThreshold);
	
	// Should return 1 bucket because node size 5 is singular
	// node size 4 does not exist
	// node sizes 1 and 2 are filterd because the node mass threshold
	// node size 3 remains
	return size(bucketMapping) == 1;
}

// Test the amount of buckets returned by the preprocess case 2
test bool TestPreprocessCase2(){
	// Mass 1
	Declaration ast1 = class("a", [], [], [], src=|project://asdf|);
	
	// Mass 3
	Declaration ast2 = class("a", [],[],[ast1, ast1], src=|project://asdf|);
	
	// Mass 5
	Declaration ast3 = class("a", [],[],[class("b", [], [], [ast1, ast1], src=|project://asdf|), ast1], src=|project://asdf|);
	Declaration ast4 = ast3;
	ast4.src = |project://test|;
	
	set[node] asts = {ast3, ast4};
	int massThreshold = 2;
	
	bucketMapping = Preprocess(asts, massThreshold);
	// Should return 2 buckets because node size 3 and 5 are not singular
	// node sizes 1 and 2 are filterd because the node mass threshold
	return size(bucketMapping) == 2;
}

// Test the node distribution in buckets
test bool TestPreprocessCase3(){
	// Mass 1
	Declaration ast1 = class("a", [], [], [], src=|project://asdf|);
	
	// Mass 3
	Declaration ast2 = class("a", [],[],[ast1, ast1], src=|project://asdf|);
	
	// Mass 5
	Declaration ast3 = class("a", [],[],[class("b", [], [], [ast1, ast1], src=|project://asdf|), ast1], src=|project://asdf|);
	Declaration ast4 = ast3;
	
	ast4.src = |project://test|;
	
	set[node] asts = {ast3, ast4};
	int massThreshold = 2;
	
	bucketMapping = Preprocess(asts, massThreshold);
	
	// Each bucket should contain 2 subtrees
	return [size(bucketMapping[a]) | a <- bucketMapping] == [2,2];
}

// Test the correct filtering of subclones
test bool TestFilterSubclonesCase1(){
	// Placeholder locations
	loc a = |project://test|(1,1,<0,0>,<0,0>);
	loc b = |project://test|(1,1,<0,0>,<0,0>);
	
	node cloneA = class("a", [], [], [class("b", [], [], [], src=|project://test|)], src=|project://test|);
	node cloneB = class("b", [], [], [], src=|project://test|);
	
	map[node, set[loc]] clones = (cloneA: {a}, cloneB: {b});
	
	map[node, set[loc]] filteredClones = filterSubclones(clones);
	
	// CloneB should be filtered out
	return filteredClones[cloneA] == {a} && size(filteredClones) == 1;
}


// Test the correct filtering of subclones case 3
// BetweenLocSameFile is implicitely tested
test bool TestFilterSubclonesCase2(){
	// Placeholder locations
	loc a = |project://test|(1,1,<0,0>,<0,0>);
	loc b = |project://test|(1,1,<0,0>,<0,0>);
	
	node cloneA = class("a", [], [], [], src=|project://test|);
	node cloneB = class("b", [], [], [], src=|project://test|);
	
	map[node, set[loc]] clones = (cloneA: {a}, cloneB: {b});
	
	map[node, set[loc]] filteredClones = filterSubclones(clones);
	
	// No clones get filtered, src path is not the same
	return size(filteredClones) == 2;
}

// Test the correct counting of nodes in a three, emperically
test bool TestCountNodes(){
	// Mass 1
	Declaration ast1 = class("a", [], [], [], src=|project://asdf|);
	
	// Mass 3
	Declaration ast2 = class("a", [],[],[ast1, ast1], src=|project://asdf|);
	
	// Mass 5
	Declaration ast3 = class("a", [],[],[class("b", [], [], [ast1, ast1], src=|project://asdf|), ast1], src=|project://asdf|);
	
	return countNodes(ast1) == 1 && countNodes(ast2) == 3 && countNodes(ast3) == 5;
}


