#' Regularized Class Association Rules for Multi-class Problems (RCAR+)
#'
#' Build a classifier based on association rules mined for an input dataset and
#' weighted with LASSO regularized logistic regression following RCAR (Azmi, et
#' al., 2019). RCAR+ extends RCAR from a binary classifier to a multi-class
#' classifier and can use support-balanced CARs.
#'
#' RCAR+ extends RCAR from a binary classifier to a multi-class classifier
#' using regularized multinomial logistic regression via \pkg{glmnet}.
#'
#' The idea is to create a coverage matrix \eqn{X} with one row per transaction and one column per
#' class association rules. The matrix contains a 1 if a transaction is covered by a rules and otherwise 0.
#' A regularized multinominal logistic model to predict the class \eqn{y} for each transaction is learned and the
#' weights for each rule are used for the classifier. For the final classifier, we only keep the
#' rules with a weight greater than 0.
#'
#' #' If lambda is not specified during training (`lambda = NULL`) then cross-validation is used
#' to determine the largest value of lambda such that the error is within 1 standard error of the
#' minimum (see [cv.glmnet()] for how to
#' perform cross-validation in parallel).
#'
#' Classification is performed by checking what rules (the LHS) apply to a transaction and then using the
#' logistic model to create the predicted probabilities. The class with the largest probability is
#' chosen as the prediction.
#'
#'
#' @aliases RCAR rcar
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
#'   [cv.glmnet()] and [glmnet()], respectively. See Example section.
#' @param parameter,control Optional parameter and control lists for [apriori()].
#' @param balanceSupport balanceSupport parameter passed to [mineCARs()].
#' @param disc.method Discretization method for factorizing numeric input
#'   (default: `"mdlp"`). See [discretizeDF.supervised()] for more
#'   supervised discretization methods.
#' @param verbose Report progress?
#' @param ... For convenience, additional parameters are used to create the
#' \code{parameter} control list for [apriori()] (e.g., to specify the support and
#'   confidence thresholds).
#' @return Returns an object of class [CBA] representing the trained
#'   classifier with the additional field `model` containing a list with the
#'   following elements:
#'
#' \item{reg_model}{them multinomial logistic
#'   regression model as an object of class [glmnet()].}
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
#' #' inspect rule 5 which has a large weight for class setosa
#' inspect(classifier$model$all_rules[5])
#'
#' # show progress report and use 5 instead of the default 10 cross-validation folds.
#' classifier <- RCAR(Species ~ ., iris, cv.glmnet.args = list(nfolds = 5), verbose = TRUE)
#' inspect(classifier$rules)
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

  # create coverage matrix
  if (verbose)
    cat("* Creating model matrix\n")
  #X <- is.superset(trans, lhs(cars))
  ### the whole rule inducing the rhs y has to match
  X <- is.superset(trans, cars)
  y <- response(formula, trans)


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

  # weights: The odds multiply by exp(beta) for every 1-unit increase of x
  remove <- apply(
    weights,
    MARGIN = 1,
    FUN = function(x)
      all(x == 0)
  )
  quality(cars)$weight <- apply(weights, MARGIN = 1, max)
  quality(cars)$oddsratio <- exp(quality(cars)$weight)
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
