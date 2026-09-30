test_that("custom rule sets predict from transactions", {
  train <- iris[c(1:40, 51:90, 101:140), ]
  test <- iris[c(41:50, 91:100, 141:150), ]

  train_transactions <- prepareTransactions(Species ~ ., train)
  rules <- mineCARs(Species ~ ., train_transactions,
    support = 0.01, confidence = 0.8, verbose = FALSE)
  expect_gt(length(rules), 0L)

  classifier <- CBA_ruleset(Species ~ ., rules,
    default = majorityClass(Species ~ ., train_transactions),
    method = "majority", discretization = attr(train_transactions, "disc_info"))

  expect_s3_class(classifier, "CBA")
  expect_length(predict(classifier, test), nrow(test))
  expect_identical(levels(predict(classifier, test)), levels(iris$Species))
  expect_output(print(classifier), "CBA Classifier Object")
})

test_that("custom rule sets validate the default class", {
  transactions <- prepareTransactions(Species ~ ., iris)
  rules <- mineCARs(Species ~ ., transactions,
    support = 0.1, confidence = 0.8, verbose = FALSE)

  expect_error(CBA_ruleset(Species ~ ., rules, default = "unknown"),
    "default does not uniquely partial match")
  expect_identical(
    as.character(CBA_ruleset(Species ~ ., rules, default = "set")$default),
    "setosa"
  )
})
