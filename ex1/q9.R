# glmnet cv lasso
source("ex1/q2.R")


cv_lasso <- cv.glmnet(X, y, family="poisson", alpha=1)
cv_lasso$lambda.min

# print the coefficients
coef(cv_lasso, s="lambda.min")

# q2
ridge_cv <- cv.glmnet(X, y, family="poisson", alpha=0)
lasso_cv <- cv.glmnet(X, y, family="poisson", alpha=1)


# get the lambda
lambda_ridge <- ridge_cv$lambda.min
lambda_lasso <- lasso_cv$lambda.min

boot.fn.mle <- function(data, index) {
  d <- data[index, ]
  x <- d[, -1]
  y <- d[, 1]
  model <- glmnet(x, y, family="poisson", alpha=0, lambda=0)
  return(as.vector(coef(model)))
}

boot.fn.ridge <- function(data, index) {
  d <- data[index, ]
  x <- d[, -1]
  y <- d[, 1]
  model <- glmnet(x, y, family="poisson", alpha=0, lambda=lambda_ridge)
  return(as.vector(coef(model)))
}

boot.fn.lasso <- function(data, index) {
  d <- data[index, ]
  x <- d[, -1]
  y <- d[, 1]
  model <- glmnet(x, y, family="poisson", alpha=1, lambda=lambda_lasso)
  return(as.vector(coef(model)))
}


bootstrap_results_mle <- bootstrap(yX, boot.fn.mle, R = 1000)
bootstrap_results_ridge <- bootstrap(yX, boot.fn.ridge, R = 1000)
bootstrap_results_lasso <- bootstrap(yX, boot.fn.lasso, R = 1000)


newton_variance <- apply(bootstrap_results_mle$boot_results, 2, var, na.rm = TRUE)
ridge_variance <- apply(bootstrap_results_ridge$boot_results, 2, var, na.rm = TRUE)
lasso_variance <- apply(bootstrap_results_lasso$boot_results, 2, var, na.rm = TRUE)

newton_variance
ridge_variance
lasso_variance







