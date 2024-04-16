#' Regularized Class Association Rules for Multi-class Problems (RCAR+)
#'
#' Build a classifier based on association rules mined for an input dataset and
#' weighted with LASSO regularized logistic regression following RCAR (Azmi, et
#' al., 2019). RCAR+ extends RCAR from a binary classifier to a multi-label
#' classifier and can use support-balanced CARs.
#'
#' RCAR+ extends RCAR from a binary classifier to a multi-label classifier
#' using regularized multinomial logistic regression via \pkg{glmnet}.
#'
#' In arulesCBA, the class variable is always represented by a set of items.
#' For a binary classification problem, we use an item and its compliment
#' (typically called `<item label>=TRUE` and `<item label>=FALSE`). For
#' a multi-label classification problem we use one item for each possible class
#' label (format `<class item>=<label>`). See [prepareTransactions()] for details.
#'
#' RCAR+ first mines CARs to find itemsets (LHS of the CARs) that are related
#' to the class items. Then, a transaction x lhs(CAR) coverage matrix \eqn{X} is created.
#' The matrix contains
#' a 1 if the LHS of the CAR applies to the transaction, and 0 otherwise.
#' A regularized multinominal logistic model to predict the true class \eqn{y}
#' for each transaction given \eqn{X} is fitted. Note that the RHS of the
#' CARs are actually ignored in this process, so the algorithm effectively
#' uses rules consisting of each LHS of a CAR paired with each class label.
#' This is important to keep in mind when trying to interpret the rules used in
#' the classifier.
#'
#' If lambda for regularization is not specified during training (`lambda = NULL`)
#' then cross-validation is used
#' to determine the largest value of lambda such that the error is within 1 standard error of the
#' minimum (see [glmnet::cv.glmnet()] for how to perform cross-validation in parallel).
#'
#' For the final classifier, we only keep the rules that have a weight greater than
#' 0 for at least one class label. The rules include as the weight the beta coefficients
#' of the model.
#'
#' Prediction for a new transaction is performed in two steps:
#'
#' 1. Translate the transaction into a 0-1 coverage vector indicating what class association
#' rule's LHS covers the transaction.
#' 2. Calculate the predicted label given the multinomial logistic regression model.
#'
#' @aliases RCAR rcar
#'
#' @family classifiers
#'
#' @param formula A symbolic description of the model to be fitted. Has to be
#'   of form `class ~ .` or `class ~ predictor1 + predictor2`.
#' @param data A data.frame or [arules::transactions] containing the training data.
#'   Data frames are automatically discretized and converted to transactions with
#'   [prepareTransactions()].
#' @param lambda The amount of weight given to regularization during the
#'   logistic regression learning process. If not specified (`NULL`) then
#'   cross-validation is used to determine the best value (see Details section).
#' @param alpha The elastic net mixing parameter. `alpha = 1` is the lasso
#'   penalty (default RCAR), and `alpha = 0` the ridge penalty.
#' @param cv.glmnet.args,glmnet.args A list of arguments passed on to
#'   [glmnet::cv.glmnet()] and [glmnet::glmnet()], respectively. See Example section.
#' @param parameter,control Optional parameter and control lists for [arules::apriori()].
#' @param balanceSupport balanceSupport parameter passed to [mineCARs()].
#' @param disc.method Discretization method for factorizing numeric input
#'   (default: `"mdlp"`). See [discretizeDF.supervised()] for more
#'   supervised discretization methods.
#' @param verbose Report progress?
#' @param ... For convenience, additional parameters are used to create the
#' \code{parameter} control list for [arules::apriori()] (e.g., to specify the support and
#'   confidence thresholds).
#' @return Returns an object of class [CBA] representing the trained
#'   classifier with the additional field `model` containing a list with the
#'   following elements:
#'
#' \item{reg_model}{them multinomial logistic
#'   regression model as an object of class [glmnet::glmnet].}
#' \item{cv}{only available if `lambda = NULL` was specified. Contains the
#'   results for the cross-validation used determine
#'   lambda. We use by default `lambda.1se` to determine lambda.}
#' \item{all_rules}{ the actual classifier only contains the rules with
#'   non-zero weights. This field contains all rules used to build the classifier,
#'   including the rules with a weight of zero. This is consistent with the
#'   model in `reg_model`. }
#'
#' @author Tyler Giallanza and Michael Hahsler
#'
#' @references
#' M. Azmi, G.C. Runger, and A. Berrado (2019). Interpretable
#' regularized class association rules algorithm for classification in a
#' categorical data space. _Information Sciences,_ Volume 483, May 2019.
#' Pages 313-331.
#'
#' @examples
#' data("iris")
#'
#' classifier <- RCAR(Species ~ ., iris)
#' classifier
#'
#' # inspect the rule base sorted by the larges class weight
#' inspect(sort(classifier$rules, by = "weight"))
#'
#' # make predictions for the first few instances of iris
#' predict(classifier, head(iris))
#' table(pred = predict(classifier, iris), true = iris$Species)
#'
#' # plot the cross-validation curve as a function of lambda and add a
#' # red line at lambda.1se used to determine lambda.
#' plot(classifier$model$cv)
#' abline(v = log(classifier$model$cv$lambda.1se), col = "red")
#'
#' # plot the coefficient profile plot (regularization path) for each class
#' # label. Note the line for the chosen lambda is only added to the last plot.
#' # You can manually add it to the others.
#' plot(classifier$model$reg_model, xvar = "lambda", label = TRUE)
#' abline(v = log(classifier$model$cv$lambda.1se), col = "red")
#'
#' #' inspect rule 11 which has a large weight for class virginica
#' inspect(classifier$model$all_rules[11])
#' @export
RCAR <- function(formula,
  data,
  lambda = NULL,
  alpha = 1,
  glmnet.args = NULL,
  cv.glmnet.args = NULL,
  parameter = NULL,
  control = NULL,
  balanceSupport = FALSE,
  disc.method = 'mdlp',
  verbose = FALSE,
  ...) {
  trans <- prepareTransactions(formula, data, disc.method)
  formula <- as.formula(formula)
  form <- .parseformula(formula, trans)

  if (verbose) {
    glmnet.args$trace.it <- TRUE
    cv.glmnet.args$trace.it <- TRUE
  }

  # mine and prune CARs
  if (verbose)
    cat("* Mining CARs...\n")
  cars <- mineCARs(
    formula,
    trans,
    parameter = parameter,
    control = control,
    balanceSupport = balanceSupport,
    verbose = verbose,
    ...
  )

  # remove the rule with the empty LHS
  #cars <- cars[size(cars)>1]

  # create coverage matrix
  if (verbose)
    cat("* Creating model matrix\n")

  # Note: RCA ignores the RHS and only uses the LHS for classification!
  X <- is.superset(trans, lhs(cars), sparse = TRUE)
  y <- response(formula, trans)

  # remove transactions with missing y
  if (any(m <- is.na(y))) {
    X <- X[!m, , drop = FALSE]
    y <- y[!m]
  }


  # find lambda using cross-validation or fit the model for a fixed lambda
  cv <- NULL
  if (is.null(lambda)) {
    if (verbose)
      cat("* Fitting glmnet and determine lambda using cross-validation.\n")
    cv <- do.call(glmnet::cv.glmnet, c(
      list(
        x = X,
        y = y,
        family = 'multinomial',
        alpha = alpha
      ),
      cv.glmnet.args
    ))
    lambda <- cv$lambda.1se
    if (verbose)
      cat("* Found lambda:", lambda, "\n")
    model <- cv$glmnet.fit
    best_model <- which.min(abs(model$lambda - lambda))
    weights <- sapply(
      model$beta,
      FUN = function(x)
        as.vector(x[, best_model, drop = FALSE])
    )
    bias <- model$a0[, best_model, drop = FALSE]
  } else{
    if (verbose)
      cat("* Fitting glmnet for fixed lambda.\n")
    model <-
      do.call(glmnet::glmnet, c(
        list(
          x = X,
          y = y,
          family = 'multinomial',
          alpha = alpha,
          lambda = lambda
        ),
        glmnet.args
      ))
    weights <- sapply(model$beta, as.vector)
    bias <- model$a0
  }

  # add weights
  quality(cars)$weight <- apply(weights, MARGIN = 1, max)
  quality(cars) <- cbind(quality(cars), weight = weights)

  if (verbose)
    cat("* CARs left:", length(rulebase), "\n")

  # remove rules with all 0 weights
  remove <- apply(
    weights,
    MARGIN = 1,
    FUN = function(x)
      all(x == 0)
  )
  rulebase <- cars[!remove]
  weights <- weights[!remove, , drop = FALSE]

  if (verbose)
    cat("* CARs left:", length(rulebase), "\n")

  ### default class is used for 0 rules. Use largest bias.
  default <-
    factor(unname(which.max(t(bias))),
      levels = seq_len(nrow(bias)) ,
      labels = rownames(bias))

  CBA_ruleset(
    formula = formula,
    rules = rulebase,
    default = default,
    weights = weights,
    bias = bias,
    method = 'logit',
    model = list(
      all_rules = cars,
      reg_model = model,
      cv = cv
    ),
    discretization = attr(trans, "disc_info"),
    description = "RCAR+ based on RCAR (Azmi et al., 2019)"
  )
}
