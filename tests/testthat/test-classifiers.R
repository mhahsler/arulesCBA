test_that("core classifiers predict from data frames and transactions", {
  classes <- list(CBA = CBA, FOIL = FOIL, RCAR = RCAR)
  inputs <- list(data_frame = iris,
    transactions = prepareTransactions(Species ~ ., iris))

  for (name in names(classes)) {
    for (input in inputs) {
      classifier <- if (name == "RCAR")
        classes[[name]](Species ~ ., input, lambda = 0.001)
      else
        classes[[name]](Species ~ ., input)
      prediction <- predict(classifier, input)

      expect_s3_class(classifier, "CBA")
      expect_identical(levels(prediction), levels(iris$Species))
      expect_length(prediction, nrow(iris))
      expect_gt(accuracy(prediction, iris$Species), 0.7)
    }
  }
})

test_that("core classifiers accept regular transactions", {
  data("Groceries", package = "arules")
  transactions <- head(Groceries, 200)
  truth <- response(`bottled beer` ~ ., transactions)

  for (name in c("CBA", "FOIL", "RCAR")) {
    classifier <- switch(name,
      CBA = CBA(`bottled beer` ~ ., transactions),
      FOIL = FOIL(`bottled beer` ~ ., transactions),
      RCAR = RCAR(`bottled beer` ~ ., transactions, lambda = 0.001))
    prediction <- predict(classifier, transactions)
    expect_length(prediction, length(transactions))
    expect_identical(levels(prediction), levels(truth))
  }
})

test_that("CBA and FOIL accept logical predictors", {
  skip_if_not_installed("mlbench")
  data("Zoo", package = "mlbench")
  Zoo$legs <- Zoo$legs > 0

  for (classifier_fn in list(CBA, FOIL)) {
    classifier <- classifier_fn(type ~ ., Zoo)
    prediction <- predict(classifier, Zoo)
    expect_length(prediction, nrow(Zoo))
    expect_identical(levels(prediction), levels(Zoo$type))
  }
})

test_that("RWeka classifier wrappers predict when Java is available", {
  skip_if_not_installed("RWeka")
  skip_if_not_installed("rJava")

  for (classifier_fn in list(RIPPER_CBA, PART_CBA, C4.5_CBA)) {
    classifier <- classifier_fn(Species ~ ., iris)
    prediction <- predict(classifier, head(iris, 5))
    expect_s3_class(classifier, "CBA")
    expect_length(prediction, 5L)
    expect_identical(levels(prediction), levels(iris$Species))
  }
})

test_that("bundled LUCS-KDD classifiers predict from both input types", {
  skip_if(!nzchar(Sys.which("java")), "Java is not available")

  package_dir <- system.file(package = "arulesCBA")
  expect_true(file.exists(file.path(package_dir, "LUCS_KDD", "CMAR.jar")))
  expect_true(file.exists(file.path(package_dir, "LUCS_KDD", "FOIL_CPAR_PRM.jar")))

  classifiers <- list(CMAR = CMAR, CPAR = CPAR, PRM = PRM, FOIL2 = FOIL2)
  inputs <- list(data_frame = iris,
    transactions = prepareTransactions(Species ~ ., iris))

  for (name in names(classifiers)) {
    for (input in inputs) {
      classifier <- classifiers[[name]](Species ~ ., input)
      prediction <- predict(classifier, head(input, 5))

      expect_s3_class(classifier, "CBA")
      expect_gt(length(classifier$rules), 0L)
      expect_length(prediction, 5L)
      expect_identical(levels(prediction), levels(iris$Species))
    }
  }
})
