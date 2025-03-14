source("ex1/q6.R")

# 10-fold cross validation to estimate the error of lambda=10

predict_newton <- function(model, newdata) {
  # add intercept to newdata
  newdata <- cbind(1, newdata)
  eta <- as.vector(newdata %*% model$beta)
  fit <- eta
  fit <- exp(fit)
  return(fit)
}

k_fold <- function(X, y, lambda, k) {
  index <- sample(nrow(X))
  X <- X[index, ]
  y <- y[index]
  # add intercept to X
  n <- nrow(X)
  fold_size <- n / k
  errors <- numeric(k)
  for (i in 1:k) {
    test_index <- ((i - 1) * fold_size + 1):(i * fold_size)
    test_X <- X[test_index, ]
    test_y <- y[test_index]
    train_X <- X[-test_index, ]
    train_y <- y[-test_index]
  }
  model <- newton_method_l2(train_X, train_y, lambda)
  pred <- predict_newton(model, test_X)
  errors[i] <- mean(abs(pred - test_y))

  return(mean(errors))
}

cat("10-fold cross validation error: ", k_fold(X, y, lambda=10, k=10), "\n")

# use a specific lambda for glmnet
k_fold_result <- cv.glmnet(X, y, family="poisson", alpha=0)
cat("10-fold cross validation best lambda: ", k_fold_result$lambda.min, "\n")

min_lambda <- k_fold_result$lambda.min


k_fold_glmnet <- function(X, y, lambda, k) {
  # randomize X and y
  index <- sample(nrow(X))
  X <- X[index, ]
  y <- y[index]

  # add intercept to X
  n <- nrow(X)
  fold_size <- n / k
  errors <- numeric(k)
  for (i in 1:k) {
    test_index <- ((i - 1) * fold_size + 1):(i * fold_size)
    test_X <- X[test_index, ]
    test_y <- y[test_index]
    train_X <- X[-test_index, ]
    train_y <- y[-test_index]
  }
  model <- glmnet(train_X, train_y, family="poisson", alpha=0, lambda=lambda)
  pred <- predict(model, test_X, s=lambda)
  errors[i] <- mean(abs(pred - test_y))

  return(mean(errors))
}

cat("10-fold cross validation error: ", k_fold_glmnet(X, y, lambda=min_lambda, k=10), "\n")
cat("10-fold cross validation error: ", k_fold(X, y, lambda=min_lambda, k=10), "\n")
