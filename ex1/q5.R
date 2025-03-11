# Newton's method
source("ex1/q1.R")
tol = 1e-8
X
newton_method <- function(X, y, max_iter = 1, tol = 1e-8) {
  n <- nrow(X)
  p <- ncol(X)
  
  X <- cbind(1, X)
  
  beta <- matrix(rep(0, p + 1))
  
  for (iter in 1:max_iter) {
    Xbeta <- X %*% beta
    exp_Xbeta <- exp(Xbeta)
    grad <- t(X) %*% y - t(X) %*% exp_Xbeta
    print(grad)

    W <- diag(as.vector(exp_Xbeta))
    hess <- - t(X) %*% W %*% X
    print("Hess")
    print(hess)
    print("Grad")
    print(grad)

    delta <- solve(hess, grad)
    print(delta)
    
    beta_new <- beta - delta


    if (max(abs(delta)) < tol) {
      break
    }
    
    
    beta <- beta_new
  }
  
  return(list(beta = beta, iterations = iter, converged = iter < max_iter))
}
newton_method(X,y)


newton_poisson <- function(X, y, max_iter = 100, tol = 1e-8) {
  n <- nrow(X)
  p <- ncol(X)
  
  # Initialize beta
  beta <- rep(0, p)
  
  for (iter in 1:max_iter) {
    # Calculate linear predictor
    eta <- X %*% beta
    
    # Calculate predicted means (mu = exp(eta) for Poisson)
    mu <- exp(eta)
    
    # Gradient/score: X'(y - mu)
    score <- t(X) %*% (y - mu)
    
    # Hessian/information matrix: -X'WX where W = diag(mu)
    W <- diag(as.vector(mu))
    hessian <- -t(X) %*% W %*% X
    
    # Newton update
    delta <- solve(hessian , score)
    beta_new <- beta - delta
    
    # Check convergence
    if (max(abs(delta)) < tol) {
      break
    }
    
    beta <- beta_new
  }
  
  # Calculate final log-likelihood
  eta <- X %*% beta
  mu <- exp(eta)
  loglik <- sum(y * log(mu) - mu - lgamma(y + 1))
  
  # Standard errors from Fisher information
  W <- diag(as.vector(mu))
  fisher_info <- t(X) %*% W %*% X
  se <- sqrt(diag(solve(fisher_info)))
  
  return(list(
    beta = beta,
    iterations = iter,
    converged = iter < max_iter,
    loglik = loglik,
    se = se
  ))
}

X_w <- cbind(1, X)
newton_poisson(as.matrix(X_w), y)
