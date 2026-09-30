# Mine Class Association Rules

Class Association Rules (CARs) are association rules that have only
items with class values in the RHS as introduced for the CBA algorithm
by Liu et al., 1998.

## Usage

``` r
mineCARs(
  formula,
  transactions,
  parameter = NULL,
  control = NULL,
  balanceSupport = FALSE,
  verbose = TRUE,
  ...
)
```

## Arguments

- formula:

  A symbolic description of the model to be fitted.

- transactions:

  An object of class
  [arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
  containing the training data.

- parameter, control:

  Optional parameter and control lists for
  [`arules::apriori()`](https://rdrr.io/pkg/arules/man/apriori.html).

- balanceSupport:

  logical; if `TRUE`, class imbalance is counteracted by using class
  specific minimum support values. Alternatively, a support value for
  each class can be specified (see Details section).

- verbose:

  logical; report progress?

- ...:

  For convenience, the mining parameters for
  [`arules::apriori()`](https://rdrr.io/pkg/arules/man/apriori.html) can
  be specified as .... Examples are the `support` and `confidence`
  thresholds, and the `maxlen` of rules.

## Value

Returns an object of class
[arules::rules](https://rdrr.io/pkg/arules/man/rules-class.html).

## Details

Class association rules (CARs) are of the form

\$\$P \Rightarrow c_i,\$\$

where the LHS \\P\\ is a pattern (i.e., an itemset) and \\c_i\\ is a
single item representing the class label.

**Mining parameters.** Mining parameters for
[`arules::apriori()`](https://rdrr.io/pkg/arules/man/apriori.html) can
be either specified as a list (or object of
[arules::APparameter](https://rdrr.io/pkg/arules/man/ASparameter-classes.html))
as argument `parameter` or, for convenience, as arguments in `...`.
*Note:* `mineCARs()` uses by default a minimum support of 0.1 (for the
LHS of the rules via parameter `originalSupport = FALSE`), a minimum
confidence of 0.5 and a `maxlen` (rule length including items in the LHS
and RHS) of 5.

**Balancing minimum support.** Using a single minimum support threshold
for a highly imbalanced dataset can leave minority classes represented
by very few rules. To address this issue, `balanceSupport = TRUE`
adjusts the minimum support for each class according to its prevalence
(i.e., the frequency of \\c_i\\ in the transactions). Following the
minimum class support suggested for CBA by Liu et al. (2000), we use

\$\$minsupp_i = minsupp_t \frac{supp(c_i)}{max(supp(C))},\$\$

where \\max(supp(C))\\ is the support of the majority class. Therefore,
the defined minimum support is used for the majority class and then
minimum support is scaled down for less prevalent classes, giving them a
chance to produce a reasonable number of rules. A named numeric vector
with a support value for each class can also be specified.

## References

Liu, B. Hsu, W. and Ma, Y (1998). Integrating Classification and
Association Rule Mining. *KDD'98 Proceedings of the Fourth International
Conference on Knowledge Discovery and Data Mining,* New York, 27-31
August. AAAI. pp. 80-86.

Liu B., Ma Y., Wong C.K. (2000) Improving an Association Rule Based
Classifier. In: Zighed D.A., Komorowski J., Zytkow J. (eds) *Principles
of Data Mining and Knowledge Discovery. PKDD 2000. Lecture Notes in
Computer Science*, vol 1910. Springer, Berlin, Heidelberg.

## See also

Other preparation:
[`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md),
[`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md),
[`transactions2DF()`](http://michael.hahsler.net/arulesCBA/reference/transactions2DF.md)

## Author

Michael Hahsler

## Examples

``` r
data("iris")

# discretize and convert to transactions
iris.trans <- prepareTransactions(Species ~ ., iris)

# mine CARs with items for "Species" in the RHS.
# Note: mineCARs uses a default minimum coverage (LHS support) of 0.1, a
#       minimum confidence of .5 and maxlen of 5
cars <- mineCARs(Species ~ ., iris.trans)
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.5    0.1    1 none FALSE           FALSE       5     0.1      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 15 
#> 
#> set item appearances ...[15 item(s)] done [0.00s].
#> set transactions ...[15 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [15 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 5 done [0.00s].
#> writing ... [58 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
inspect(head(cars))
#>     lhs                           rhs                  support   confidence
#> [1] {Sepal.Length=[5.55,6.15)} => {Species=versicolor} 0.1533333 0.6388889 
#> [2] {Sepal.Width=[3.35, Inf]}  => {Species=setosa}     0.2066667 0.8378378 
#> [3] {Petal.Length=[2.45,4.75)} => {Species=versicolor} 0.2933333 0.9777778 
#> [4] {Petal.Width=[1.75, Inf]}  => {Species=virginica}  0.3000000 0.9782609 
#> [5] {Petal.Length=[-Inf,2.45)} => {Species=setosa}     0.3333333 1.0000000 
#> [6] {Petal.Width=[-Inf,0.8)}   => {Species=setosa}     0.3333333 1.0000000 
#>     coverage  lift     count
#> [1] 0.2400000 1.916667 23   
#> [2] 0.2466667 2.513514 31   
#> [3] 0.3000000 2.933333 44   
#> [4] 0.3066667 2.934783 45   
#> [5] 0.3333333 3.000000 50   
#> [6] 0.3333333 3.000000 50   

# specify minimum support and confidence
cars <- mineCARs(Species ~ ., iris.trans,
  parameter = list(support = 0.3, confidence = 0.9, maxlen = 3))
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.9    0.1    1 none FALSE           FALSE       5     0.3      1
#>  maxlen target  ext
#>       3  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 45 
#> 
#> set item appearances ...[15 item(s)] done [0.00s].
#> set transactions ...[15 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [13 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [10 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
inspect(head(cars))
#>     lhs                            rhs                    support confidence  coverage     lift count
#> [1] {Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.2933333  0.9777778 0.3000000 2.933333    44
#> [2] {Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.3000000  0.9782609 0.3066667 2.934783    45
#> [3] {Petal.Length=[-Inf,2.45)}  => {Species=setosa}     0.3333333  1.0000000 0.3333333 3.000000    50
#> [4] {Petal.Width=[-Inf,0.8)}    => {Species=setosa}     0.3333333  1.0000000 0.3333333 3.000000    50
#> [5] {Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.3266667  0.9074074 0.3600000 2.722222    49
#> [6] {Petal.Length=[2.45,4.75),                                                                       
#>      Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.2933333  0.9777778 0.3000000 2.933333    44

# for convenience this can also be written without a list for parameter using ...
cars <- mineCARs(Species ~ ., iris.trans, support = 0.3, confidence = 0.9, maxlen = 3)
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.9    0.1    1 none FALSE           FALSE       5     0.3      1
#>  maxlen target  ext
#>       3  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 45 
#> 
#> set item appearances ...[15 item(s)] done [0.00s].
#> set transactions ...[15 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [13 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [10 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].

# restrict the predictors to items starting with "Sepal"
cars <- mineCARs(Species ~ Sepal.Length + Sepal.Width, iris.trans)
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.5    0.1    1 none FALSE           FALSE       5     0.1      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 15 
#> 
#> set item appearances ...[9 item(s)] done [0.00s].
#> set transactions ...[9 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [9 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [10 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
inspect(cars)
#>      lhs                            rhs                     support confidence  coverage     lift count
#> [1]  {Sepal.Length=[5.55,6.15)}  => {Species=versicolor} 0.15333333  0.6388889 0.2400000 1.916667    23
#> [2]  {Sepal.Width=[3.35, Inf]}   => {Species=setosa}     0.20666667  0.8378378 0.2466667 2.513514    31
#> [3]  {Sepal.Length=[-Inf,5.55)}  => {Species=setosa}     0.31333333  0.7966102 0.3933333 2.389831    47
#> [4]  {Sepal.Width=[-Inf,2.95)}   => {Species=versicolor} 0.22666667  0.5964912 0.3800000 1.789474    34
#> [5]  {Sepal.Length=[6.15, Inf]}  => {Species=virginica}  0.26000000  0.7090909 0.3666667 2.127273    39
#> [6]  {Sepal.Length=[5.55,6.15),                                                                        
#>       Sepal.Width=[-Inf,2.95)}   => {Species=versicolor} 0.10666667  0.6956522 0.1533333 2.086957    16
#> [7]  {Sepal.Length=[-Inf,5.55),                                                                        
#>       Sepal.Width=[3.35, Inf]}   => {Species=setosa}     0.18666667  1.0000000 0.1866667 3.000000    28
#> [8]  {Sepal.Length=[-Inf,5.55),                                                                        
#>       Sepal.Width=[2.95,3.35)}   => {Species=setosa}     0.11333333  0.9444444 0.1200000 2.833333    17
#> [9]  {Sepal.Length=[6.15, Inf],                                                                        
#>       Sepal.Width=[2.95,3.35)}   => {Species=virginica}  0.14000000  0.7241379 0.1933333 2.172414    21
#> [10] {Sepal.Length=[6.15, Inf],                                                                        
#>       Sepal.Width=[-Inf,2.95)}   => {Species=virginica}  0.08666667  0.6190476 0.1400000 1.857143    13

# using different support for each class
cars <- mineCARs(Species ~ ., iris.trans, balanceSupport = c(
  "Species=setosa" = 0.1,
  "Species=versicolor" = 0.5,
  "Species=virginica" = 0.01), confidence = 0.9)
#> 
#> *** Mining CARs for class Species=setosa ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.9    0.1    1 none FALSE           FALSE       5     0.1      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 15 
#> 
#> set item appearances ...[13 item(s)] done [0.00s].
#> set transactions ...[13 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [13 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 5 done [0.00s].
#> writing ... [20 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
#> 
#> *** Mining CARs for class Species=versicolor ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.9      0    1 none FALSE           FALSE       5     0.5      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 75 
#> 
#> set item appearances ...[13 item(s)] done [0.00s].
#> set transactions ...[13 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [0 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 done [0.00s].
#> writing ... [0 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
#> 
#> *** Mining CARs for class Species=virginica ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.9      0    1 none FALSE           FALSE       5    0.01      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 1 
#> 
#> set item appearances ...[13 item(s)] done [0.00s].
#> set transactions ...[13 item(s), 150 transaction(s)] done [0.00s].
#> sorting and recoding items ... [13 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 5 done [0.00s].
#> writing ... [23 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
cars
#> set of 43 rules 

# balance support for class imbalance
data("Lymphography")
Lymphography_trans <- as(Lymphography, "transactions")

classFrequency(class ~ ., Lymphography_trans)
#> 
#>  normalfind  metastases malignlymph    fibrosis 
#>  0.01360544  0.55102041  0.40816327  0.02721088 

# mining does not produce CARs for the minority classes
cars <- mineCARs(class ~ ., Lymphography_trans, support = .3, maxlen = 3)
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.5    0.1    1 none FALSE           FALSE       5     0.3      1
#>  maxlen target  ext
#>       3  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 44 
#> 
#> set item appearances ...[64 item(s)] done [0.00s].
#> set transactions ...[64 item(s), 147 transaction(s)] done [0.00s].
#> sorting and recoding items ... [40 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [149 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
classFrequency(class ~ ., cars, type = "absolute")
#> 
#>  normalfind  metastases malignlymph    fibrosis 
#>           0          96          53           0 

# Balance support by reducing the minimum support for minority classes
cars <- mineCARs(class ~ ., Lymphography_trans, support = .3, maxlen = 3,
  balanceSupport = TRUE)
#> 
#> *** Mining CARs for class class=normalfind ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime     support minlen
#>         0.5    0.1    1 none FALSE           FALSE       5 0.007407407      1
#>  maxlen target  ext
#>       3  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 1 
#> 
#> set item appearances ...[61 item(s)] done [0.00s].
#> set transactions ...[61 item(s), 147 transaction(s)] done [0.00s].
#> sorting and recoding items ... [60 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [45 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
#> 
#> *** Mining CARs for class class=metastases ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.5      0    1 none FALSE           FALSE       5     0.3      1
#>  maxlen target  ext
#>       3  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 44 
#> 
#> set item appearances ...[61 item(s)] done [0.00s].
#> set transactions ...[61 item(s), 147 transaction(s)] done [0.00s].
#> sorting and recoding items ... [39 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [96 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
#> 
#> *** Mining CARs for class class=malignlymph ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime   support minlen
#>         0.5      0    1 none FALSE           FALSE       5 0.2222222      1
#>  maxlen target  ext
#>       3  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 32 
#> 
#> set item appearances ...[61 item(s)] done [0.00s].
#> set transactions ...[61 item(s), 147 transaction(s)] done [0.00s].
#> sorting and recoding items ... [42 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [88 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
#> 
#> *** Mining CARs for class class=fibrosis ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime    support minlen
#>         0.5      0    1 none FALSE           FALSE       5 0.01481481      1
#>  maxlen target  ext
#>       3  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 2 
#> 
#> set item appearances ...[61 item(s)] done [0.00s].
#> set transactions ...[61 item(s), 147 transaction(s)] done [0.00s].
#> sorting and recoding items ... [60 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 done [0.00s].
#> writing ... [36 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
classFrequency(class ~ ., cars, type = "absolute")
#> 
#>  normalfind  metastases malignlymph    fibrosis 
#>          45          96          88          36 

# Mine CARs from regular transactions (a negative class item is automatically added)
data(Groceries)
cars <- mineCARs(`whole milk` ~ ., Groceries,
  balanceSupport = TRUE, support = 0.01, confidence = 0.8)
#> 
#> *** Mining CARs for class whole milk=TRUE ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime     support minlen
#>         0.8    0.1    1 none FALSE           FALSE       5 0.003432122      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 33 
#> 
#> set item appearances ...[169 item(s)] done [0.00s].
#> set transactions ...[169 item(s), 9835 transaction(s)] done [0.00s].
#> sorting and recoding items ... [138 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 5 done [0.00s].
#> writing ... [1 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
#> 
#> *** Mining CARs for class whole milk=FALSE ***
#> Apriori
#> 
#> Parameter specification:
#>  confidence minval smax arem  aval originalSupport maxtime support minlen
#>         0.8      0    1 none FALSE           FALSE       5    0.01      1
#>  maxlen target  ext
#>       5  rules TRUE
#> 
#> Algorithmic control:
#>  filter tree heap memopt load sort verbose
#>     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
#> 
#> Absolute minimum support count: 98 
#> 
#> set item appearances ...[169 item(s)] done [0.00s].
#> set transactions ...[169 item(s), 9835 transaction(s)] done [0.00s].
#> sorting and recoding items ... [100 item(s)] done [0.00s].
#> creating transaction tree ... done [0.00s].
#> checking subsets of size 1 2 3 4 done [0.00s].
#> writing ... [7 rule(s)] done [0.00s].
#> creating S4 object  ... done [0.00s].
inspect(sort(cars, by = "lift"))
#>     lhs                    rhs                    support confidence    coverage     lift count
#> [1] {other vegetables,                                                                         
#>      curd,                                                                                     
#>      domestic eggs}     => {whole milk=TRUE}  0.002846975  0.8235294 0.003457041 3.223005    28
#> [2] {liquor}            => {whole milk=FALSE} 0.010472801  0.9449541 0.011082867 1.269274   103
#> [3] {canned beer,                                                                              
#>      shopping bags}     => {whole milk=FALSE} 0.010167768  0.8928571 0.011387900 1.199297   100
#> [4] {canned beer}       => {whole milk=FALSE} 0.068835791  0.8861257 0.077681749 1.190255   677
#> [5] {UHT-milk}          => {whole milk=FALSE} 0.029486528  0.8814590 0.033451957 1.183986   290
#> [6] {white wine}        => {whole milk=FALSE} 0.016370107  0.8609626 0.019013726 1.156455   161
#> [7] {bottled water,                                                                            
#>      shopping bags}     => {whole milk=FALSE} 0.008845958  0.8055556 0.010981190 1.082032    87
#> [8] {rolls/buns,                                                                               
#>      canned beer}       => {whole milk=FALSE} 0.009049314  0.8018018 0.011286223 1.076990    89
```
