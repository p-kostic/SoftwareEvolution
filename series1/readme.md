# Series 1
This readme contains the annotations that go with the code for assignment series 1.


## Metrics
To measure the maintainability of a program, various metrics are used.

### Volume
As is written in [REF PAPER], the volume of the program features heavily in the measure of maintainability. In general, a bigger system is more difficult to maintain (intuitively). The volume is measured in the following ways:

1. Lines of code (LOC)
2. LOC conversion to man years (see the table in [REF PAPER])
3. Class and method count (Optional)

The accuracy of this metric is debatable.

### Cyclomatic complexity per unit
The cyclomatic complexity of a unit is defined by the number of linearly independent paths. This can be found by the following formula on the control flow graph of the unit [https://en.wikipedia.org/wiki/Cyclomatic_complexity]

```
M = E - N + 2P 

where
E = the number of edges of the graph
N = the number of nodes of the graph
P = the number of connected components
```

Aggregation of these complexities by summation corrolates strongly with the LOC metric. 

### Duplication
Another metric for maintainability is the amount of code duplication in the source code. Duplication is measured by looking at equal code blocks of 6 lines. 