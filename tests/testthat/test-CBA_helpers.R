test_that("class helpers agree across data frames and transactions", {
  data <- data.frame(
    class = factor(c("a", "a", "b", "a"), levels = c("a", "b")),
    predictor = factor(c("x", "y", "x", "y"))
  )
  transactions <- prepareTransactions(class ~ ., data)

  for (input in list(data, transactions)) {
    expect_identical(classes(class ~ ., input), c("a", "b"))
    expect_identical(as.character(response(class ~ ., input)),
      as.character(data$class))
    expect_equal(as.numeric(classFrequency(class ~ ., input,
      type = "absolute")), c(3, 1))
    expect_equal(as.numeric(classFrequency(class ~ ., input)), c(0.75, 0.25))
    expect_identical(as.character(majorityClass(class ~ ., input)), "a")
  }
})

test_that("logical responses work with both conversion modes", {
  data <- data.frame(
    flag = c(TRUE, TRUE, FALSE, TRUE),
    predictor = factor(c("a", "b", "a", "b"))
  )
  for (convert in c(TRUE, FALSE)) {
    transactions <- prepareTransactions(flag ~ ., data,
      logical2factor = convert)
    expect_identical(classes(flag ~ ., transactions), c("TRUE", "FALSE"))
    expect_identical(as.character(response(flag ~ ., transactions)),
      as.character(data$flag))
    expect_equal(as.numeric(classFrequency(flag ~ ., transactions,
      type = "absolute")), c(3, 1))
  }
})

test_that("coverage helpers account for uncovered transactions", {
  transactions <- prepareTransactions(Species ~ ., iris)
  rules <- mineCARs(Species ~ ., transactions,
    support = 0.1, confidence = 0.8, verbose = FALSE)
  chosen <- head(rules, 3)
  coverage <- transactionCoverage(transactions, chosen)
  uncovered <- uncoveredClassExamples(Species ~ ., transactions, chosen)

  expect_length(coverage, nrow(iris))
  expect_true(all(coverage >= 0 & coverage <= length(chosen)))
  expect_equal(sum(uncovered), sum(coverage == 0))
  expect_identical(
    uncoveredMajorityClass(Species ~ ., transactions, chosen),
    names(which.max(uncovered))
  )
})

test_that("accuracy validates factor levels", {
  truth <- factor(c("a", "b", "a"), levels = c("a", "b"))
  prediction <- factor(c("a", "a", "a"), levels = c("a", "b"))
  expect_equal(accuracy(prediction, truth), 2 / 3)
  expect_error(accuracy(factor(c("a", "a", "a")), truth),
    "matching levels")
})
