source("ex1/q5.R")
newton_method_l2 <- function(X, y, lambda=1, max_iter = 100, tol = 1e-8) {
  n <- nrow(X)
  p <- ncol(X)
  
  X <- cbind(1, X)
  
  beta <- matrix(rep(0, p + 1))
  beta[1,1] <- mean(y)

  mu <- NULL
  hess <- NULL

  count <- 0
  for (iter in 1:max_iter) {
    eta <- X %*% beta
    mu <- exp(eta)
    # 0.5 is used to match the regularization term in the glmnet
    grad <- t(X) %*% y - t(X) %*% mu - 0.5 * lambda * c(0, beta[2:length(beta)])

    W <- diag(as.vector(mu))
    hess <- - t(X) %*% W %*% X - 0.5 * lambda * diag(c(0, rep(1, p)))
    delta <- solve(hess, grad)
    
    beta_new <- beta - delta

    count <- count + 1
    if (max(abs(delta)) < tol) {
      break
    }
    
    
    beta <- beta_new
  }
  
  return(list(beta = beta,
  hess = hess,
  mu = mu, n = n, p = p, X = X, y = y
  , iter = count, converged = max(abs(delta)) < tol))
}


newton_model_l2 <- newton_method_l2(X,y, lambda=10)
summary_newton(newton_model_l2)

library(glmnet)
glmnet_model <- glmnet(X, y, family = "poisson", alpha=0, lambda=10)
coef(glmnet_model)
