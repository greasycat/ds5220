converged <- function(old, new, eps = 1e-6) {
  all(abs(old - new) < eps)
}
X_w <- cbind(1, X)
beta <- rep(0, ncol(X_w))
iter <- 0
repeat {
  old <- beta
  iter <- iter + 1
  eta <- X_w %*% beta
  mu <- exp(eta)
  W <- diag(as.vector(mu))
  Info <- crossprod(X_w, W) %*% X_w
  beta <- old + solve(Info) %*% crossprod(X_w, y - mu)
  if (converged(old, beta) | iter > 50) break
}

beta
