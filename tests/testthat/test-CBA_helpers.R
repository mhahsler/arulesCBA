library("testthat")
library("arulesCBA")

data("Zoo", package = "mlbench")
dat <- Zoo

context("Test binary class item")
f <- `hair` ~ .
cls <- c("TRUE", "FALSE")

r <- response(f, dat)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

expect_equal(classes(f, dat), cls)

r <- classFrequency(f, dat)
expect(length(r), length(cls) )

r <- majorityClass(f, dat)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)


# prepareTransactions
trans <- prepareTransactions(f, dat)

r <- response(f, trans)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

expect_equal(classes(f, trans), cls)

r <- classFrequency(f, trans)
expect(length(r), length(cls) )

r <- majorityClass(f, trans)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)

# prepareTransactions without converting logical to factors
trans <- prepareTransactions(f, dat, logical2factor = FALSE)

r <- response(f, trans)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

expect_equal(classes(f, trans), cls)

r <- classFrequency(f, trans)
expect(length(r), length(cls) )

r <- majorityClass(f, trans)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)


# raw transactions
trans <- transactions(dat[, -13])

expect_equal(classes(f, trans), cls)

r <- response(f, trans)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

r <- classFrequency(f, trans)
expect(length(r), length(cls) )

r <- majorityClass(f, trans)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)


context("Test multivalue class item")
f <- `type` ~ .
cls <- levels(dat$type)

expect_equal(classes(f, dat), cls)

r <- response(f, dat)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

r <- classFrequency(f, dat)
expect(length(r), length(cls) )

r <- majorityClass(f, dat)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)

# trans version
trans <- prepareTransactions(f, dat)

expect_equal(classes(f, trans), cls)

r <- response(f, trans)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

r <- classFrequency(f, trans)
expect(length(r), length(cls) )

r <- majorityClass(f, trans)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)


context("Test multivalue class item 2")
data(iris)
dat <- iris
f <- Species ~ .
cls <- c("setosa", "versicolor", "virginica")

expect_equal(classes(f, dat), cls)

r <- response(f, dat)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

r <- classFrequency(f, dat)
expect(length(r), length(cls) )

r <- majorityClass(f, dat)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)


# test on transactions
trans <- prepareTransactions(f, dat)

expect_equal(classes(f, trans), cls)

r <- response(f, trans)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

r <- classFrequency(f, trans)
expect(length(r), length(cls) )

r <- majorityClass(f, trans)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)
