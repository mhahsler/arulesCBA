#' Mine Class Association Rules
#'
#' Class Association Rules (CARs) are association rules that have only items
#' with class values in the RHS as introduced for the CBA algorithm by Liu et
#' al., 1998.
#'
#' Class association rules (CARs) are of the form
#'
#' \deqn{P \Rightarrow c_i,}{P => c_i,}
#'
#' where the LHS \eqn{P} is a pattern (i.e., an itemset) and \eqn{c_i} is a
#' single items representing the class label.
#'
#' **Mining parameters.**
#' Mining parameters for
#' [arules::apriori()] can be either specified as a list (or object
#' of [arules::APparameter]) as argument `parameter` or, for
#' convenience, as arguments in `...`.
#' _Note:_ [mineCARs()] uses
#' by default a minimum support of 0.1 (for the LHS of the rules via parameter
#' `originalSupport = FALSE`),
#' a minimum confidence of 0.5 and a `maxlen` (rule
#' length including items in the LHS and RHS) of 5.
#'
#' **Balancing minimum support.**
#' Using a single minimum support threshold
#' for a highly class imbalanced dataset will lead to the problem, that
#' minority classes will only be presented in very few rules. To address this
#' issue, `balanceSupport = TRUE` can be used to adjust minimum support
#' for each class dependent on the prevalence of the class (i.e., the frequency
#' of the \eqn{c_i} in the transactions) similar to the minimum class support
#' suggested for CBA by Liu et al (2000) we use
#'
#' \deqn{minsupp_i = minsupp_t
#'   \frac{supp(c_i)}{max(supp(C))},}{minsupp_i = minsupp_t x supp(c_i)/max(supp(C)),}
#'
#' where \eqn{max(supp(C))} is the support of the majority class. Therefore,
#' the defined minimum support is used for the majority class and then minimum
#' support is scaled down for classes which are less prevalent, giving them a
#' chance to also produce a reasonable amount of rules. In addition, a named
#' numerical vector with a support values for each class can be specified.
#'
#' @family preparation
#'
#' @param formula A symbolic description of the model to be fitted.
#' @param transactions An object of class [arules::transactions]
#'   containing the training data.
#' @param parameter,control Optional parameter and control lists for
#'   [arules::apriori()].
#' @param balanceSupport logical; if `TRUE`, class imbalance is
#'   counteracted by using class specific minimum support values. Alternatively,
#'   a support value for each class can be specified (see Details section).
#' @param verbose logical; report progress?
#' @param \dots For convenience, the mining parameters for [arules::apriori()] can be
#'   specified as \dots. Examples are the `support` and `confidence`
#' thresholds, and the `maxlen` of rules.
#' @return Returns an object of class [arules::rules].
#' @author Michael Hahsler
#' @references
#' Liu, B. Hsu, W. and Ma, Y (1998). Integrating Classification and
#' Association Rule Mining. _KDD'98 Proceedings of the Fourth
#' International Conference on Knowledge Discovery and Data Mining,_ New York,
#' 27-31 August. AAAI. pp. 80-86.
#'
#' Liu B., Ma Y., Wong C.K. (2000) Improving an Association Rule Based
#' Classifier. In: Zighed D.A., Komorowski J., Zytkow J. (eds) _Principles
#' of Data Mining and Knowledge Discovery. PKDD 2000. Lecture Notes in Computer
#' Science_, vol 1910. Springer, Berlin, Heidelberg.
#' @examples
#' data("iris")
#'
#' # discretize and convert to transactions
#' iris.trans <- prepareTransactions(Species ~ ., iris)
#'
#' # mine CARs with items for "Species" in the RHS.
#' # Note: mineCars uses a default a minimum coverage (lhs support) of 0.1, a
#' #       minimum confidence of .5 and maxlen of 5
#' cars <- mineCARs(Species ~ ., iris.trans)
#' inspect(head(cars))
#'
#' # specify minimum support and confidence
#' cars <- mineCARs(Species ~ ., iris.trans,
#'   parameter = list(support = 0.3, confidence = 0.9, maxlen = 3))
#' inspect(head(cars))
#'
#' # for convenience this can also be written without a list for parameter using ...
#' cars <- mineCARs(Species ~ ., iris.trans, support = 0.3, confidence = 0.9, maxlen = 3)
#'
#' # restrict the predictors to items starting with "Sepal"
#' cars <- mineCARs(Species ~ Sepal.Length + Sepal.Width, iris.trans)
#' inspect(cars)
#'
#' # using different support for each class
#' cars <- mineCARs(Species ~ ., iris.trans, balanceSupport = c(
#'   "Species=setosa" = 0.1,
#'   "Species=versicolor" = 0.5,
#'   "Species=virginica" = 0.01), confidence = 0.9)
#' cars
#'
#' # balance support for class imbalance
#' data("Lymphography")
#' Lymphography_trans <- as(Lymphography, "transactions")
#'
#' classFrequency(class ~ ., Lymphography_trans)
#'
#' # mining does not produce CARs for the minority classes
#' cars <- mineCARs(class ~ ., Lymphography_trans, support = .3, maxlen = 3)
#' classFrequency(class ~ ., cars, type = "absolute")
#'
#' # Balance support by reducing the minimum support for minority classes
#' cars <- mineCARs(class ~ ., Lymphography_trans, support = .3, maxlen = 3,
#'   balanceSupport = TRUE)
#' classFrequency(class ~ ., cars, type = "absolute")
#'
#' # Mine CARs from regular transactions (a negative class item is automatically added)
#' data(Groceries)
#' cars <- mineCARs(`whole milk` ~ ., Groceries,
#'   balanceSupport = TRUE, support = 0.01, confidence = 0.8)
#' inspect(sort(cars, by = "lift"))
#' @export
mineCARs <-
  function(formula,
    transactions,
    parameter = NULL,
    control = NULL,
    balanceSupport = FALSE,
    verbose = TRUE,
    ...) {
    transactions <- prepareTransactions(formula, transactions)
    vars <- .parseformula(formula, transactions)

    control <- as(control, "APcontrol")
    if (!verbose)
      control@verbose <- FALSE

    if (is.null(parameter) || !is(parameter, "APparameter")) {
      parameter <-  c(parameter, list(...))
      if (is.null(parameter$sup))
        parameter$support <- .1
      if (is.null(parameter$con))
        parameter$confidence <- .5
      if (is.null(parameter$maxlen))
        parameter$maxlen <- 5L
      if (is.null(parameter$originalSupport))
        parameter$originalSupport <- FALSE
      parameter <- as(parameter, "APparameter")
    }

    # Generate CARs with APRIORI
    if (is.logical(balanceSupport) && !balanceSupport) {
      # single support

      ### suppress maxlen warnings!
      suppressWarnings(
        cars <- apriori(
          transactions,
          parameter = parameter,
          appearance = list(rhs = vars$class_items, lhs = vars$feature_items),
          control = control
        )
      )
    } else{
      if (is.numeric(balanceSupport)) {
        # specify class support directly
        if (length(balanceSupport) != length(vars$class_ids))
          stop("balanceSupport requires One support value for each class label.")
        support <- balanceSupport
        if (is.null(names(support)))
          names(support) <- vars$class_items

      } else{
        # balanceSupport is TRUE
        # Following roughly: Liu B., Ma Y., Wong C.K. (2000) Improving an Association
        #  Rule Based Classifier.
        classSupport <- itemFrequency(transactions)[vars$class_ids]
        support <- parameter@support * classSupport / max(classSupport)
      }

      rs <- lapply(
        names(support),
        FUN = function(rhs) {
          if (control@verbose)
            cat("\n*** Mining CARs for class", rhs, "***\n")

          parameter@support <- support[[rhs]]

          ### suppress maxlen warnings!
          suppressWarnings(
            apriori(
              transactions,
              parameter = parameter,
              appearance = list(rhs = rhs, lhs = vars$feature_items),
              control = control
            )
          )
        }
      )

      cars <- do.call(c, rs)

    }

    cars
  }
