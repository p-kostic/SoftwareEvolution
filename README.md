# SoftwareEvolution
Code associated with the course Software Evolution of the University of Amsterdam, MSc Software Engineering

Group  
* Petar Kostic
* Joren Wijnmaalen

## Assignment
Relevant questions are
* Which metrics are used?
* How are these metrics computed?
* How well do these metrics indicate what we really want to know about these systems and how can we judge that?
* How can we improve any of the above? In other words, you have to worry about motivation and interpretation of metrics, as well as correct implementation.

Calculate at least the following metrics:
* Volume,
* Unit Size,
* Unit Complexity,
* Duplication.

For all metrics you calculate the actual metric values, for Unit Size and Unit Complexity you additionally calculate a risk profile, and finally each metric gets a score based on the SIG model (--, -, o, +, ++).

Calculate scores for at least the following maintainability aspects based on the SIG model:
* Maintainability (overall),
* Analysability,
* Changeability,
* Testability.
Bonus: Test Quality metric and a score for the Stability maintainability aspect.

## Volume
Lines of code: all lines of source code that are not comment or blank lines (i.e. `""`, `//` and `/* */ blocks` trimmed in java)

| Rank | Man Years | Java (KLOC) |
|------|-----------|-------------|
| ++   | 0-8       | 0-66        |
| +    | 8-30      | 66-246      |
| o    | 30-80     | 246-665     |
| -    | 80-160    | 655-1310    |
| --   | >160      | >1310       |

## Complexity per unit
For each method (i.e. unit), compute a CC that is incremented by these cases in the AST for that method:
```rascal
case \if(_,_):            result += 1;
case \if(_,_,x):          result += 1;
case \case(_):            result += 1;
case \do(_,_):            result += 1;
case \while(_,_):         result += 1;
case \for(_,_,_):         result += 1;
case \for(_,_,_,_):       result += 1;
case \foreach(_,_,_):     result += 1;
case \catch(_,_):         result += 1;
case \conditional(_,_,_): result += 1;
case infix(_,"&&",_):     result += 1;
case infix(_,"||",_):     result += 1;
default:                  result += 0;
```
Categorization per unit:

|   CC  | Risk evaluation             |
|-------|-----------------------------|
| 1-10  | simple, without much risk   |
| 11-20 | more complex, moderate risk |
| 21-50 | high risk                   |
| >50   | untestable, very high risk  |

Count for each risk level what percentage of lines of code falls within units categorized at that level.

| Rank | Moderate | High | Very High |
|------|----------|------|-----------|
| ++   | 25%      | 0%   | 0%        |
| +    | 30%      | 5%   | 0%        |
| o    | 40%      | 10%  | 0%        |
| -    | 50%      | 15%  | 5%        |
| --   | -        | -    | -         |

Thus, to be rated as ++, a system can have no more than 25% of code with moderate risk, no code at all with high or very high risk.

## Duplication
Calculate code duplication as the percentage of all code that occurs more than once in equal code blocks of at least 6 lines. Here, you ignore leading spaces. The duplication we measure is an exact string matching duplication.

| Rank | Duplication |
|------|-------------|
| ++   | 0-3%        |
| +    | 3-5%        |
| o    | 5-10%       |
| -    | 10-20%      |
| --   | 20-100%     |

Thus, a well-designed system ('+') should not have more than 5% code duplication.

## Unit size
Unit size uses the simple lines of code metric (i.e. all lines of source code that are not comment or blank lines). The risk categories and scoring guidelines are similar to those for complexity per unit, except that the particular threshold values are different.

## Unit Testing
Unit test coverage: 
| Rank | Unit Test Coverage |
|------|--------------------|
| ++   | 95-100%            |
| +    | 80-95%             |
| o    | 60-80%             |
| -    | 20-60%             |
| --   | 0-20%              |

Validate the coverage measure by the number of assert statements. Paper mentions that there is currently no fixed rating scheme in place.

## Source code ratings mapped back to system-level
To arrive at a system-level score, a weighted average is computed of each source-level score that is relevant according to the cross arks in the matrix. The weights are all equal by default, but different weighing schemes can be applied when deemed appropriate.

|               | Volume | Complexity per unit | Duplication | Unit Size | Unit testing |   |
|---------------|--------|---------------------|-------------|-----------|--------------|---|
|               |        |                     |             |           |              |   |
| Rank          |        |                     |             |           |              |   |
| Analysability | x      |                     | x           | x         | x            |   |
| changeability |        | x                   | x           |           |              |   |
| stability     |        |                     |             |           | x            |   |
| testability   |        | x                   |             | x         | x            |   |

When a particular property is deemed to have a strong influence on a particular characteristic, a cross is drawn in the.corresponding cell.
