# arulesCBA 1.2.5 (2022-08-19)

* Improved formula interface code.
* Changes for Matrix 1.4-2.

# arulesCBA 1.2.4 (2022-05-30)

* LUCS_KDD algorithms work now in Java headless mode.
* Function rules() is now defunct. rules are now extracted using $rules. Reason: arules has now a rules function.
* Improved package tests.
* NAMESPACE is now managed by roxygen.
* Improved man pages.
* new helper function classes.
* CBA_ruleset now requires a default class.

# arulesCBA 1.2.3 (2022-05-27)
* LUCS_KDD jars come now preinstalled which fixes compilation issues.
* Fixed RCAR for 0 rule case.

# arulesCBA 1.2.1 (2021-11-20)
* mineCARs now uses by default minimum LHS-support (via parameter originalSupport = FALSE).
* the CBA_ruleset function is now used consistently as the constructor for CBA objects.
* added transactionCoverage.
* added uncoveredClassExamples.
* added uncoveredMajorityClass.
* added transactions2DF to convert transactions to a data.frame.
* RCAR is now faster (does not run glmnet again for the chosen lambda) and returns the whole regularization path.
* prepareTransactions now automatically add a negative class item if needed.
* moved the experimental algorithms wCBA and bCBA to Work.
* R/Weka-based classifiers have now a default class.


# arulesCBA 1.2.0 (2020-04-19)
* Version 1.2.0 has a major interface cleanup. This might require some change in existing code.
* The classifiers now use as the default a min. confidence of .5 and maxlen of 5 (max. rule length). 
* CBA now includes a default rule in the rule base.
* added prepareTransactions to discretize and convert a data.frame into transactions. 
* added response to convert class items to class labels (factors).
* added majorityClass.
* added FOIL.
* added RIPPER C4.5, and PART (via RWeka).
* added PRM, CPAR and CMAR (via LUCS-KDD Software Library).
* added datasets Mushroom and Lymphography.

# arulesCBA 1.1.6 (2020-01-05)
* maintenance release.

# arulesCBA 1.1.5 (2019-11-05)
* added RCAR (by Tyler Giallanza).
* The interface for CBA() was updated.
* CBA now complains if no rules are found.
* CBA has now also M1 pruning.
* mineCARs now uses ... to construct the parameters for apriori().

# arulesCBA 1.1.4 (2018-12-04)
* discretizeDF.supervised method mdlp now produces a better error message if it fails.
* cleaned up the predict code to improve speed.
* mineCARs has now a balanced support option.
* convenience function classFrequency added.

# arulesCBA 1.1.3-1 (2018-04-23)

* added new function discretizeDF.supervised for supervised discretization.
* added new convenience function mineCARs to mine class association rules.
* the formula interface now parsed the right hand side to restrict the used predictors. 
