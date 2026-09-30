test_that("CBA trains and predicts with M1 and M2 pruning", {
  for (pruning in c("M1", "M2")) {
    classifier <- CBA(Species ~ ., iris, supp = 0.05, conf = 0.9,
      pruning = pruning, verbose = FALSE)

    expect_s3_class(classifier, "CBA")
    expect_gt(length(classifier$rules), 0L)
    prediction <- predict(classifier, iris)
    expect_identical(levels(prediction), levels(iris$Species))
    expect_length(prediction, nrow(iris))
    expect_gt(accuracy(prediction, iris$Species), 0.8)
  }
})

test_that("CBA falls back to the default class when no rules are mined", {
  classifier <- CBA(Species ~ ., iris, supp = 1, conf = 0.9,
    verbose = FALSE)

  expect_length(classifier$rules, 0L)
  expect_identical(as.character(classifier$default), "setosa")
  expect_identical(
    predict(classifier, head(iris, 5)),
    factor(rep("setosa", 5), levels = levels(iris$Species))
  )
  expect_error(predict(classifier, head(iris), type = "score"),
    "not yet implemented")
})

test_that("CBA prediction methods return classes and scores", {
  classifier <- CBA(Species ~ ., iris, supp = 0.05, conf = 0.9,
    verbose = FALSE)
  for (method in c("majority", "weighted")) {
    classifier$method <- method
    prediction <- predict(classifier, head(iris, 5))
    scores <- predict(classifier, head(iris, 5), type = "score")
    expect_identical(levels(prediction), levels(iris$Species))
    expect_identical(dim(scores), c(5L, 3L))
    expect_true(all(is.finite(scores)))
  }

  classifier$method <- "first"
  expect_error(predict(classifier, head(iris), type = "score"),
    "not supported")
})
