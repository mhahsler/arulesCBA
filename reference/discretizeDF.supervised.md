# Supervised Methods to Convert Continuous Variables into Categorical Variables

This function implements several supervised methods to convert
continuous variables into categorical variables (factors) suitable for
association rule mining and building associative classifiers. A whole
data.frame is discretized (i.e., all numeric columns are discretized).

## Usage

``` r
discretizeDF.supervised(formula, data, method = "mdlp", dig.lab = 3, ...)
```

## Arguments

- formula:

  a formula object to specify the class variable for supervised
  discretization and the predictors to be discretized in the form
  `class ~ .` or `class ~ predictor1 + predictor2`.

- data:

  a data.frame containing continuous variables to be discretized

- method:

  Discretization method. Available methods are `"mdlp"`, `"caim"`,
  `"cacc"`, `"ameva"`, `"chi2"`, `"chimerge"`, `"extendedchi2"`, and
  `"modchi2"`.

- dig.lab:

  integer; number of digits used to create labels.

- ...:

  Additional parameters are passed on to the implementation of the
  chosen discretization method.

## Value

[`discretizeDF()`](https://rdrr.io/pkg/arules/man/discretize.html)
returns a discretized data.frame. Discretized columns have an attribute
`"discretized:breaks"` indicating the breaks used and
`"discretized:method"` giving the method used.

## Details

`discretizeDF.supervised()` only implements supervised discretization.
See
[`arules::discretizeDF()`](https://rdrr.io/pkg/arules/man/discretize.html)
in package arules for unsupervised discretization.

## See also

Unsupervised discretization from arules:
[`arules::discretize()`](https://rdrr.io/pkg/arules/man/discretize.html),
[`arules::discretizeDF()`](https://rdrr.io/pkg/arules/man/discretize.html).

Details about the available supervised discretization methods from
discretization:
[discretization::mdlp](https://rdrr.io/pkg/discretization/man/mdlp.html),
[discretization::caim](https://rdrr.io/pkg/discretization/man/caim.html),
[discretization::cacc](https://rdrr.io/pkg/discretization/man/cacc.html),
[discretization::ameva](https://rdrr.io/pkg/discretization/man/ameva.html),
[discretization::chi2](https://rdrr.io/pkg/discretization/man/chi2.html),
[discretization::chiM](https://rdrr.io/pkg/discretization/man/chiM.html),
[discretization::extendChi2](https://rdrr.io/pkg/discretization/man/extendChi2.html),
[discretization::modChi2](https://rdrr.io/pkg/discretization/man/modChi2.html).

Other preparation:
[`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md),
[`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md),
[`transactions2DF()`](http://michael.hahsler.net/arulesCBA/reference/transactions2DF.md)

## Author

Michael Hahsler

## Examples

``` r
data("iris")
summary(iris)
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
#>  Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
#>  1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
#>  Median :5.800   Median :3.000   Median :4.350   Median :1.300  
#>  Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
#>  3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
#>  Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
#>        Species  
#>  setosa    :50  
#>  versicolor:50  
#>  virginica :50  
#>                 
#>                 
#>                 

# supervised discretization using Species
iris.disc <- discretizeDF.supervised(Species ~ ., iris)
summary(iris.disc)
#>       Sepal.Length      Sepal.Width      Petal.Length      Petal.Width
#>  [-Inf,5.55):59    [-Inf,2.95):57   [-Inf,2.45):50    [-Inf,0.8) :50  
#>  [5.55,6.15):36    [2.95,3.35):56   [2.45,4.75):45    [0.8,1.75) :54  
#>  [6.15, Inf]:55    [3.35, Inf]:37   [4.75, Inf]:55    [1.75, Inf]:46  
#>        Species  
#>  setosa    :50  
#>  versicolor:50  
#>  virginica :50  

attributes(iris.disc$Sepal.Length)
#> $levels
#> [1] "[-Inf,5.55)" "[5.55,6.15)" "[6.15, Inf]"
#> 
#> $class
#> [1] "factor"
#> 
#> $`discretized:breaks`
#> [1] -Inf 5.55 6.15  Inf
#> 
#> $`discretized:method`
#> [1] "mdlp"
#> 

# discretize the first few instances of iris using the same breaks as iris.disc
discretizeDF(head(iris), methods = iris.disc)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1  [-Inf,5.55) [3.35, Inf]  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 2  [-Inf,5.55) [2.95,3.35)  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 3  [-Inf,5.55) [2.95,3.35)  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 4  [-Inf,5.55) [2.95,3.35)  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 5  [-Inf,5.55) [3.35, Inf]  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 6  [-Inf,5.55) [3.35, Inf]  [-Inf,2.45)  [-Inf,0.8)  setosa

# only discretize predictors Sepal.Length and Petal.Length
iris.disc2 <- discretizeDF.supervised(Species ~ Sepal.Length + Petal.Length, iris)
head(iris.disc2)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1  [-Inf,5.55)         3.5  [-Inf,2.45)         0.2  setosa
#> 2  [-Inf,5.55)         3.0  [-Inf,2.45)         0.2  setosa
#> 3  [-Inf,5.55)         3.2  [-Inf,2.45)         0.2  setosa
#> 4  [-Inf,5.55)         3.1  [-Inf,2.45)         0.2  setosa
#> 5  [-Inf,5.55)         3.6  [-Inf,2.45)         0.2  setosa
#> 6  [-Inf,5.55)         3.9  [-Inf,2.45)         0.4  setosa
```
