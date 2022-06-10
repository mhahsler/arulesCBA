#' Helper Functions For Dealing with Classes
#'
#' Helper functions to extract the response from transactions or rules, determine the
#' class frequency, majority class, transaction coverage and the
#' uncovered examples per class.
#'
#' @param formula A symbolic description of the model to be fitted.
#' @param x,transactions An object of class [arules::transactions]
#' or [rules].
#' @param rules A set of [rules].
#' @param type `"relative" or `"absolute"` to return proportions or
#' absolute counts.
#' @return `response` returns the response label as a factor.
#'
#' `classFrequency` returns the item frequency for each class label as a
#' vector.
#'
#' `majorityClass` returns the most frequent class label in the
#' transactions.
#' @name CBA_helpers
#' @author Michael Hahsler
#' @seealso [itemFrequency()], [rules], [arules::transactions].
#' @examples
#' data("iris")
#'
#' iris.disc <- discretizeDF.supervised(Species ~ ., iris)
#' iris.trans <- as(iris.disc, "transactions")
#' inspect(head(iris.trans, n = 3))
#'
#' # convert the class items back to a class label
#' response(Species ~ ., head(iris.trans, n = 3))
#'
#' # Class labels
#' classes(Species ~ ., iris.trans)
#'
#' # Class distribution. The iris dataset is perfectly balanced.
#' classFrequency(Species ~ ., iris.trans)
#'
#' # Majority class
#' # (Note: since all class frequencies for iris are the same, the first one is returned)
#' majorityClass(Species ~ ., iris.trans)
#'
#' # Use for CARs
#' cars <- mineCARs(Species ~ ., iris.trans, parameter = list(support = 0.3))
#'
#' #' # Class labels
#' classes(Species ~ ., cars)
#'
#' # Number of rules for each class
#' classFrequency(Species ~ ., cars, type = "absolute")
#'
#' # conclusion (item in the RHS) of the rule as a class label
#' response(Species ~ ., cars)
#'
#' # How many rules (using the first three rules) cover each transactions?
#' transactionCoverage(iris.trans, cars[1:3])
#'
#' # Number of transactions per class not covered by the first three rules
#' uncoveredClassExamples(Species ~ ., iris.trans, cars[1:3])
#'
#' # Majority class of the uncovered examples
#' uncoveredMajorityClass(Species ~ ., iris.trans, cars[1:3])
NULL

### TODO: classes can be done faster
#' @rdname CBA_helpers
#' @export
classes <- function(formula, x)
  levels(response(formula, x))

#' @rdname CBA_helpers
#' @export
response <- function(formula, x) {
  if (is.data.frame(x))
    return(x[[.parseformula(formula, x)$class_ids]])
  # this will add variable info for regular transactions
  if (is(x, "transactions"))
    x <- prepareTransactions(formula, x)
  if (is(x, "rules"))
    x <- items(x)
  if (!is(x, "itemMatrix"))
    stop("response not implemented for the type of x!")

  vars <- .parseformula(formula, x)
  x <- x[, vars$class_ids]
  l <- itemInfo(x)$levels

  factor(unlist(LIST(x, decode = FALSE)),
    levels = 1:length(l),
    labels = l)
}

#' @rdname CBA_helpers
#' @export
classFrequency <- function(formula, x, type = "relative") {
  tbl <- table(response(formula, x))
  if (type == "relative")
    tbl <- tbl / sum(tbl)
  tbl
}

#' @rdname CBA_helpers
#' @export
majorityClass <- function(formula, transactions) {
  cf <- classFrequency(formula, transactions)
  factor(unname(which.max(cf)),
    levels = seq(length(cf)),
    labels = names(cf))
}

#' @rdname CBA_helpers
#' @export
transactionCoverage <- function(transactions, rules) {
  rulesMatchLHS <- is.subset(lhs(rules), transactions,
    sparse = (length(transactions) * length(rules) > 150000))
  dimnames(rulesMatchLHS) <- list(NULL, NULL)
  colSums(rulesMatchLHS)
}

#' @rdname CBA_helpers
#' @export
uncoveredClassExamples <- function(formula, transactions, rules) {
  transCover <- transactionCoverage(transactions, rules)
  table(response(formula, transactions)[transCover < 1])
}

#' @rdname CBA_helpers
#' @export
uncoveredMajorityClass <- function(formula, transactions, rules)
  names(which.max(uncoveredClassExamples(formula, transactions, rules)))
