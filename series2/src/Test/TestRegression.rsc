module Test::TestRegression

import Main;
import Prelude;

loc project = |project://SimpleJava|;

// The regression test is performed on the SimpleJava project
// Test if all clones are detected
test bool TestCloneCount(){
	map[node, set[loc]] result = RunAlgorithm(project, 6);
	return size(result) == 3;
}

// Test if all locations are found for each class
test bool TestClassCount(){
	map[node, set[loc]] result = RunAlgorithm(project, 6);
	return [size(result[a]) | a <- result] == [3,2,2];
}