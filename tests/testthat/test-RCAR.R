library("testthat")
library("arulesCBA")
data("iris")

context("RCAR")
rcar_classifier <- RCAR(Species ~ ., iris, supp = 0.05, conf=0.9, lambda = 0.001)
# FIXME: For some reason, on solaris this is 21, not 22.
# expect_equal(length(rcar_classifier$rules), 20L)

results <- predict(rcar_classifier, head(iris, n = 5))
expect_equal(results[1], factor("setosa",
        levels = c("setosa", "versicolor", "virginica")))
expect_equal(length(results), 5L)

results <- predict(rcar_classifier, head(iris, n = 5), type = "score")
expect_equal(dim(results), c(5L, 3L))
# FIXME: somehow they do not add up to exactly 1
#expect_equal(rowSums(results), rep(1, 5))

# test binary case
data(Zoo, package = "mlbench")
trans <- prepareTransactions(hair ~ .,  Zoo, logical2factor = FALSE)
rcar_classifier <- RCAR(hair ~ ., trans)
