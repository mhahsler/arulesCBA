% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transactions2DF.R
\name{transactions2DF}
\alias{transactions2DF}
\title{Convert Transactions to a Data.Frame}
\usage{
transactions2DF(transactions, itemLabels = FALSE)
}
\arguments{
\item{transactions}{an object of class \link[arules:transactions-class]{arules::transactions}.}

\item{itemLabels}{logical; use the complete item labels (variable=level) as the
levels in the data.frame? By default, only the levels are used.}
}
\value{
Returns a data.frame.
}
\description{
Convert transactions back into data.frames by combining the
items for the same variable into a single column.
}
\examples{
data("iris")
iris_trans <- prepareTransactions(Species ~ ., iris)
iris_trans

# standard conversion
iris_df <- transactions2DF(iris_trans)
head(iris_df)

# use item labels in the data.frame
iris_df2 <- transactions2DF(iris_trans, itemLabels = TRUE)
head(iris_df2)

# Conversion of transactions without variables in itemInfo
data("Groceries")
head(transactions2DF(Groceries), 2)

# Conversion of transactions prepared for classification
g2 <- prepareTransactions(`shopping bags` ~ ., Groceries)
head(transactions2DF(g2), 2)
}
\seealso{
Other preparation: 
\code{\link{CBA_ruleset}()},
\code{\link{discretizeDF.supervised}()},
\code{\link{mineCARs}()},
\code{\link{prepareTransactions}()}
}
\author{
Michael Hahsler
}
\concept{preparation}
