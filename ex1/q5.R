# Newton's method
source("ex1/q1.R")
newton_method <- function(X, y, max_iter = 100, tol = 1e-8) {
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
    grad <- t(X) %*% y - t(X) %*% mu

    W <- diag(as.vector(mu))
    hess <- - t(X) %*% W %*% X
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
newton_model <- newton_method(X,y)

newton_model$beta

summary_newton <- function(model) {
  vcov <- solve(-model$hess)
  se <- sqrt(diag(vcov))
  z <- model$beta / se
  p <- 2 * pnorm(-abs(z))

  null_dev <- 2 * sum(model$y * log(model$y / mean(model$y))) - 
  2 * sum(model$y - mean(model$y))
resid_dev <- 2 * sum(model$y * log(model$y / model$mu)) - 
  2 * sum(model$y - model$mu)

  log_likelihood <- sum(model$y * log(model$mu)) - 
    sum(model$mu) - 
    sum(lgamma(model$y + 1))

  aic <- 2 * length(model$beta) - 2 * log_likelihood

  coef_table <- data.frame("Estimate" = model$beta, "Std. Error" = se,"z value" = z, 'Pr(>|z|)' = p)
    # Format output
  cat("\nCall: Poisson Newton-Raphson Regression\n\n")
  cat("Coefficients:\n")
  print(coef_table)
  cat("\n")
  cat("Null deviance:   ", null_dev, " on ", model$n - 1, " degrees of freedom\n")
  cat("Residual deviance:", resid_dev, " on ", model$n - model$p, " degrees of freedom\n")
  cat("AIC:", aic, "\n")
  cat("Number of iterations:", model$iter, "\n")
  cat("Converged:", model$converged, "\n")
}

summary_newton(newton_model)


