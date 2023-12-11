#' FL_local_summary: computes the summary statistics from local servers
#'
#'This comprehensive function is used to calculate summary statistics from local servers needed to implement federated learning procedure. The function is designed to be user-friendly.It provides
#' summary statistics using a pre-specified model.
#'
#' @param formula is the pre-specified model you want to fit in the central server
#' @param data local server data
#' @details
#' The function computes SSX, SSY, SSXY based on the dataset given.
#
#' @return A list including elements
#' \item{xtx}{a matrix for the sum of squares of X}
#' \item{xty}{a matrix for the sum of squares of XY}
#' \item{yty}{a scalar value for the sum of squares of Y}
#' \item{n}{sample size of the local server}
#'
#' @author Justice Akuoko-Frimpong
#' @author Jonathan Ta
#' @author Michael Kaye
#'
#' @examples
#'set.seed(42)  # For reproducibility
#' # Simulating dataset1
#' age1 = rnorm(100, mean = 50, sd = 10)  # simulating age
#' income1 = rnorm(100, mean = 50000, sd = 10000)  # simulating income
#' noise1 = rnorm(100, 0, 1)  # some noise
#'Purchase1 = 20000 + 500*age1 + 0.05*income1 + 10*age1*income1/100000 + noise1  # creating a relationship for Purchase
#'data1 = data.frame(age = age1, income = income1, Purchase = Purchase1)
#'summary1 = FL_local_summary(Purchase ~ age + income +income:age, data1)
#'print(summary1)
#'# Simulating dataset2 in a similar way
#'age2 = rnorm(100, mean = 50, sd = 10)
#'income2 = rnorm(100, mean = 50000, sd = 10000)
#'noise2 = rnorm(100, 0, 1)
#'Purchase2 = 20000 + 500*age2 + 0.05*income2 + 10*age2*income2/100000 + noise2
#'data2 = data.frame(age = age2, income = income2, Purchase = Purchase2)
#'summary2 = FL_local_summary(Purchase ~ age + income +income:age, data2)
#'
#'@importFrom stats model.matrix pt
#'@export
#'
FL_local_summary = function(formula, data) {
  # Adjust the contrast settings to use one-hot encoding for factors
  options(contrasts = c("contr.sum", "contr.poly"))

  # model.matrix automatically adds an intercept
  model_matrix = model.matrix(formula, data)

  # Automatically get the outcome variable name from the formula
  outcome = as.character(formula(formula)[[2]])

  xtx = crossprod(model_matrix)
  xty = crossprod(model_matrix, data[[outcome]])
  yty = crossprod(data[[outcome]])
  n = nrow(data)

  return(list(xtx = xtx, xty = xty, yty = yty, n = n))
}

#' FL_combine: computes the combine summary
#'
#' This function computes the combine summary using individual local summaries.
#'
#' Description of Function 2.
#'
#' @param summaries A list containing local summaries from individual groups
#'
#' @return A list including elements
#' \item{xtx}{a matrix for the combined sum of squares of X}
#' \item{xty}{a matrix for the combined sum of squares of XY}
#' \item{yty}{a scalar value for the combined sum of squares of Y}
#' \item{n}{the total sample size}
#'
#' @examples
#'set.seed(42)  # For reproducibility
#' # Simulating dataset1
#' age1 = rnorm(100, mean = 50, sd = 10)  # simulating age
#' income1 = rnorm(100, mean = 50000, sd = 10000)  # simulating income
#' noise1 = rnorm(100, 0, 1)  # some noise
#'Purchase1 = 20000 + 500*age1 + 0.05*income1 + 10*age1*income1/100000 + noise1  # creating a relationship for Purchase
#'data1 = data.frame(age = age1, income = income1, Purchase = Purchase1)
#'summary1 = FL_local_summary(Purchase ~ age + income +income:age, data1)
#'print(summary1)
#'# Simulating dataset2 in a similar way
#'age2 = rnorm(100, mean = 50, sd = 10)
#'income2 = rnorm(100, mean = 50000, sd = 10000)
#'noise2 = rnorm(100, 0, 1)
#'Purchase2 = 20000 + 500*age2 + 0.05*income2 + 10*age2*income2/100000 + noise2
#'data2 = data.frame(age = age2, income = income2, Purchase = Purchase2)
#'summary2 = FL_local_summary(Purchase ~ age + income +income:age, data2)
#'combined_summaries = FL_combine(list(summary1, summary2))
#'@export
#'
FL_combine = function(summaries) {
  # combine each summary from the local servers  by adding
  combined_xtx = Reduce("+", lapply(summaries, function(summary) summary$xtx))
  combined_xty = Reduce("+", lapply(summaries, function(summary) summary$xty))
  combined_yty = Reduce("+", lapply(summaries, function(summary) summary$yty))
  combined_n = sum(sapply(summaries, function(summary) summary$n))
  p = dim(combined_xtx)[1]
  return(list(xtx = combined_xtx, xty = combined_xty, yty = combined_yty, n = combined_n))
}


#' FL: uses local summaries to fit a linear regression model
#'
#' This comprehensive function implements federated learning procedure by combining summaries fro local servers to fit a linear model.
#' It provides estimates of the Regression coefficients, standard errors, t values, p values of the estimates.
#'
#' @param summary a list containing the combined local summaries from individual servers.
#'
#' @return A dataframe made up of the foloowing columns
#' \item{Estimate}{The estimated values of the regression coefficients}
#' \item{Std.Error}{The standard errors of the estimates}
#' \item{t value}{t values computed using the estimates and standard errors}
#' \item{p value}{p values of the t statistics used to test the significance of the regression coefficients}
#'
#' @author Justice Akuoko-Frimpong
#' @author Jonathan Ta
#' @author Michael Kaye
#'
#' @examples
#' set.seed(42)  # For reproducibility
#'# Simulating dataset1
#'age1 = rnorm(100, mean = 50, sd = 10)  # simulating age
#'income1 = rnorm(100, mean = 50000, sd = 10000)  # simulating income
#'noise1 = rnorm(100, 0, 1)  # some noise
#'Purchase1 = 20000 + 500*age1 + 0.05*income1 + 10*age1*income1/100000 + noise1  # creating a relationship for Purchase
#'data1 = data.frame(age = age1, income = income1, Purchase = Purchase1)
#'# Simulating dataset2 in a similar way
#'age2 = rnorm(100, mean = 50, sd = 10)
#'income2 = rnorm(100, mean = 50000, sd = 10000)
#'noise2 = rnorm(100, 0, 1)
#'Purchase2 = 20000 + 500*age2 + 0.05*income2 + 10*age2*income2/100000 + noise2
#'data2 = data.frame(age = age2, income = income2, Purchase = Purchase2)
#'summary1 = FL_local_summary(Purchase ~ age + income +income:age, data1)
#'summary2 = FL_local_summary(Purchase ~ age + income + income:age, data2)
#'combined_summaries = FL_combine(list(summary1, summary2))
#' soln = FL(combined_summaries)
#' print(soln)
#'
#'@export
#'
FL = function(summary) {
  # Get the estimates and standard errors of the coefficients
  beta_hat = solve(summary$xtx) %*% (summary$xty)
  SSE =  summary$yty - 2*(t(beta_hat) %*% summary$xty) + (t(beta_hat) %*% summary$xtx %*% beta_hat)
  sigmasq_hat = SSE / (summary$n - length(beta_hat))

  # Compute covariance matrix
  cov_mat =  as.numeric(sigmasq_hat) * solve(summary$xtx)

  # Compute standard error, t values and p values
  std_error = sqrt(diag(cov_mat))
  t_values = beta_hat / std_error
  p_values = 2 * pt(-abs(t_values), df = summary$n - length(beta_hat))

  # Create a dataframe for output
  result = data.frame(Estimate = beta_hat,
                      `Std. Error` = std_error,
                      `t value` = t_values,
                      `p value` = p_values)

  rownames(result) = colnames(summary$xtx)

  return(result)
}

