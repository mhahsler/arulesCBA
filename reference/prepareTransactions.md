# Prepare Data for Associative Classification

Converts data.frame into transactions suitable for classification based
on association rules.

## Usage

``` r
prepareTransactions(
  formula,
  data,
  disc.method = "mdlp",
  logical2factor = TRUE,
  match = NULL
)
```

## Arguments

- formula:

  the formula.

- data:

  a data.frame with the data.

- disc.method:

  Discretization method used to discretize continuous variables if data
  is a data.frame (default: `"mdlp"`). See
  [`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md)
  for more supervised discretization methods.

- logical2factor:

  logical; if `data` is a data.frame, should logical columns be recoded
  as factor with TRUE/FALSE to generate positive and negative items?

- match:

  typically `NULL`. Only used internally if data is a already a set of
  transactions.

## Value

An object of class
[arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
from arules with an attribute called `"disc_info"` that contains
information on the used discretization for each column.

## Details

To convert a data.frame into items in a transaction dataset for
classification, the following steps are performed:

1.  All continuous features are discretized using class-based
    discretization (default is MDLP) and each range is represented as an
    item.

2.  Factors are converted into items, one item for each level.

3.  Each logical is converted into an item.

4.  If the class variable is a logical, then a negative class item is
    added.

Steps 1-3 are skipped if `data` is already a
[arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
object.

## See also

[arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html),
[`transactions2DF()`](http://michael.hahsler.net/arulesCBA/reference/transactions2DF.md).

Other preparation:
[`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md),
[`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md),
[`transactions2DF()`](http://michael.hahsler.net/arulesCBA/reference/transactions2DF.md)

## Author

Michael Hahsler

## Examples

``` r
# Perform discretization and convert to transactions
data("iris")
iris_trans <- prepareTransactions(Species ~ ., iris)

inspect(head(iris_trans))
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
#> [4] {Sepal.Length=[-Inf,5.55),               
#>      Sepal.Width=[2.95,3.35),                
#>      Petal.Length=[-Inf,2.45),               
#>      Petal.Width=[-Inf,0.8),                 
#>      Species=setosa}                        4
#> [5] {Sepal.Length=[-Inf,5.55),               
#>      Sepal.Width=[3.35, Inf],                
#>      Petal.Length=[-Inf,2.45),               
#>      Petal.Width=[-Inf,0.8),                 
#>      Species=setosa}                        5
#> [6] {Sepal.Length=[-Inf,5.55),               
#>      Sepal.Width=[3.35, Inf],                
#>      Petal.Length=[-Inf,2.45),               
#>      Petal.Width=[-Inf,0.8),                 
#>      Species=setosa}                        6
itemInfo(iris_trans)
#>                      labels    variables      levels
#> 1  Sepal.Length=[-Inf,5.55) Sepal.Length [-Inf,5.55)
#> 2  Sepal.Length=[5.55,6.15) Sepal.Length [5.55,6.15)
#> 3  Sepal.Length=[6.15, Inf] Sepal.Length [6.15, Inf]
#> 4   Sepal.Width=[-Inf,2.95)  Sepal.Width [-Inf,2.95)
#> 5   Sepal.Width=[2.95,3.35)  Sepal.Width [2.95,3.35)
#> 6   Sepal.Width=[3.35, Inf]  Sepal.Width [3.35, Inf]
#> 7  Petal.Length=[-Inf,2.45) Petal.Length [-Inf,2.45)
#> 8  Petal.Length=[2.45,4.75) Petal.Length [2.45,4.75)
#> 9  Petal.Length=[4.75, Inf] Petal.Length [4.75, Inf]
#> 10   Petal.Width=[-Inf,0.8)  Petal.Width  [-Inf,0.8)
#> 11   Petal.Width=[0.8,1.75)  Petal.Width  [0.8,1.75)
#> 12  Petal.Width=[1.75, Inf]  Petal.Width [1.75, Inf]
#> 13           Species=setosa      Species      setosa
#> 14       Species=versicolor      Species  versicolor
#> 15        Species=virginica      Species   virginica

# A negative class item is added for regular transaction data. Here we get the
# items "canned beer=TRUE" and "canned beer=FALSE".
# Note: backticks are needed in formulas with item labels that contain
# a space or special character.
data("Groceries")
g2 <- prepareTransactions(`canned beer` ~ ., Groceries)

inspect(head(g2))
#>     items                      
#> [1] {citrus fruit,             
#>      semi-finished bread,      
#>      margarine,                
#>      ready soups,              
#>      canned beer=FALSE}        
#> [2] {tropical fruit,           
#>      yogurt,                   
#>      coffee,                   
#>      canned beer=FALSE}        
#> [3] {whole milk,               
#>      canned beer=FALSE}        
#> [4] {pip fruit,                
#>      yogurt,                   
#>      cream cheese ,            
#>      meat spreads,             
#>      canned beer=FALSE}        
#> [5] {other vegetables,         
#>      whole milk,               
#>      condensed milk,           
#>      long life bakery product, 
#>      canned beer=FALSE}        
#> [6] {whole milk,               
#>      butter,                   
#>      yogurt,                   
#>      rice,                     
#>      abrasive cleaner,         
#>      canned beer=FALSE}        
ii <- itemInfo(g2)
ii[ii[["variables"]] == "canned beer", ]
#>                labels level2 level1   variables levels
#> 109  canned beer=TRUE   beer drinks canned beer   TRUE
#> 170 canned beer=FALSE   <NA>   <NA> canned beer  FALSE
```
