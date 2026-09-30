test_that("supervised discretization converts numeric predictors", {
  for (method in c("mdlp", "chi2")) {
    result <- suppressWarnings(discretizeDF.supervised(
      Species ~ ., iris, method = method))
    expect_true(all(vapply(result, is.factor, logical(1))))
    expect_identical(levels(result$Species), levels(iris$Species))
    expect_length(result$Species, nrow(iris))
  }
})

test_that("supervised discretization handles missing data", {
  missing <- iris
  missing$Species[1:5] <- NA
  missing$Sepal.Length[6:10] <- NA

  for (method in c("mdlp", "chi2")) {
    result <- suppressWarnings(discretizeDF.supervised(
      Species ~ ., missing, method = method))
    expect_identical(is.na(result$Species), is.na(missing$Species))
    expect_identical(is.na(result$Sepal.Length), is.na(missing$Sepal.Length))
  }
})

test_that("supervised discretization honors the formula", {
  result <- discretizeDF.supervised(
    Species ~ Sepal.Length, iris, method = "mdlp")
  expect_type(result$Sepal.Length, "integer")
  expect_true(is.factor(result$Sepal.Length))
  expect_true(is.numeric(result$Petal.Length))
  expect_error(discretizeDF.supervised(Species ~ ., matrix(1:4, 2)),
    "data needs to be a data.frame")
})
