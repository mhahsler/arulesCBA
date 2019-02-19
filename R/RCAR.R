RCAR <- function(formula, data, support = 0.3, confidence = 0.7, verbose = FALSE,
  maxlen = 6, lambda = 0.001, balanceSupport = FALSE, disc.method = 'mdlp') {

  disc_info <- NULL
  if(is(data, "data.frame")){
    data <- discretizeDF.supervised(formula, data, method=disc.method)
    disc_info <- lapply(data, attr, "discretized:breaks")
  }

  trans <- as(data, 'transactions')
  rules <- mineCARs(formula, trans, balanceSupport,
    parameter=list(supp=support,conf=confidence,maxlen=maxlen),
    control=list(verbose=verbose))

  X <- is.superset(trans,as(rules@lhs,'itemMatrix'))
  y_class <- .parseformula(formula, data)$class_names
  model <- glmnet(X,data[[y_class]],family='multinomial',alpha=1,lambda=lambda)
  num_nonzero_rules <- sum(unlist(lapply(model$beta, function(x) sum(x>0))))

  structure(list(rules=rules,
    model=model,
    method='RCAR classifier',
    class=model$classnames,
    default=model$classnames[[1]],
    discretization=disc_info,
    description='RCAR algorithm by Azmi et al. 2019',
    formula = formula),
    class = c('RCAR','CBA'))
}


predict.RCAR <- function(object, newdata, ...){

  if(!is.null(object$discretization))
    newdata <- discretizeDF(newdata, lapply(object$discretization,
      FUN = function(x) list(method = "fixed", breaks = x)))

  rules.space <- as(lhs(rules(object)), "itemMatrix")
  D <- as(newdata, "transactions")
  X <- is.superset(D, rules.space)
  dimnames(X) <- list(NULL, paste("rule", c(1:dim(X)[[2]]), sep=""))

  prediction <- predict(object$model, newx = X, s = object$model$lambda,
    type="class")
  prediction <- factor(prediction, levels = object$class)
  prediction
}