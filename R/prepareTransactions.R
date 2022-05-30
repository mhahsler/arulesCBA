#' Prepare Data for Associative Classification
#'
#' Converts data.frame into transactions suitable for classification based on association rules.
#'
#' To convert a data.frame into items in a transaction dataset for classification,
#' the following steps are performed:
#'
#' 1. All continuous features are discretized using class-based
#'   discretization (default is MDLP) and each range is represented as an item.
#' 2. Factors are converted into items, one item for each level.
#' 3. Each logical is converted into an item.
#' 4. If the class variable is a logical, then a negative class item is added.
#'
#' Steps 1-3 are skipped if `data` is already as [arules::transactions] object.
#'
#' @param formula the formula.
#' @param data a data.frame with the data.
#' @param disc.method Discretization method used to discretize continuous
#'   variables if data is a data.frame (default: `"mdlp"`). See
#'   [discretizeDF.supervised()] for more supervised discretization
#'   methods.
#' @param match typically `NULL`. Only used internally if data is a
#'   already a set of transactions.
#' @return An object of class [arules::transactions] from
#'   \pkg{arules} with an attribute called `"disc_info"` that contains
#'   information on the used discretization for each column.
#' @author Michael Hahsler
#' @seealso [arules::transactions], `transactions2DF()`.
#' @examples
#' # Perform discretization and convert to transactions
#' data("iris")
#' iris_trans <- prepareTransactions(Species ~ ., iris)
#' inspect(head(iris_trans))
#'
#' # A negative class item is added for regular transaction data (here "!canned beer")
#' # Note: backticks are needed in formulas with item labels that contain a space.
#' data("Groceries")
#' g2 <- prepareTransactions(`canned beer` ~ ., Groceries)
#' inspect(head(g2))
#' @export
prepareTransactions <-
  function(formula,
    data,
    disc.method = "mdlp",
    match = NULL) {
    if (is(data, "transactions")) {
      ### add negative items to handle regular transaction data without variable info
      if (is.null(itemInfo(data)$variables))
        data <- addComplement(data, all.vars(formula)[1])

      ### Note: transactions might need recoding!
      if (!is.null(match))
        return(recode(data, itemLabels = itemLabels(match)))
      else
        return(data)
    }

    # handle logical variables by making them into factors (so FALSE is preserved)
    if (!is(data, "transactions")) {
      for (i in 1:ncol(data))
        if (is.logical(data[[i]]))
          data[[i]] <- factor(data[[i]], levels = c(TRUE, FALSE))
    }
    # disc.method is a character string with the method
    if (!is.list(disc.method)) {
      disc_info <- NULL
      data <-
        discretizeDF.supervised(formula, data, method = disc.method)
      disc_info <- lapply(data, attr, "discretized:breaks")

      data <- as(data, "transactions")
      attr(data, "disc_info") <- disc_info

      return(data)
    }

    ### disc is a list with discretization info
    data <- discretizeDF(data, lapply(
      disc.method,
      FUN = function(x)
        list(method = "fixed", breaks = x)
    ))
    data <- as(data, "transactions")

    return(data)
  }
