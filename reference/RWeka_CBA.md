# CBA classifiers based on rule-based classifiers in RWeka

Provides CBA-type classifiers based on RIPPER (Cohen, 1995), C4.5
(Quinlan, 1993) and PART (Frank and Witten, 1998) using the
implementation in Weka via RWeka (Hornik et al, 2009). These classifiers
do not mine CARs, but directly create rules.

## Usage

``` r
RIPPER_CBA(formula, data, control = NULL, disc.method = "mdlp")

PART_CBA(formula, data, control = NULL, disc.method = "mdlp")

C4.5_CBA(formula, data, control = NULL, disc.method = "mdlp")
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

- control:

  algorithmic control options for R/Weka Rule learners (see Details
  Section).

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

You need to install package RWeka to use these classifiers.

See R/Weka functions
[`RWeka::JRip()`](https://rdrr.io/pkg/RWeka/man/Weka_classifier_rules.html)
(RIPPER),
[`RWeka::J48()`](https://rdrr.io/pkg/RWeka/man/Weka_classifier_trees.html)
(C4.5 rules),
[`RWeka::PART()`](https://rdrr.io/pkg/RWeka/man/Weka_classifier_rules.html)
for algorithm details and how control options can be passed on via
`control`. An example is given in the Examples Section below.

Memory for RWeka can be increased using the R options (e.g.,
`options(java.parameters = "-Xmx1024m")`) before RWeka or rJava is
loaded or any RWeka-based classifier in this package is used.

## References

W. W. Cohen (1995). Fast effective rule induction. In A. Prieditis and
S. Russell (eds.), Proceedings of the 12th International Conference on
Machine Learning, pages 115-123. Morgan Kaufmann. ISBN 1-55860-377-8.

E. Frank and I. H. Witten (1998). Generating accurate rule sets without
global optimization. In J. Shavlik (ed.), Machine Learning: Proceedings
of the Fifteenth International Conference. Morgan Kaufmann Publishers:
San Francisco, CA.

R. Quinlan (1993). C4.5: Programs for Machine Learning. Morgan Kaufmann
Publishers, San Mateo, CA.

Hornik K, Buchta C, Zeileis A (2009). "Open-Source Machine Learning: R
Meets Weka." *Computational Statistics,* 24(2), 225-232.
[doi:10.1007/s00180-008-0119-7](https://doi.org/10.1007/s00180-008-0119-7)

## See also

Other classifiers:
[`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md),
[`CBA_ruleset()`](http://michael.hahsler.net/arulesCBA/reference/CBA_ruleset.md),
[`FOIL()`](http://michael.hahsler.net/arulesCBA/reference/FOIL.md),
[`LUCS_KDD_CBA`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md),
[`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md),
[`predict.CBA()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)

## Author

Michael Hahsler

## Examples

``` r
# rJava and RWeka need to be installed

if (FALSE) { # \dontrun{
data("iris")

# learn a classifier using automatic default discretization
classifier <- RIPPER_CBA(Species ~ ., data = iris)
classifier

# inspect the rule base
inspect(classifier$rules)

# make predictions for the first few instances of iris
predict(classifier, head(iris))

table(predict(classifier, iris), iris$Species)

# C4.5
classifier <- C4.5_CBA(Species ~ ., iris)
inspect(classifier$rules)

# To use algorithmic options (here for PART), you need to load RWeka
library(RWeka)

# control options can be found using the Weka Option Wizard (WOW)
WOW(PART)

# build PART with control option U (Generate unpruned decision list) set to TRUE
classifier <- PART_CBA(Species ~ ., data = iris, control = RWeka::Weka_control(U = TRUE))
classifier
inspect(classifier$rules)
predict(classifier, head(iris))
} # }
```
