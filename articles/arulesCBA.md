# Getting started with arulesCBA

`arulesCBA` builds classifiers from class association rules (CARs). A
CAR has predictor conditions on its left-hand side and a class label on
its right-hand side. This makes the resulting model inspectable: a
prediction can be traced back to one or more rules.

This guide shows the typical workflow:

1.  split a data frame into training and test data;
2.  learn a CBA classifier;
3.  inspect its rule base; and
4.  predict classes and evaluate accuracy.

## Installation

Install the released version from CRAN:

``` r

install.packages("arulesCBA")
```

Then load the package:

``` r

library(arulesCBA)
```

Loading `arulesCBA` also makes the transaction and rule infrastructure
from `arules` available.

## Train a classifier

We use the numeric measurements in `iris` to predict `Species`. Keep a
test set aside so that evaluation uses observations that were not used
to build the classifier.

``` r

train_id <- sample(seq_len(nrow(iris)), 100)
iris_train <- iris[train_id, ]
iris_test <- iris[-train_id, ]

table(iris_train$Species)
#> 
#>     setosa versicolor  virginica 
#>         32         32         36
table(iris_test$Species)
#> 
#>     setosa versicolor  virginica 
#>         18         18         14
```

[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md) accepts
the same formula-and-data interface as many R modeling functions.
Numeric predictors are discretized automatically because association
rules operate on items rather than continuous values.

``` r

classifier <- CBA(Species ~ ., data = iris_train)
classifier
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 4
#> Default Class: virginica
#> Classification method: first  
#> Description: CBA algorithm (Liu et al., 1998)
```

The printed model reports the number of retained rules, the default
class, and the classification strategy. CBA ranks candidate rules,
prunes the rule base, and uses the first matching rule for prediction.
If no rule matches, it uses the default class.

## Inspect the learned rules

The rules are stored in `classifier$rules` as an `arules` `rules`
object. The first few rules can be displayed with
[`inspect()`](https://rdrr.io/pkg/arules/man/inspect.html):

``` r

inspect(head(classifier$rules, 5))
#>     lhs                            rhs                  support confidence coverage     lift count size coveredTransactions totalErrors
#> [1] {Petal.Length=[-Inf,2.6)}   => {Species=setosa}        0.32       1.00     0.32 3.125000    32    2                  32          32
#> [2] {Petal.Length=[4.85, Inf],                                                                                                         
#>      Petal.Width=[1.65, Inf]}   => {Species=virginica}     0.31       1.00     0.31 2.777778    31    3                  31           5
#> [3] {Petal.Length=[2.6,4.85),                                                                                                          
#>      Petal.Width=[0.7,1.65)}    => {Species=versicolor}    0.30       1.00     0.30 3.125000    30    3                  30           2
#> [4] {}                          => {Species=virginica}     0.36       0.36     1.00 1.000000   100    1                   7           2
```

A rule such as `{Petal.Length=[-Inf,1.9)} => {Species=setosa}` says that
observations whose petal length falls in that interval are predicted as
`setosa`. The exact intervals depend on the training sample.

The most important rule quality measures are:

- **support:** the proportion of training observations covered by the
  rule’s conditions;
- **confidence:** the proportion of covered observations that have the
  class shown on the right-hand side; and
- **lift:** the confidence relative to the prevalence of that class.

Quality measures are available as a data frame, so they can be
summarized or used to select rules.

``` r

summary(quality(classifier$rules)[, c("support", "confidence", "lift")])
#>     support         confidence        lift      
#>  Min.   :0.3000   Min.   :0.36   Min.   :1.000  
#>  1st Qu.:0.3075   1st Qu.:0.84   1st Qu.:2.333  
#>  Median :0.3150   Median :1.00   Median :2.951  
#>  Mean   :0.3225   Mean   :0.84   Mean   :2.507  
#>  3rd Qu.:0.3300   3rd Qu.:1.00   3rd Qu.:3.125  
#>  Max.   :0.3600   Max.   :1.00   Max.   :3.125
```

## Predict and evaluate

Pass the original, undiscretized data frame to
[`predict()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md).
The classifier stores the cut points learned from the training data and
applies the same cut points to new observations.

``` r

prediction <- predict(classifier, iris_test)
head(prediction)
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica
```

A confusion matrix shows which classes were confused.
[`accuracy()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)
calculates the overall fraction classified correctly.

``` r

table(predicted = prediction, observed = iris_test$Species)
#>             observed
#> predicted    setosa versicolor virginica
#>   setosa         18          0         0
#>   versicolor      0         15         0
#>   virginica       0          3        14
accuracy(prediction, iris_test$Species)
#> [1] 0.94
```

For a reliable estimate of predictive performance, use repeated
train/test splits or cross-validation rather than reporting accuracy on
the training data.

## Control rule mining

The most commonly adjusted mining parameters are minimum support,
minimum confidence, and maximum rule length. They can be supplied
directly to
[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md):

``` r

classifier_tuned <- CBA(
  Species ~ .,
  data = iris_train,
  support = 0.05,
  confidence = 0.9,
  maxlen = 4
)
classifier_tuned
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 4
#> Default Class: virginica
#> Classification method: first  
#> Description: CBA algorithm (Liu et al., 1998)
```

Lower support typically produces more candidate rules, while higher
confidence requires rules to be more reliable on the training data.
Increasing `maxlen` allows more conditions in a rule. These settings
affect both runtime and model complexity; very low support or a large
`maxlen` can produce an extremely large candidate rule set.

The same settings can instead be passed in a named list:

``` r

classifier <- CBA(
  Species ~ .,
  data = iris_train,
  parameter = list(support = 0.05, confidence = 0.9, maxlen = 4)
)
```

For imbalanced data, `balanceSupport = TRUE` lowers the minimum support
for minority classes relative to the majority class:

``` r

classifier_balanced <- CBA(
  class ~ .,
  data = training_data,
  support = 0.1,
  confidence = 0.8,
  balanceSupport = TRUE
)
```

## Prepare and mine rules separately

[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md) handles
data preparation, rule mining, and pruning in one call. The individual
steps are also available when more control is needed.

[`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md)
discretizes numeric predictors and converts every row to a transaction.
Class values become items that can appear on the right-hand side of a
CAR.

``` r

iris_transactions <- prepareTransactions(Species ~ ., iris_train)
iris_transactions
#> transactions in sparse format with
#>  100 transactions (rows) and
#>  14 items (columns)
inspect(head(iris_transactions, 3))
#>     items                       transactionID
#> [1] {Sepal.Length=[-Inf,5.45),               
#>      Sepal.Width=[2.95, Inf],                
#>      Petal.Length=[-Inf,2.6),                
#>      Petal.Width=[-Inf,0.7),                 
#>      Species=setosa}                      28 
#> [2] {Sepal.Length=[5.45,6.25),               
#>      Sepal.Width=[-Inf,2.95),                
#>      Petal.Length=[2.6,4.85),                
#>      Petal.Width=[0.7,1.65),                 
#>      Species=versicolor}                  80 
#> [3] {Sepal.Length=[6.25, Inf],               
#>      Sepal.Width=[2.95, Inf],                
#>      Petal.Length=[4.85, Inf],               
#>      Petal.Width=[1.65, Inf],                
#>      Species=virginica}                   101
```

[`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md)
restricts the right-hand side of every mined rule to a value of the
response variable.

``` r

cars <- mineCARs(
  Species ~ .,
  iris_transactions,
  support = 0.1,
  confidence = 0.8,
  maxlen = 4,
  verbose = FALSE
)
cars
#> set of 41 rules
inspect(head(cars, 5))
#>     lhs                           rhs                  support confidence
#> [1] {Petal.Length=[-Inf,2.6)}  => {Species=setosa}     0.32    1.0000000 
#> [2] {Petal.Width=[-Inf,0.7)}   => {Species=setosa}     0.32    1.0000000 
#> [3] {Sepal.Length=[-Inf,5.45)} => {Species=setosa}     0.31    0.8857143 
#> [4] {Petal.Length=[2.6,4.85)}  => {Species=versicolor} 0.31    0.9393939 
#> [5] {Petal.Width=[0.7,1.65)}   => {Species=versicolor} 0.31    0.9117647 
#>     coverage lift     count
#> [1] 0.32     3.125000 32   
#> [2] 0.32     3.125000 32   
#> [3] 0.35     2.767857 31   
#> [4] 0.33     2.935606 31   
#> [5] 0.34     2.849265 31
```

These lower-level functions are useful for studying the candidate rules
or for constructing a custom classifier with
[`CBA_ruleset()`](http://michael.hahsler.net/arulesCBA/reference/CBA_ruleset.md).
For a first analysis, the higher-level
[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md)
interface is usually sufficient.

## Other classifiers

The package includes several other associative classification
algorithms, including
[`FOIL()`](http://michael.hahsler.net/arulesCBA/reference/FOIL.md),
[`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md),
[`CMAR()`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md),
[`CPAR()`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md),
and
[`PRM()`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md).
It also provides wrappers for rule learners from `RWeka`. Some of these
methods require Java and additional suggested packages; see their help
pages for requirements and algorithm-specific options.

``` r

help(package = "arulesCBA")
?CBA
?mineCARs
?CBA_ruleset
```
