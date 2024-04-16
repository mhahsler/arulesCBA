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
#' Steps 1-3 are skipped if `data` is already a [arules::transactions] object.
#'
#' @family preparation
#'
#' @param formula the formula.
#' @param data a data.frame with the data.
#' @param disc.method Discretization method used to discretize continuous
#'   variables if data is a data.frame (default: `"mdlp"`). See
#'   [discretizeDF.supervised()] for more supervised discretization
#'   methods.
#' @param logical2factor logical; if `data` is a data.frame, should logical columns
#'   be recoded as factor with TRUE/FALSE to generate positive and negative items?
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
#'
#' inspect(head(iris_trans))
#' itemInfo(iris_trans)
#'
#' # A negative class item is added for regular transaction data. Here we get the
#' # items "canned beer=TRUE" and "canned beer=FALSE".
#' # Note: backticks are needed in formulas with item labels that contain
#' # a space or special character.
#' data("Groceries")
#' g2 <- prepareTransactions(`canned beer` ~ ., Groceries)
#'
#' inspect(head(g2))
#' ii <- itemInfo(g2)
#' ii[ii[["variables"]] == "canned beer", ]
#' @export
prepareTransactions <-
  function(formula,
           data,
           disc.method = "mdlp",
           logical2factor = TRUE,
           match = NULL) {
    if (is(data, "transactions")) {
      ### just add negative items to handle regular transaction data without variable info
      pf <- .parseformula(formula, data)

      if (length(pf$class_ids) == 1L) {
        data <-
          addComplement(data,
                        pf$class_items,
                        complementLabels = paste0(pf$class_items, "=FALSE"))
        itemLabels(data)[pf$class_ids] <-
          paste0(pf$class_items, "=TRUE")
      }


      ### Note: transactions might need recoding!
      if (!is.null(match))
        data <- recode(data, itemLabels = itemLabels(match))

      return(data)
    }

    # deal with data.frame

    # handle logical variables by making them into factors (so FALSE is preserved)
    if (logical2factor) {
      for (i in 1:ncol(data))
        if (is.logical(data[[i]]))
          data[[i]] <- factor(data[[i]], levels = c(TRUE, FALSE))
    } else {
    # handle class variable
      pf <- .parseformula(formula, data)
      if (is.logical(data[[pf$class_ids]]))
        data[[pf$class_ids]] <- factor(data[[pf$class_ids]], levels = c("TRUE", "FALSE"))
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

    as(data, "transactions")
  }
