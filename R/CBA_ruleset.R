#' Constructor for Objects for Classifiers Based on Association Rules
#'
#' Objects for classifiers based on association rules have class `CBA`.
#' A creator function `CBA_ruleset()` and several methods are provided.
#'
#' `CBA_ruleset()` creates a new object of class `CBA` using the
#' provides rules as the rule base.  For method `"first"`, the user needs
#' to make sure that the rules are predictive and sorted from most to least
#' predictive.
#'
#' @param formula A symbolic description of the model to be fitted. Has to be
#'   of form `class ~ .`. The class is the variable name (part of the item
#'   label before `=`).
#' @param rules A set of class association rules mined with [mineCARs()] or
#'   [apriori()] (from \pkg{arules}).
#' @param default Default class. If not specified then objects that are
#'   not matched by rules are classified as `NA`.
#' @param method Classification method `"first"` found rule or `"majority"`.
#' @param weights Rule weights for the majority voting method. Either a quality measure
#'   available in the classification rule set or a numeric vector of the same length are
#'   the classification rule set can be specified. If missing, then equal weights are used
#' @param bias Class bias vector.
#' @param model An optional list with model information (e.g., parameters).
#' @param discretization A list with discretization information used by [predict()] to discretize data
#'   supplied as a `data.frame`.
#' @param description Description field used when the classifier is printed.
#' @param \dots Additional arguments added as list elements to the CBA object.
#' @return A object of class `CBA` representing the trained classifier with fields:
#'   \item{formula}{used formula.}
#'   \item{rules}{the classifier rule base.}
#'   \item{default}{default class label (uses partial matching against the class labels).}
#'   \item{method}{classification method.}
#'   \item{weights}{rule weights.}
#'   \item{bias}{class bias vector if available.}
#'   \item{model}{list with model description.}
#'   \item{discretization}{discretization information.}
#'   \item{description}{description in human readable form.}
#'
#' \code{rules} returns the rule base.
#' @author Michael Hahsler
#' @seealso [mineCARs()]
#' @examples
#' ## Example 1: create a first-matching-rule classifier with non-redundant rules
#' ##  sorted by confidence.
#' data("iris")
#'
#' # discretize and create transactions
#' iris.disc <- discretizeDF.supervised(Species ~., iris)
#' trans <- as(iris.disc, "transactions")
#'
#' # create rule base with CARs
#' cars <- mineCARs(Species ~ ., trans, parameter = list(support = .01, confidence = .8))
#'
#' cars <- cars[!is.redundant(cars)]
#' cars <- sort(cars, by = "conf")
#'
#' # create classifier and use the majority class as the default if no rule matches.
#' cl <- CBA_ruleset(Species ~ .,
#'   rules = cars,
#'   default = uncoveredMajorityClass(Species ~ ., trans, cars),
#'   method = "first")
#' cl
#'
#' # look at the rule base
#' inspect(cl$rules)
#'
#' # make predictions
#' prediction <- predict(cl, trans)
#' table(prediction, response(Species ~ ., trans))
#' accuracy(prediction, response(Species ~ ., trans))
#'
#' # Example 2: use weighted majority voting.
#' cl <- CBA_ruleset(Species ~ .,
#'   rules = cars,
#'   default = uncoveredMajorityClass(Species ~ ., trans, cars),
#'   method = "majority", weights = "lift")
#' cl
#'
#' prediction <- predict(cl, trans)
#' table(prediction, response(Species ~ ., trans))
#' accuracy(prediction, response(Species ~ ., trans))
#'
#' ## Example 3: Create a classifier with no rules that always predicts
#' ##  the majority class. Note, we need cars for the structure and subset it
#' ##  to leave no rules.
#' cl <- CBA_ruleset(Species ~ .,
#'   rules = cars[NULL],
#'   default = majorityClass(Species ~ ., trans))
#' cl
#'
#' prediction <- predict(cl, trans)
#' table(prediction, response(Species ~ ., trans))
#' accuracy(prediction, response(Species ~ ., trans))
#' @export
CBA_ruleset <- function(formula,
  rules,
  default,
  method = "first",
  weights = NULL,
  bias = NULL,
  model = NULL,
  discretization = NULL,
  description = "Custom rule set",
  ...) {
  # method (need to match with predict!)
  methods <- c("first", "majority", "weighted", "logit")
  m <- pmatch(method, methods)
  if (is.na(m))
    stop("Unknown method")
  method <- methods[m]

  # add weights
  if (!is.null(weights)) {
    if (is.character(weights))
      weights <- quality(rules)[[weights, exact = FALSE]]
    else
      weights <- weights
  }

  formula <- as.formula(formula)
  parsedformula <- .parseformula(formula, rhs(rules))

  # default
  default <- pmatch(default[1], parsedformula$class_names, nomatch = 0L)
  if (default < 1L)
    stop("default does not uniquely partial match a class label. Available class labels are: ",
      paste(parsedformula$class_names, collapse = ", "))
  default <- factor(parsedformula$class_names[default], levels = parsedformula$class_names)

  # RHS can only contain class items
  take <- rhs(rules) %in% parsedformula$class_items
  if (any(!take)) {
    rules <- rules[take]
    if (is.matrix(weights))
      weights <- weights[take, ]
    else
      weights <- weights[take]

    warning(
      "Some provided rules are not CARs with the class in the RHS and are ignored.",
      " Only ",
      length(rules),
      " rules used for the classifier."
    )
  }

  # check if LHS is in formula!
  lhscnt <- itemFrequency(lhs(rules), type = "absolute")
  if (sum(lhscnt[-parsedformula$feature_ids]) != 0)
    warning("LHS of CARs contains items not in the formula!")

  structure(c(
    list(
      formula = formula,
      rules = rules,
      default = default,
      weights = weights,
      bias = bias,
      method = method,
      model = model,
      discretization = discretization,
      description = description
    ),
    list(...)

  ),
    class = "CBA")
}

#' @method print CBA
#' @export
print.CBA <- function(x, ...)
  writeLines(c(
    "CBA Classifier Object",
    paste("Formula:", deparse(x$formula)),
    paste("Number of rules:", length(x$rules)),
    paste("Default Class:", x$default),
    paste(
      "Classification method:",
      x$method,
      if (is.character(x$weights))
        paste("by", x$weights)
      else
        "",
      if (!is.null(x$best_k))
        paste("- using best", x$best_k, "rules")
      else
        ""
    ),
    strwrap(paste("Description:", x$description), exdent = 5),
    ""
  ))
