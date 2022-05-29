library("testthat")
library("arulesCBA")
data("iris")

options(digits = 2)

context("Test classifiers")

classifiers <- c(cba = CBA, foil = FOIL, rcar = RCAR)
if ("RWeka" %in% utils::installed.packages()[, "Package"])
  classifiers <-
  append(classifiers,
    c(ripper = RIPPER_CBA, part = PART_CBA, c45 = C4.5_CBA))

### use raw data
dat <- iris
f <- Species ~ .
true <- response(f, dat)

### train and in-sample testing
for (cl in classifiers) {
  res <- cl(f, dat)
  res

  p <- predict(res, dat)

  expect_equal(length(p), nrow(dat))
  expect_equal(levels(p), levels(true))

  accuracy(p, true)
}

### use transactions
dat <- prepareTransactions(f, iris)

for (cl in classifiers) {
  res <- cl(f, dat)
  res

  p <- predict(res, dat)

  expect_equal(length(p), nrow(dat))
  expect_equal(levels(p), levels(true))

  accuracy(p, true)
}

### use regular transactions
# NOTE: this does not work with Weka-based classifiers.
classifiers <- c(cba = CBA, foil = FOIL, rcar = RCAR)

data(Groceries)
dat <- sample(Groceries, 500)
f <- `bottled beer` ~ .
true <- response(f, dat)

for (cl in classifiers) {
  res <- cl(f, dat)
  res

  p <- predict(res, dat)

  expect_equal(length(p), nrow(dat))
  expect_equal(levels(p), levels(true))

  accuracy(p, true)
}

## test transactions with logical variables
#classifiers <- c(CBA, FOIL, RCAR)
# RCAR is too slow
classifiers <- c(CBA, FOIL)
if ("RWeka" %in% utils::installed.packages()[, "Package"])
  classifiers <-
  append(classifiers, c(RIPPER_CBA, PART_CBA, C4.5_CBA))

data(Zoo, package = "mlbench")
Zoo$legs <- Zoo$legs > 0

dat <- Zoo
f <- type ~ .
true <- response(f, dat)

for (cl in classifiers) {
  res <- cl(f, dat)
  res

  p <- predict(res, dat)

  expect_equal(length(p), nrow(dat))
  expect_equal(levels(p), levels(true))

  accuracy(p, true)
}
