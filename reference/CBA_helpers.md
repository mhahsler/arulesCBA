# Helper Functions for Dealing with Classes

Helper functions to extract the response from transactions or rules,
determine the class frequency, majority class, transaction coverage and
the uncovered examples per class.

## Usage

``` r
classes(formula, x)

response(formula, x)

classFrequency(formula, x, type = "relative")

majorityClass(formula, transactions)

transactionCoverage(transactions, rules)

uncoveredClassExamples(formula, transactions, rules)

uncoveredMajorityClass(formula, transactions, rules)
```

## Arguments

- formula:

  A symbolic description of the model to be fitted.

- x, transactions:

  An object of class
  [arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
  or [arules::rules](https://rdrr.io/pkg/arules/man/rules-class.html).

- type:

  `"relative"` or `"absolute"` to return proportions or absolute counts.

- rules:

  A set of
  [arules::rules](https://rdrr.io/pkg/arules/man/rules-class.html).

## Value

`response()` returns the response label as a factor.

`classFrequency()` returns the item frequency for each class label as a
vector.

`majorityClass()` returns the most frequent class label in the
transactions.

## See also

[`arules::itemFrequency()`](https://rdrr.io/pkg/arules/man/itemFrequency.html),
[arules::rules](https://rdrr.io/pkg/arules/man/rules-class.html),
[arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html).

## Author

Michael Hahsler

## Examples

``` r
data("iris")

iris.disc <- discretizeDF.supervised(Species ~ ., iris)
iris.trans <- as(iris.disc, "transactions")
inspect(head(iris.trans, n = 3))
#>     items                       transactionID
#> [1] {Sepal.Length=[-Inf,5.55),               
#>      Sepal.Width=[3.35, Inf],                
#>      Petal.Length=[-Inf,2.45),               
#>      Petal.Width=[-Inf,0.8),                 
#>      Species=setosa}                        1
#> [2] {Sepal.Length=[-Inf,5.55),               
#>      Sepal.Width=[2.95,3.35),                
#>      Petal.Length=[-Inf,2.45),               
#>      Petal.Width=[-Inf,0.8),                 
#>      Species=setosa}                        2
#> [3] {Sepal.Length=[-Inf,5.55),               
#>      Sepal.Width=[2.95,3.35),                
#>      Petal.Length=[-Inf,2.45),               
#>      Petal.Width=[-Inf,0.8),                 
#>      Species=setosa}                        3

# convert the class items back to a class label
response(Species ~ ., head(iris.trans, n = 3))
#> [1] setosa setosa setosa
#> Levels: setosa versicolor virginica

# Class labels
classes(Species ~ ., iris.trans)
#> [1] "setosa"     "versicolor" "virginica" 

# Class distribution. The iris dataset is perfectly balanced.
classFrequency(Species ~ ., iris.trans)
#> 
#>     setosa versicolor  virginica 
#>  0.3333333  0.3333333  0.3333333 

# Majority class
# (Note: since all class frequencies for iris are the same, the first one is returned)
majorityClass(Species ~ ., iris.trans)
#> [1] setosa
#> Levels: setosa versicolor virginica

# Use for CARs
cars <- mineCARs(Species ~ ., iris.trans, parameter = list(support = 0.3))
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.5    0.1    1 none FALSE           FALSE       5     0.3      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 45 
#> 
#> set item appearances ...[15 item(s)] done [0.00s].
#> set transactions ...[15 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [15 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 5 done [0.00s].
#> writing ... [15 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].

#' # Class labels
classes(Species ~ ., cars)
#> [1] "setosa"     "versicolor" "virginica" 

# Number of rules for each class
classFrequency(Species ~ ., cars, type = "absolute")
#> 
#>     setosa versicolor  virginica 
#>          7          4          4 

# conclusion (item in the RHS) of the rule as a class label
response(Species ~ ., cars)
#>  [1] versicolor virginica  setosa     setosa     setosa     versicolor
#>  [7] versicolor virginica  virginica  versicolor virginica  setosa    
#> [13] setosa     setosa     setosa    
#> Levels: setosa versicolor virginica

# How many rules (using the first three rules) cover each transaction?
transactionCoverage(iris.trans, cars[1:3])
#>   [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#>  [38] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1
#>  [75] 1 1 0 0 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#> [112] 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 0 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1
#> [149] 1 1

# Number of transactions per class not covered by the first three rules
uncoveredClassExamples(Species ~ ., iris.trans, cars[1:3])
#> 
#>     setosa versicolor  virginica 
#>          0          5          4 

# Majority class of the uncovered examples
uncoveredMajorityClass(Species ~ ., iris.trans, cars[1:3])
#> [1] "versicolor"
```
