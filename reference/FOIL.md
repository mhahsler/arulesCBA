# Use FOIL to learn a rule set for classification

Build a classifier rule base using FOIL (First Order Inductive Learner),
a greedy algorithm that learns rules to distinguish positive from
negative examples.

## Usage

``` r
FOIL(
  formula,
  data,
  max_len = 3,
  min_gain = 0.7,
  best_k = 5,
  disc.method = "mdlp"
)
```

## Arguments

- formula:

  A symbolic description of the model to be fitted. Has to be of form
  `class ~ .` or `class ~ predictor1 + predictor2`.

- data:

  A data.frame or
  [arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
  containing the training data. Data frames are automatically
  discretized and converted to transactions with
  [`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md).

- max_len:

  maximal length of the LHS of the created rules.

- min_gain:

  minimal gain required to expand a rule.

- best_k:

  use the average expected accuracy (laplace) of the best k rules per
  class for prediction.

- disc.method:

  Discretization method used to discretize continuous variables if data
  is a data.frame (default: `"mdlp"`). See
  [`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md)
  for more supervised discretization methods.

## Value

Returns an object of class
[CBA](http://michael.hahsler.net/arulesCBA/reference/CBA.md)
representing the trained classifier.

## Details

Implements FOIL (Quinlan and Cameron-Jones, 1995) to learn rules and
then use them as a classifier following Xiaoxin and Han (2003).

For each class, we find the positive and negative examples and learn the
rules using FOIL. Then the rules for all classes are combined and sorted
by Laplace accuracy on the training data.

Following Xiaoxin and Han (2003), we classify new examples by

1.  select all the rules whose bodies are satisfied by the example;

2.  from the rules select the best k rules per class (highest expected
    Laplace accuracy);

3.  average the expected Laplace accuracy per class and choose the class
    with the highest average.

## References

Quinlan, J.R., Cameron-Jones, R.M. Induction of logic programs: FOIL and
related systems. NGCO 13, 287-312 (1995).
[doi:10.1007/BF03037228](https://doi.org/10.1007/BF03037228)

Yin, Xiaoxin and Jiawei Han. CPAR: Classification based on Predictive
Association Rules, SDM, 2003.
[doi:10.1137/1.9781611972733.40](https://doi.org/10.1137/1.9781611972733.40)

## See also

Other classifiers:
[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md),
[`CBA_ruleset()`](http://michael.hahsler.net/arulesCBA/reference/CBA_ruleset.md),
[`LUCS_KDD_CBA`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md),
[`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md),
[`RWeka_CBA`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md),
[`predict.CBA()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)

## Author

Michael Hahsler

## Examples

``` r
data("iris")

# learn a classifier using automatic default discretization
classifier <- FOIL(Species ~ ., data = iris)
classifier
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 9
#> Default Class: setosa
#> Classification method: weighted  - using best 5 rules
#> Description: FOIL-based classifier (Yin and Han, 2003)
#> 

# inspect the rule base
inspect(classifier$rules)
#>     lhs                            rhs                      support confidence      lift   laplace
#> [1] {Petal.Length=[-Inf,2.45)}  => {Species=setosa}     0.333333333 1.00000000 3.0000000 0.9622642
#> [2] {Sepal.Length=[6.15, Inf],                                                                    
#>      Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.246666667 1.00000000 3.0000000 0.9500000
#> [3] {Petal.Length=[4.75, Inf],                                                                    
#>      Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.300000000 0.97826087 2.9347826 0.9387755
#> [4] {Petal.Length=[2.45,4.75),                                                                    
#>      Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.293333333 0.97777778 2.9333333 0.9375000
#> [5] {Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.326666667 0.89090909 2.6727273 0.8620690
#> [6] {Sepal.Length=[5.55,6.15),                                                                    
#>      Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.146666667 0.91666667 2.7500000 0.8518519
#> [7] {Sepal.Length=[6.15, Inf],                                                                    
#>      Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.106666667 0.88888889 2.6666667 0.8095238
#> [8] {Sepal.Length=[5.55,6.15),                                                                    
#>      Sepal.Width=[2.95,3.35)}   => {Species=versicolor} 0.040000000 0.66666667 2.0000000 0.5833333
#> [9] {Sepal.Length=[-Inf,5.55),                                                                    
#>      Sepal.Width=[-Inf,2.95)}   => {Species=virginica}  0.006666667 0.07692308 0.2307692 0.1250000

# make predictions for the first few instances of iris
predict(classifier, head(iris))
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica
```
