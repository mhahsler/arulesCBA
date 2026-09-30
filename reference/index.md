# Package index

## Package Overview

Learn about the package and its association rule-based classification
infrastructure.

- [`arulesCBA`](http://michael.hahsler.net/arulesCBA/reference/arulesCBA-package.md)
  [`arulesCBA-package`](http://michael.hahsler.net/arulesCBA/reference/arulesCBA-package.md)
  : arulesCBA: Classification Based on Association Rules

## Data Preparation and Rule Mining

Discretize data, convert it to transactions, and mine class association
rules for classification.

- [`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md)
  : Prepare Data for Associative Classification
- [`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md)
  : Supervised Methods to Convert Continuous Variables into Categorical
  Variables
- [`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md)
  : Mine Class Association Rules
- [`transactions2DF()`](http://michael.hahsler.net/arulesCBA/reference/transactions2DF.md)
  : Convert Transactions to a Data Frame

## Classifiers

Build classifiers from association rules using CBA and alternative
rule-learning algorithms.

- [`CBA()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md)
  [`pruneCBA_M1()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md)
  [`pruneCBA_M2()`](http://michael.hahsler.net/arulesCBA/reference/CBA.md)
  : Classification Based on Association Rules Algorithm (CBA)
- [`CBA_ruleset()`](http://michael.hahsler.net/arulesCBA/reference/CBA_ruleset.md)
  : Constructor for Objects for Classifiers Based on Association Rules
- [`RCAR()`](http://michael.hahsler.net/arulesCBA/reference/RCAR.md) :
  Regularized Class Association Rules for Multi-class Problems (RCAR+)
- [`FOIL()`](http://michael.hahsler.net/arulesCBA/reference/FOIL.md) :
  Use FOIL to learn a rule set for classification
- [`FOIL2()`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md)
  [`CPAR()`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md)
  [`PRM()`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md)
  [`CMAR()`](http://michael.hahsler.net/arulesCBA/reference/LUCS_KDD_CBA.md)
  : Interface to the LUCS-KDD Implementations of CMAR, PRM and CPAR
- [`RIPPER_CBA()`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md)
  [`PART_CBA()`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md)
  [`C4.5_CBA()`](http://michael.hahsler.net/arulesCBA/reference/RWeka_CBA.md)
  : CBA classifiers based on rule-based classifiers in RWeka
- [`predict(`*`<CBA>`*`)`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)
  [`accuracy()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)
  : Model Prediction for Classifiers Based on Association Rules

## Prediction and Evaluation

Predict class labels for new objects and evaluate classifiers.

- [`predict(`*`<CBA>`*`)`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)
  [`accuracy()`](http://michael.hahsler.net/arulesCBA/reference/predict.CBA.md)
  : Model Prediction for Classifiers Based on Association Rules

## Utilities

Extract classes and responses, analyze rule coverage, and determine
default classes.

- [`classes()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)
  [`response()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)
  [`classFrequency()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)
  [`majorityClass()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)
  [`transactionCoverage()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)
  [`uncoveredClassExamples()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)
  [`uncoveredMajorityClass()`](http://michael.hahsler.net/arulesCBA/reference/CBA_helpers.md)
  : Helper Functions for Dealing with Classes

## Data Sets

Example classification data sets from the UCI Machine Learning
Repository.

- [`Lymphography`](http://michael.hahsler.net/arulesCBA/reference/Lymphography.md)
  : The Lymphography Domain Data Set (UCI)
- [`Mushroom`](http://michael.hahsler.net/arulesCBA/reference/Mushroom.md)
  : The Mushroom Data Set (UCI)
