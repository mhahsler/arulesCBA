test_that("RCAR predicts classes and score matrices", {
  classifier <- RCAR(Species ~ ., iris, supp = 0.05, conf = 0.9,
    lambda = 0.001)
  prediction <- predict(classifier, head(iris, 5))
  scores <- predict(classifier, head(iris, 5), type = "score")

  expect_s3_class(classifier, "CBA")
  expect_identical(levels(prediction), levels(iris$Species))
  expect_identical(dim(scores), c(5L, 3L))
  expect_true(all(is.finite(scores)))
})

test_that("RCAR accepts a binary response in transactions", {
  skip_if_not_installed("mlbench")
  data("Zoo", package = "mlbench")
  transactions <- prepareTransactions(hair ~ ., Zoo,
    logical2factor = FALSE)
  classifier <- RCAR(hair ~ ., transactions, lambda = 0.001)

  expect_s3_class(classifier, "CBA")
  expect_length(predict(classifier, head(transactions, 5)), 5L)
})

test_that("RCAR selects lambda by cross-validation", {
  set.seed(1)
  classifier <- suppressWarnings(RCAR(Species ~ ., iris,
    supp = 0.1, conf = 0.8, cv.glmnet.args = list(nfolds = 3)))

  expect_s3_class(classifier, "CBA")
  expect_false(is.null(classifier$model$cv))
  expect_true(is.finite(classifier$model$cv$lambda.1se))
  expect_length(predict(classifier, head(iris, 5)), 5L)
})
