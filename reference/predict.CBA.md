# Model Prediction for Classifiers Based on Association Rules

Predicts classes for new data using a CBA classifier.

## Usage

``` r
# S3 method for class 'CBA'
predict(object, newdata, type = c("class", "score"), ...)

accuracy(pred, true)
```

## Arguments

- object:

  An object of class
  [CBA](http://michael.hahsler.net/arulesCBA/reference/CBA.md).

- newdata:

  A data.frame or
  [arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
  containing rows of new entries to be classified.

- type:

  Predict `"class"` labels. Some classifiers can also return `"scores"`.

- ...:

  Additional arguments are ignored.

- pred, true:

  two factors with the same level representing the predictions and the
  ground truth (e.g., obtained with
  [`response()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)).

## Value

A factor vector with the classification result.

## See also

Other classifiers:
[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md),
[`CBA_ruleset()`](http://michael.hahsler.net/arulesCBA/reference/CBA_ruleset.md),
[`FOIL()`](http://michael.hahsler.net/arulesCBA/reference/FOIL.md),
[`LUCS_KDD_CBA`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md),
[`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md),
[`RWeka_CBA`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md)

## Author

Michael Hahsler

## Examples

``` r
data("iris")

train_id <- sample(seq_len(nrow(iris)), 130)
iris_train <- iris[train_id, ]
iris_test <- iris[-train_id, ]

cl <- CBA(Species ~., iris_train)
pr <- predict(cl, iris_test)
pr
#>  [1] setosa     setosa     setosa     setosa     setosa     setosa    
#>  [7] versicolor versicolor versicolor versicolor versicolor virginica 
#> [13] virginica  virginica  virginica  virginica  virginica  virginica 
#> [19] virginica  virginica 
#> Levels: setosa versicolor virginica

accuracy(pr, response(Species ~., iris_test))
#> [1] 1
```
