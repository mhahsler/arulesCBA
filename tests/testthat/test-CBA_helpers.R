library("testthat")
library("arulesCBA")
data("iris")

set.seed(0)

context("Test binary transactions")
data(Groceries)
dat <- sample(Groceries, 100)
f <- `bottled beer` ~ .
cls <- c("TRUE", "FALSE")

expect_equal(classes(f, dat), cls)

r <- response(f, dat)
expect_equal(length(r), nrow(dat))
expect_equal(levels(r), cls)

r <- classFrequency(f, dat)
expect(length(r), length(cls) )

r <- majorityClass(f, dat)
expect_equal(length(r), 1L)
expect_equal(levels(r), cls)



context("Test multivalue transactions")
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
