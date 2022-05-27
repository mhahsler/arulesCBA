library("testthat")
library("arulesCBA")
data("iris")

set.seed(0)

context("Test binary transactions")
data(Groceries)
dat <- sample(Groceries, 100)
f <- `bottled beer` ~ .

classes(f, dat)
response(f, dat)
classFrequency(f, dat)
majorityClass(f, dat)


context("Test multivalue transactions")
data(iris)
dat <- iris
f <- Species ~ .

classes(f, dat)
response(f, dat)
classFrequency(f, dat)
majorityClass(f, dat)
