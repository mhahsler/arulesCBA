# Classification Based on Association Rules Algorithm (CBA)

Build a classifier based on association rules using the ranking, pruning
and classification strategy of the CBA algorithm by Liu, et al. (1998).

## Usage

``` r
CBA(
  formula,
  data,
  pruning = "M1",
  parameter = NULL,
  control = NULL,
  balanceSupport = FALSE,
  disc.method = "mdlp",
  verbose = FALSE,
  ...
)

pruneCBA_M1(formula, rules, transactions, verbose = FALSE)

pruneCBA_M2(formula, rules, transactions, verbose = FALSE)
```

## Arguments

- formula:

  A symbolic description of the model to be fitted. Has to be of form
  `class ~ .` or `class ~ predictor1 + predictor2`.

- data:

  [arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
  containing the training data or a data.frame which. is automatically
  discretized and converted to transactions with
  [`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md).

- pruning:

  Pruning strategy used: "M1" or "M2".

- parameter, control:

  Optional parameter and control lists for apriori.

- balanceSupport:

  balanceSupport parameter passed to
  [`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md)
  function.

- disc.method:

  Discretization method used to discretize continuous variables if data
  is a data.frame (default: `"mdlp"`). See
  [`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md)
  for more supervised discretization methods.

- verbose:

  Show progress?

- ...:

  For convenience, additional parameters are used to create the
  `parameter` control list for apriori (e.g., to specify the support and
  confidence thresholds).

- rules, transactions:

  prune a set of rules using a transaction set.

## Value

Returns an object of class CBA representing the trained classifier.

## Details

Implementation the CBA algorithm with the M1 or M2 pruning strategy
introduced by Liu, et al. (1998).

Candidate classification association rules (CARs) are mined with the
APRIORI algorithm but minimum support is only checked for the LHS (rule
coverage) and not the whole rule. Rules are ranked by confidence,
support and size. Then either the M1 or M2 algorithm are used to perform
database coverage pruning and default rule pruning.

## References

Liu, B. Hsu, W. and Ma, Y (1998). Integrating Classification and
Association Rule Mining. **KDD'98 Proceedings of the Fourth
International Conference on Knowledge Discovery and Data Mining,** New
York, 27-31 August. AAAI. pp. 80-86.
<https://dl.acm.org/doi/10.5555/3000292.3000305>

## See also

Other classifiers:
[`CBA_ruleset()`](http://michael.hahsler.net/arulesCBA/reference/CBA_ruleset.md),
[`FOIL()`](http://michael.hahsler.net/arulesCBA/reference/FOIL.md),
[`LUCS_KDD_CBA`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md),
[`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md),
[`RWeka_CBA`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md),
[`predict.CBA()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)

## Author

Ian Johnson and Michael Hahsler

## Examples

``` r
data("iris")

# 1. Learn a classifier using automatic default discretization
classifier <- CBA(Species ~ ., data = iris, supp = 0.05, conf = 0.9)
classifier
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 8
#> Default Class: versicolor
#> Classification method: first  
#> Description: CBA algorithm (Liu et al., 1998)
#> 

# inspect the rule base
inspect(classifier$rules)
#>     lhs                            rhs                    support confidence  coverage     lift count size coveredTransactions totalErrors
#> [1] {Petal.Length=[-Inf,2.45)}  => {Species=setosa}     0.3333333  1.0000000 0.3333333 3.000000    50    2                  50          50
#> [2] {Sepal.Length=[6.15, Inf],                                                                                                            
#>      Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.2466667  1.0000000 0.2466667 3.000000    37    3                  37          13
#> [3] {Sepal.Length=[5.55,6.15),                                                                                                            
#>      Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.1400000  1.0000000 0.1400000 3.000000    21    3                  21          13
#> [4] {Sepal.Width=[-Inf,2.95),                                                                                                             
#>      Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.1133333  1.0000000 0.1133333 3.000000    17    3                   5           8
#> [5] {Sepal.Length=[6.15, Inf],                                                                                                            
#>      Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.0800000  1.0000000 0.0800000 3.000000    12    3                  12           8
#> [6] {Sepal.Width=[2.95,3.35),                                                                                                             
#>      Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.0800000  1.0000000 0.0800000 3.000000    12    3                   1           8
#> [7] {Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.3000000  0.9782609 0.3066667 2.934783    45    2                   4           6
#> [8] {}                          => {Species=versicolor} 0.3333333  0.3333333 1.0000000 1.000000   150    1                  20           6

# make predictions
predict(classifier, head(iris))
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica
table(pred = predict(classifier, iris), true = iris$Species)
#>             true
#> pred         setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         49         5
#>   virginica       0          1        45


# 2. Learn classifier from transactions (and use verbose)
iris_trans <- prepareTransactions(Species ~ ., iris, disc.method = "mdlp")
iris_trans
#> transactions in sparse format with
#>  150 transactions (rows) and
#>  15 items (columns)
classifier <- CBA(Species ~ ., data = iris_trans, supp = 0.05, conf = 0.9, verbose = TRUE)
#> 
#> Mining CARs...
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.9    0.1    1 none FALSE           FALSE       5    0.05      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 7 
#> 
#> set item appearances ...[15 item(s)] done [0.00s].
#> set transactions ...[15 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [15 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 5 done [0.00s].
#> writing ... [55 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
#> 
#> Pruning CARs...
#> CARs left: 8 
classifier
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 8
#> Default Class: versicolor
#> Classification method: first  
#> Description: CBA algorithm (Liu et al., 1998)
#> 

# make predictions. Note: response extracts class information from transactions.
predict(classifier, head(iris_trans))
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica
table(pred = predict(classifier, iris_trans), true = response(Species ~ ., iris_trans))
#>             true
#> pred         setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         49         5
#>   virginica       0          1        45
```
