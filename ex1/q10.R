source("ex1/q7.R")
source("ex1/q8.R")

# create validation set randomly

N <- 30


run <- function(X, y, N) {
  n <- nrow(X)
  mse_results <- data.frame(
    newton_mse = numeric(N),
    ridge_newton_mse = numeric(N),
    ridge_mse = numeric(N),
    lasso_mse = numeric(N)
  )

  mae_results <- data.frame(
    newton_mae = numeric(N),
    ridge_newton_mae = numeric(N),
    ridge_mae = numeric(N),
    lasso_mae = numeric(N)
  )

  for (i in 1:N) {
    validation_index <- sample(1:n, size = 0.1 * n)
    validation_X <- X[validation_index, ]
    validation_y <- y[validation_index]

    # create training set
    train_X <- X[-validation_index, ]
    train_y <- y[-validation_index]


    # fit all models
    newton_model <- newton_method(train_X, train_y)

    newton_pred <- predict_newton(newton_model, validation_X)
    newton_mse <- mean((newton_pred - validation_y)^2)
    newton_mae <- mean(abs(newton_pred - validation_y))

    ridge_cv_lambda <- cv.glmnet(train_X, train_y, family="poisson", alpha=0)$lambda.min
    cat("ridge_cv_lambda: ", ridge_cv_lambda, "\n")

    ridge_newton_model <- newton_method_l2(train_X, train_y, lambda=ridge_cv_lambda)
    ridge_newton_pred <- predict_newton(ridge_newton_model, validation_X)
    ridge_newton_mse <- mean((ridge_newton_pred - validation_y)^2)
    ridge_newton_mae <- mean(abs(ridge_newton_pred - validation_y))


    ridge_model <- glmnet(train_X, train_y, family="poisson", alpha=0, lambda=ridge_cv_lambda)
    ridge_pred <- predict(ridge_model, validation_X, s=ridge_cv_lambda, type="response")
    ridge_mse <- mean((ridge_pred - validation_y)^2)
    ridge_mae <- mean(abs(ridge_pred - validation_y))


    lasso_cv_lambda <- cv.glmnet(train_X, train_y, family="poisson", alpha=1)$lambda.min
    cat("lasso_cv_lambda: ", lasso_cv_lambda, "\n")

    lasso_model <- glmnet(train_X, train_y, family="poisson", alpha=1, lambda=lasso_cv_lambda)
    lasso_pred <- predict(lasso_model, validation_X, s=lasso_cv_lambda, type="response")
    lasso_mse <- mean((lasso_pred - validation_y)^2)
    lasso_mae <- mean(abs(lasso_pred - validation_y))

    mse_results[i, ] <- c(newton_mse, ridge_newton_mse, ridge_mse, lasso_mse)
    mae_results[i, ] <- c(newton_mae, ridge_newton_mae, ridge_mae, lasso_mae)
  }
  mse_results_mean <- colMeans(mse_results)
  mse_results_mean

  rmse_results_mean <- sqrt(mse_results_mean)


  mae_results_mean <- colMeans(mae_results)
  mae_results_mean
  results <- data.frame(rbind(mse_results_mean, rmse_results_mean, mae_results_mean))
  row.names(results) <- c("MSE", "RMSE", "MAE")

  results

  return(results)
}

run(X, y, 30)
run(P[,1:3],y, 30)








