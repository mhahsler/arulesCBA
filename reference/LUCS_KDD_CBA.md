# Interface to the LUCS-KDD Implementations of CMAR, PRM and CPAR

Interface for the LUCS-KDD Software Library Java implementations of CMAR
(Li, Han and Pei, 2001), PRM, and CPAR (Yin and Han, 2003). **Note:**
The Java implementations are not part of arulesCBA and are free only for
**non-commercial use**.

## Usage

``` r
FOIL2(formula, data, best_k = 5, disc.method = "mdlp", verbose = FALSE)

CPAR(formula, data, best_k = 5, disc.method = "mdlp", verbose = FALSE)

PRM(formula, data, best_k = 5, disc.method = "mdlp", verbose = FALSE)

CMAR(
  formula,
  data,
  support = 0.1,
  confidence = 0.5,
  disc.method = "mdlp",
  verbose = FALSE
)
```

## Arguments

- formula:

  a symbolic description of the model to be fitted. Has to be of form
  `class ~ .` or `class ~ predictor1 + predictor2`.

- data:

  A data.frame or
  [arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html)
  containing the training data. Data frames are automatically
  discretized and converted to transactions with
  [`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md).

- best_k:

  use average expected accuracy of the best k rules per class for
  prediction.

- disc.method:

  Discretization method used to discretize continuous variables if data
  is a data.frame (default: `"mdlp"`). See
  [`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md)
  for more supervised discretization methods.

- verbose:

  Show verbose output?

- support, confidence:

  minimum support and minimum confidence thresholds for CMAR (range
  \\\[0, 1\]\\).

## Value

Returns an object of class
[CBA](http://michael.hahsler.net/arulesCBA/reference/CBA.md)
representing the trained classifier.

## Details

**Requirement:** The code needs a **JDK (Java Development Kit) version
1.8 (or higher)** installation. On some systems (Windows), you may need
to set the `JAVA_HOME` environment variable so the system finds the
compiler.

**Memory:** The memory for Java can be increased via R options. For
example: `options(java.parameters = "-Xmx1024m")`

**Note:** The implementation does not expose the min. gain parameter for
CPAR, PRM and FOIL2. It is fixed at 0.7 (the value used by Yin and Han,
2001). FOIL2 is an alternative Java implementation to the native
implementation of FOIL already provided in the arulesCBA.
[FOIL](http://michael.hahsler.net/arulesCBA/reference/FOIL.md) exposes
min. gain.

## References

Li W., Han, J. and Pei, J. CMAR: Accurate and Efficient Classification
Based on Multiple Class-Association Rules, ICDM, 2001, pp. 369-376.

Yin, Xiaoxin and Jiawei Han. CPAR: Classification based on Predictive
Association Rules, SDM, 2003.
[doi:10.1137/1.9781611972733.40](https://doi.org/10.1137/1.9781611972733.40)

Frans Coenen et al. The LUCS-KDD Software Library, University of
Liverpool, 2013.

## See also

Other classifiers:
[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md),
[`CBA_ruleset()`](http://michael.hahsler.net/arulesCBA/reference/CBA_ruleset.md),
[`FOIL()`](http://michael.hahsler.net/arulesCBA/reference/FOIL.md),
[`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md),
[`RWeka_CBA`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md),
[`predict.CBA()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)

## Examples

``` r
# make sure you have a Java SDK Version 1.4.0+ and not a headless installation.
system("java -version")

data("iris")

# build a classifier, inspect rules and make predictions
cl <- CMAR(Species ~ ., iris, support = .2, confidence = .8, verbose = TRUE)
#> LUCS-KDD: CMAR 
#> Call: java  -cp /home/runner/work/_temp/Library/arulesCBA/LUCS_KDD/CMAR.jar runCMAR -N3 -F/tmp/RtmpVdoInV/file1cd119951479.num -S20 -C80 
#> 
#>  [1] "SETTINGS"                                                                      
#>  [2] "--------"                                                                      
#>  [3] "Training file name            = /tmp/RtmpVdoInV/file1cd119951479.num"          
#>  [4] "Support (default 20%)         = 20.0"                                          
#>  [5] "Confidence (default 80%)      = 80.0"                                          
#>  [6] "Number of classes             = 3"                                             
#>  [7] ""                                                                              
#>  [8] "Reading input file: /tmp/RtmpVdoInV/file1cd119951479.num"                      
#>  [9] "Number of records = 150"                                                       
#> [10] "Number of columns = 15"                                                        
#> [11] "Min support       = 30.0 (records)"                                            
#> [12] "START APRIORI-TFP CMAR"                                                        
#> [13] "------------------------------"                                                
#> [14] "Min. rules to cover  = 3"                                                      
#> [15] "Crit. threshold val. = 3.8415"                                                 
#> [16] "Max number of CARS   = 80000"                                                  
#> [17] "Max size antecedent  = 6"                                                      
#> [18] ""                                                                              
#> [19] "Support = 20.0, Confidence = 80.0"                                             
#> [20] "Minimum support = 0.0 (Records)"                                               
#> [21] "Max num frequent sets  = 500000"                                               
#> [22] "Max size of antecedent = 6"                                                    
#> [23] "Number of records in training set = 150"                                       
#> [24] "NOTE: Data set reordered"                                                      
#> [25] "Creating P-tree table"                                                         
#> [26] "Apriori-TFP with X-Checking"                                                   
#> [27] "Minimum support threshold = 20.0% (0.0 records)"                               
#> [28] "Current CR antecedent size (7) exceeds limit of 6, generation process stopped!"
#> [29] ""                                                                              
#> [30] "WARNING: No test data"                                                         
#> [31] "Number of frequent sets = 16383"                                               
#> [32] "Number of T-tree nodes created = 16383"                                        
#> [33] "Number of T-tree Updates       = 634"                                          
#> [34] "T-tree Storage          = 222500 (Bytes)"                                      
#> [35] "Number of CMAR rules    = 40"                                                  
#> [36] "(#) Ante -> Cons confidence % (Sup. Rule, Sup. Ante, Sup. Cons.)"              
#> [37] "---------------------------------------------"                                 
#> [38] ""                                                                              
#> [39] "(1)  {7}  ->  {13}  100.0%, (50.0, 50.0, 50.0)"                                
#> [40] "(2)  {10}  ->  {13}  100.0%, (50.0, 50.0, 50.0)"                               
#> [41] "(3)  {7 10}  ->  {13}  100.0%, (50.0, 50.0, 50.0)"                             
#> [42] "(4)  {1 7}  ->  {13}  100.0%, (47.0, 47.0, 50.0)"                              
#> [43] "(5)  {3 12}  ->  {15}  100.0%, (37.0, 37.0, 50.0)"                             
#> [44] "(6)  {3 9 12}  ->  {15}  100.0%, (37.0, 37.0, 50.0)"                           
#> [45] "(7)  {7 6}  ->  {13}  100.0%, (31.0, 31.0, 50.0)"                              
#> [46] "(8)  {8 2}  ->  {14}  100.0%, (21.0, 21.0, 50.0)"                              
#> [47] "(9)  {11 8 2}  ->  {14}  100.0%, (21.0, 21.0, 50.0)"                           
#> [48] "(10)  {5 3 12}  ->  {15}  100.0%, (20.0, 20.0, 50.0)"                          
#> [49] "(11)  {5 3 9 12}  ->  {15}  100.0%, (20.0, 20.0, 50.0)"                        
#> [50] "(12)  {4 12}  ->  {15}  100.0%, (17.0, 17.0, 50.0)"                            
#> [51] "(13)  {4 9 12}  ->  {15}  100.0%, (17.0, 17.0, 50.0)"                          
#> [52] "(14)  {4 8 2}  ->  {14}  100.0%, (15.0, 15.0, 50.0)"                           
#> [53] "(15)  {4 11 8 2}  ->  {14}  100.0%, (15.0, 15.0, 50.0)"                        
#> [54] "(16)  {5 8}  ->  {14}  100.0%, (12.0, 12.0, 50.0)"                             
#> [55] "(17)  {3 8}  ->  {14}  100.0%, (12.0, 12.0, 50.0)"                             
#> [56] "(18)  {5 11 8}  ->  {14}  100.0%, (12.0, 12.0, 50.0)"                          
#> [57] "(19)  {3 11 8}  ->  {14}  100.0%, (12.0, 12.0, 50.0)"                          
#> [58] "(20)  {4 3 8}  ->  {14}  100.0%, (6.0, 6.0, 50.0)"                             
#> [59] "(21)  {4 3 11 8}  ->  {14}  100.0%, (6.0, 6.0, 50.0)"                          
#> [60] "(22)  {3 6}  ->  {15}  100.0%, (5.0, 5.0, 50.0)"                               
#> [61] "(23)  {9 6}  ->  {15}  100.0%, (5.0, 5.0, 50.0)"                               
#> [62] "(24)  {4 12 2}  ->  {15}  100.0%, (5.0, 5.0, 50.0)"                            
#> [63] "(25)  {4 9 12 2}  ->  {15}  100.0%, (5.0, 5.0, 50.0)"                          
#> [64] "(26)  {12}  ->  {15}  97.82%, (45.0, 46.0, 50.0)"                              
#> [65] "(27)  {9 12}  ->  {15}  97.82%, (45.0, 46.0, 50.0)"                            
#> [66] "(28)  {8}  ->  {14}  97.77%, (44.0, 45.0, 50.0)"                               
#> [67] "(29)  {11 8}  ->  {14}  97.77%, (44.0, 45.0, 50.0)"                            
#> [68] "(30)  {4 8}  ->  {14}  96.87%, (31.0, 32.0, 50.0)"                             
#> [69] "(31)  {4 11 8}  ->  {14}  96.87%, (31.0, 32.0, 50.0)"                          
#> [70] "(32)  {5 12}  ->  {15}  95.83%, (23.0, 24.0, 50.0)"                            
#> [71] "(33)  {5 9 12}  ->  {15}  95.83%, (23.0, 24.0, 50.0)"                          
#> [72] "(34)  {5 11}  ->  {14}  93.33%, (14.0, 15.0, 50.0)"                            
#> [73] "(35)  {11 2}  ->  {14}  91.66%, (22.0, 24.0, 50.0)"                            
#> [74] "(36)  {5 3 9}  ->  {15}  91.3%, (21.0, 23.0, 50.0)"                            
#> [75] "(37)  {11}  ->  {14}  90.74%, (49.0, 54.0, 50.0)"                              
#> [76] "(38)  {3 9}  ->  {15}  90.69%, (39.0, 43.0, 50.0)"                             
#> [77] "(39)  {4 11}  ->  {14}  89.47%, (34.0, 38.0, 50.0)"                            
#> [78] "(40)  {9}  ->  {15}  89.09%, (49.0, 55.0, 50.0)"                               
#> 
#> Rules used: 40 
cl
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 40
#> Default Class: setosa
#> Classification method: weighted by weightedChiSquared 
#> Description: CMAR (Li, Han and Pei, 2001 - LUCS-KDD implementation).
#> 

inspect(cl$rules)
#>      lhs                            rhs                     support confidence     lift   laplace chiSquared weightedChiSquared
#> [1]  {Petal.Length=[-Inf,2.45)}  => {Species=setosa}     0.33333333  1.0000000 3.000000 0.9622642  150.00000          150.00000
#> [2]  {Petal.Width=[-Inf,0.8)}    => {Species=setosa}     0.33333333  1.0000000 3.000000 0.9622642  150.00000          150.00000
#> [3]  {Petal.Length=[-Inf,2.45),                                                                                                
#>       Petal.Width=[-Inf,0.8)}    => {Species=setosa}     0.33333333  1.0000000 3.000000 0.9622642  150.00000          150.00000
#> [4]  {Sepal.Length=[-Inf,5.55),                                                                                                
#>       Petal.Length=[-Inf,2.45)}  => {Species=setosa}     0.31333333  1.0000000 3.000000 0.9600000  136.89320          136.89320
#> [5]  {Sepal.Length=[6.15, Inf],                                                                                                
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.24666667  1.0000000 3.000000 0.9500000   98.23009           98.23009
#> [6]  {Sepal.Length=[6.15, Inf],                                                                                                
#>       Petal.Length=[4.75, Inf],                                                                                                
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.24666667  1.0000000 3.000000 0.9500000   98.23009           98.23009
#> [7]  {Sepal.Width=[3.35, Inf],                                                                                                 
#>       Petal.Length=[-Inf,2.45)}  => {Species=setosa}     0.20666667  1.0000000 3.000000 0.9411765   78.15126           78.15126
#> [8]  {Sepal.Length=[5.55,6.15),                                                                                                
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.14000000  1.0000000 3.000000 0.9166667   48.83721           48.83721
#> [9]  {Sepal.Length=[5.55,6.15),                                                                                                
#>       Petal.Length=[2.45,4.75),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.14000000  1.0000000 3.000000 0.9166667   48.83721           48.83721
#> [10] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.13333333  1.0000000 3.000000 0.9130435   46.15385           46.15385
#> [11] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Length=[4.75, Inf],                                                                                                
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.13333333  1.0000000 3.000000 0.9130435   46.15385           46.15385
#> [12] {Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.11333333  1.0000000 3.000000 0.9000000   38.34586           38.34586
#> [13] {Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[4.75, Inf],                                                                                                
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.11333333  1.0000000 3.000000 0.9000000   38.34586           38.34586
#> [14] {Sepal.Length=[5.55,6.15),                                                                                                
#>       Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.10000000  1.0000000 3.000000 0.8888889   33.33333           33.33333
#> [15] {Sepal.Length=[5.55,6.15),                                                                                                
#>       Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[2.45,4.75),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.10000000  1.0000000 3.000000 0.8888889   33.33333           33.33333
#> [16] {Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.08000000  1.0000000 3.000000 0.8666667   26.08696           26.08696
#> [17] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.08000000  1.0000000 3.000000 0.8666667   26.08696           26.08696
#> [18] {Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Length=[2.45,4.75),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.08000000  1.0000000 3.000000 0.8666667   26.08696           26.08696
#> [19] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Petal.Length=[2.45,4.75),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.08000000  1.0000000 3.000000 0.8666667   26.08696           26.08696
#> [20] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.04000000  1.0000000 3.000000 0.7777778   12.50000           12.50000
#> [21] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[2.45,4.75),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.04000000  1.0000000 3.000000 0.7777778   12.50000           12.50000
#> [22] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Sepal.Width=[3.35, Inf]}   => {Species=virginica}  0.03333333  1.0000000 3.000000 0.7500000   10.34483           10.34483
#> [23] {Sepal.Width=[3.35, Inf],                                                                                                 
#>       Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.03333333  1.0000000 3.000000 0.7500000   10.34483           10.34483
#> [24] {Sepal.Length=[5.55,6.15),                                                                                                
#>       Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.03333333  1.0000000 3.000000 0.7500000   10.34483           10.34483
#> [25] {Sepal.Length=[5.55,6.15),                                                                                                
#>       Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[4.75, Inf],                                                                                                
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.03333333  1.0000000 3.000000 0.7500000   10.34483           10.34483
#> [26] {Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.30000000  0.9782609 2.934783 0.9387755  124.17956          116.21293
#> [27] {Petal.Length=[4.75, Inf],                                                                                                
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.30000000  0.9782609 2.934783 0.9387755  124.17956          116.21293
#> [28] {Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.29333333  0.9777778 2.933333 0.9375000  120.14286          112.26683
#> [29] {Petal.Length=[2.45,4.75),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.29333333  0.9777778 2.933333 0.9375000  120.14286          112.26683
#> [30] {Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[2.45,4.75)}  => {Species=versicolor} 0.20666667  0.9687500 2.906250 0.9142857   73.90757           67.14113
#> [31] {Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Length=[2.45,4.75),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.20666667  0.9687500 2.906250 0.9142857   73.90757           67.14113
#> [32] {Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.15333333  0.9583333 2.875000 0.8888889   50.22321           44.14150
#> [33] {Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Length=[4.75, Inf],                                                                                                
#>       Petal.Width=[1.75, Inf]}   => {Species=virginica}  0.15333333  0.9583333 2.875000 0.8888889   50.22321           44.14150
#> [34] {Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.09333333  0.9333333 2.800000 0.8333333   27.00000           21.87000
#> [35] {Sepal.Length=[5.55,6.15),                                                                                                
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.14666667  0.9166667 2.750000 0.8518519   43.75000           33.49609
#> [36] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Sepal.Width=[2.95,3.35),                                                                                                 
#>       Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.14000000  0.9130435 2.739130 0.8461538   41.08182           31.06376
#> [37] {Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.32666667  0.9074074 2.722222 0.8771930  125.13021          117.43177
#> [38] {Sepal.Length=[6.15, Inf],                                                                                                
#>       Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.26000000  0.9069767 2.720930 0.8695652   89.26320           66.09050
#> [39] {Sepal.Width=[-Inf,2.95),                                                                                                 
#>       Petal.Width=[0.8,1.75)}    => {Species=versicolor} 0.22666667  0.8947368 2.684211 0.8536585   72.18045           51.18614
#> [40] {Petal.Length=[4.75, Inf]}  => {Species=virginica}  0.32666667  0.8909091 2.672727 0.8620690  121.49282          113.94075
predict(cl, head(iris))
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica

cl <- CPAR(Species ~ ., iris)
cl
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 9
#> Default Class: setosa
#> Classification method: weighted by laplace - using best 5 rules
#> Description: CPAR (Yin and Han, 2003 - LUCS-KDD implementation).
#> 

cl <- PRM(Species ~ ., iris)
cl
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 8
#> Default Class: setosa
#> Classification method: weighted by laplace - using best 5 rules
#> Description: PRM (Yin and Han, 2003 - LUCS-KDD implementation).
#> 

cl <- FOIL2(Species ~ ., iris)
cl
#> CBA Classifier Object
#> Formula: Species ~ .
#> Number of rules: 9
#> Default Class: setosa
#> Classification method: weighted  - using best 5 rules
#> Description: FOIL-based classifier (Yin and Han, 2003 - LUCS-KDD
#>      implementation).
#> 
```
