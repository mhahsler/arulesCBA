# formula helper

.class_is_binary <- function(dat)
  (is.null(itemInfo(dat)$variables) ||
      is.null(itemInfo(dat)$levels))


### data needs to be a data.frame, transactions, itemMatrix or associations (rules)
# returns:
#  - formula
#  - class_names
#  - class_ids
#  - class_items
#  - feature_names
#  - feature_ids
#  - feature_items
.parseformula <- function(formula, data) {
  formula <- as.formula(formula)

  ## prepare data.frame with correct colnames for terms
  if (is(data, "associations"))
    data <- items(data[1])

  if (is(data, "itemMatrix")) {
    trans <- data
    items <- itemLabels(trans)

    if (.class_is_binary(trans)) {
      ### deal with binary case (has no variables or levels in itemInfo)
      vars <- items
      unique_vars <- items
      levels <- items
      labels <- items
    } else {
      ### deal regular case (has variables or levels in itemInfo)
      vars <- as.character(itemInfo(trans)[["variables"]])
      unique_vars <- unique(vars)
      levels <- as.character(itemInfo(trans)[["levels"]])
      labels <- items
    }

    data <-
      as.data.frame(matrix(
        NA,
        nrow = 0,
        ncol = length(unique_vars),
        dimnames = list(row = NULL, col = unique_vars)
      ))
  } else {
    ### data.frame
    if (!is.data.frame(data))
      stop("data needs to be a data.frame, transactions, itemMatrix or associations (rules)!")

    trans <- NULL
    vars <- colnames(data)
    items <- NULL
  }

  trms <- terms(formula, data = data)
  features <- gsub("`", "", colnames(attr(trms, "factors")))
  class <- gsub("`", "", rownames(attr(trms, "factors"))[attr(trms, "response")])

  if (!is.null(trans)) {
    class_ids <- which(vars %in% class)

    if (.class_is_binary(trans))
      class_names <- c("TRUE", "FALSE")
    else
      class_names <- levels[class_ids]

    class_items <- labels[class_ids]

    feature_ids <-
      which(vars %in% features)
    feature_names <- levels[feature_ids]
    feature_items <- labels[feature_ids]
  } else {
    ### data.frame
    class_names <- class
    class_ids <- which(colnames(data) %in% class)
    class_items <- NA

    if (!is.factor(data[[class_ids]]))
      stop("class variable needs to be a factor in the data!")

    feature_names <- features
    feature_ids <- which(colnames(data) %in% features)
    feature_items <- NA
  }

  if (length(class_ids) < 1L)
    stop("Class not found in data. Only use the class name without '='!")

  list(
    formula = formula,
    class_ids = class_ids,
    class_names = class_names,
    class_items = class_items,
    feature_ids = feature_ids,
    feature_names = feature_names,
    feature_items = feature_items
  )
}
