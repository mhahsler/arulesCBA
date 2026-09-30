# Constructor for Objects for Classifiers Based on Association Rules

Objects for classifiers based on association rules have class `CBA`. A
creator function `CBA_ruleset()` and several methods are provided.

## Usage

``` r
CBA_ruleset(
  formula,
  rules,
  default,
  method = "first",
  weights = NULL,
  bias = NULL,
  model = NULL,
  discretization = NULL,
  description = "Custom rule set",
  ...
)
```

## Arguments

- formula:

  A symbolic description of the model to be fitted. Has to be of form
  `class ~ .`. The class is the variable name (part of the item label
  before `=`).

- rules:

  A set of class association rules mined with
  [`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md)
  or [`arules::apriori()`](https://rdrr.io/pkg/arules/man/apriori.html)
  (from arules).

- default:

  Default class. If not specified, objects that are not matched by rules
  are classified as `NA`.

- method:

  Classification method: `"first"` matching rule or `"majority"` vote.

- weights:

  Rule weights for the majority voting method. Specify either a quality
  measure available in the classification rule set or a numeric vector
  with one weight per rule. If missing, equal weights are used.

- bias:

  Class bias vector.

- model:

  An optional list with model information (e.g., parameters).

- discretization:

  A list with discretization information used by
  [`predict()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)
  to discretize data supplied as a `data.frame`.

- description:

  Description field used when the classifier is printed.

- ...:

  Additional arguments added as list elements to the CBA object.

## Value

An object of class `CBA` representing the trained classifier with
fields:

- formula:

  used formula.

- rules:

  the classifier rule base.

- default:

  default class label (uses partial matching against the class labels).

- method:

  classification method.

- weights:

  rule weights.

- bias:

  class bias vector if available.

- model:

  list with model description.

- discretization:

  discretization information.

- description:

  description in human-readable form.

`rules` returns the rule base.

## Details

`CBA_ruleset()` creates a new object of class `CBA` using the provided
rules as the rule base. For method `"first"`, the user needs to make
sure that the rules are predictive and sorted from most to least
predictive.

## See also

[`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md)

Other classifiers:
[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md),
[`FOIL()`](http://michael.hahsler.net/arulesCBA/reference/FOIL.md),
[`LUCS_KDD_CBA`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md),
[`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md),
[`RWeka_CBA`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md),
[`predict.CBA()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)

## Author

Michael Hahsler

## Examples

``` r
## Example 1: create a first-matching-rule classifier with non-redundant rules
##  sorted by confidence.
data("iris")

# discretize and create transactions
iris.disc <- discretizeDF.supervised(Species ~., iris)
trans <- as(iris.disc, "transactions")

# create rule base with CARs
cars <- mineCARs(Species ~ ., trans, parameter = list(support = .01, confidence = .8))
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.8    0.1    1 none FALSE           FALSE       5    0.01      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 1 
#> 
#> set item appearances ...[15 item(s)] done [0.00s].
#> set transactions ...[15 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [15 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 5 done [0.00s].
#> writing ... [97 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].

cars <- cars[!is.redundant(cars)]
cars <- sort(cars, by = "conf")

# create classifier and use the majority class as the default if no rule matches.
cl <- CBA_ruleset(Species ~ .,
  rules = cars,
  default = uncoveredMajorityClass(Species ~ ., trans, cars),
  method = "first")
cl
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 23
#> Default Class: setosa
#> Classification method: first  
#> Description: Custom rule set
#> 

# look at the rule base
inspect(cl$rules)
#>      lhs                            rhs                     support confidence   coverage     lift count
#> [1]  {Petal.Length=[-Inf,2.45)}  => {Species=setosa}     0.33333333  1.0000000 0.33333333 3.000000    50
#> [2]  {Petal.Width=[-Inf,0.8)}    => {Species=setosa}     0.33333333  1.0000000 0.33333333 3.000000    50
#> [3]  {Sepal.Length=[5.55,6.15),                                                                         
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.14000000  1.0000000 0.14000000 3.000000    21
#> [4]  {Sepal.Width=[3.35, Inf],                                                                          
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.03333333  1.0000000 0.03333333 3.000000     5
#> [5]  {Sepal.Length=[-Inf,5.55),                                                                         
#>       Sepal.Width=[3.35, Inf]}   => {Species=setosa}     0.18666667  1.0000000 0.18666667 3.000000    28
#> [6]  {Sepal.Length=[6.15, Inf],                                                                         
#>       Sepal.Width=[3.35, Inf]}   => {Species=virginica}  0.03333333  1.0000000 0.03333333 3.000000     5
#> [7]  {Sepal.Width=[3.35, Inf],                                                                          
#>       Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.03333333  1.0000000 0.03333333 3.000000     5
#> [8]  {Sepal.Length=[6.15, Inf],                                                                         
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.08000000  1.0000000 0.08000000 3.000000    12
#> [9]  {Sepal.Width=[2.95,3.35),                                                                          
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.08000000  1.0000000 0.08000000 3.000000    12
#> [10] {Sepal.Length=[6.15, Inf],                                                                         
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.24666667  1.0000000 0.24666667 3.000000    37
#> [11] {Sepal.Width=[-Inf,2.95),                                                                          
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.11333333  1.0000000 0.11333333 3.000000    17
#> [12] {Sepal.Length=[5.55,6.15),                                                                         
#>       Sepal.Width=[2.95,3.35),                                                                          
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.03333333  1.0000000 0.03333333 3.000000     5
#> [13] {Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.30000000  0.9782609 0.30666667 2.934783    45
#> [14] {Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.29333333  0.9777778 0.30000000 2.933333    44
#> [15] {Sepal.Length=[-Inf,5.55),                                                                         
#>       Sepal.Width=[2.95,3.35)}   => {Species=setosa}     0.11333333  0.9444444 0.12000000 2.833333    17
#> [16] {Sepal.Width=[2.95,3.35),                                                                          
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.09333333  0.9333333 0.10000000 2.800000    14
#> [17] {Sepal.Length=[5.55,6.15),                                                                         
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.14666667  0.9166667 0.16000000 2.750000    22
#> [18] {Sepal.Length=[-Inf,5.55),                                                                         
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.07333333  0.9166667 0.08000000 2.750000    11
#> [19] {Sepal.Length=[6.15, Inf],                                                                         
#>       Sepal.Width=[2.95,3.35),                                                                          
#>       Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.14000000  0.9130435 0.15333333 2.739130    21
#> [20] {Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.32666667  0.9074074 0.36000000 2.722222    49
#> [21] {Sepal.Length=[6.15, Inf],                                                                         
#>       Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.26000000  0.9069767 0.28666667 2.720930    39
#> [22] {Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.32666667  0.8909091 0.36666667 2.672727    49
#> [23] {Sepal.Width=[3.35, Inf]}   => {Species=setosa}     0.20666667  0.8378378 0.24666667 2.513514    31

# make predictions
prediction <- predict(cl, trans)
table(prediction, response(Species ~ ., trans))
#>             
#> prediction   setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         49         5
#>   virginica       0          1        45
accuracy(prediction, response(Species ~ ., trans))
#> [1] 0.96

# Example 2: use weighted majority voting.
cl <- CBA_ruleset(Species ~ .,
  rules = cars,
  default = uncoveredMajorityClass(Species ~ ., trans, cars),
  method = "majority", weights = "lift")
cl
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 23
#> Default Class: setosa
#> Classification method: majority  
#> Description: Custom rule set
#> 

prediction <- predict(cl, trans)
table(prediction, response(Species ~ ., trans))
#>             
#> prediction   setosa versicolor virginica
#>   setosa         50          0         0
#>   versicolor      0         45         3
#>   virginica       0          5        47
accuracy(prediction, response(Species ~ ., trans))
#> [1] 0.9466667

## Example 3: Create a classifier with no rules that always predicts
##  the majority class. Note, we need cars for the structure and subset it
##  to leave no rules.
cl <- CBA_ruleset(Species ~ .,
  rules = cars[NULL],
  default = majorityClass(Species ~ ., trans))
cl
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 0
#> Default Class: setosa
#> Classification method: first  
#> Description: Custom rule set
#> 

prediction <- predict(cl, trans)
table(prediction, response(Species ~ ., trans))
#>             
#> prediction   setosa versicolor virginica
#>   setosa         50         50        50
#>   versicolor      0          0         0
#>   virginica       0          0         0
accuracy(prediction, response(Species ~ ., trans))
#> [1] 0.3333333
```
