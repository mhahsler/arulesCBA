test_that("transaction conversion round-trips categorical data", {
  input <- data.frame(
    class = factor(c("yes", "no", "yes"), levels = c("yes", "no")),
    color = factor(c("red", "blue", "red"), levels = c("red", "blue")),
    flag = c(TRUE, FALSE, TRUE)
  )
  transactions <- prepareTransactions(class ~ ., input)
  restored <- transactions2DF(transactions)
  labeled <- transactions2DF(transactions, itemLabels = TRUE)

  expect_identical(as.character(restored$class), as.character(input$class))
  expect_identical(as.character(restored$color), as.character(input$color))
  expect_identical(as.character(restored$flag), as.character(input$flag))
  expect_true(all(grepl("=", levels(labeled$color), fixed = TRUE)))
})

test_that("regular transactions convert to indicator columns", {
  data("Groceries", package = "arules")
  raw <- head(Groceries, 4)
  converted <- transactions2DF(raw)
  expect_identical(dim(converted), c(4L, ncol(raw)))
  expect_true(all(vapply(converted, is.logical, logical(1))))
})

test_that("mining only returns rules for the requested class", {
  transactions <- prepareTransactions(Species ~ ., iris)
  rules <- mineCARs(Species ~ ., transactions,
    support = 0.1, confidence = 0.8, verbose = FALSE)

  expect_gt(length(rules), 0L)
  expect_true(all(as.character(response(Species ~ ., rules)) %in%
    levels(iris$Species)))
  expect_true(all(arules::quality(rules)$confidence >= 0.8))
})

test_that("balanced mining accepts automatic and explicit class support", {
  transactions <- prepareTransactions(Species ~ ., iris)
  automatic <- mineCARs(Species ~ ., transactions,
    balanceSupport = TRUE, support = 0.1, verbose = FALSE)
  explicit <- mineCARs(Species ~ ., transactions,
    balanceSupport = rep(0.1, 3), verbose = FALSE)

  expect_gt(length(automatic), 0L)
  expect_gt(length(explicit), 0L)
  expect_error(mineCARs(Species ~ ., transactions,
    balanceSupport = c(0.1, 0.1), verbose = FALSE),
    "One support value for each class label")
})
