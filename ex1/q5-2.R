newton_method <- function(X, y, max_iter = 100, tol = 1e-8) {
  n <- nrow(X)
  p <- ncol(X)
  
  beta_0 <- 0
  beta <- rep(0, p)
  
  for (iter in 1:2) {

    exp_sum <- 0
    for (i in 1:n) {
      exp_sum <- exp_sum + exp(beta_0 + t(beta) %*% X[i, ])
    }

    grad1 <- -sum(y) + exp_sum

    yx_sum <- rep(0, p)
    for (i in 1:n) {
      yx_sum <- yx_sum + y[i] * X[i, ]
    }

    exp_sum_x <- rep(0, p)
    for (i in 1:n) {
      exp_sum_x <- exp_sum_x + exp(beta_0 + t(beta) %*% X[i, ]) * X[i, ]
    }

    grad2 <- -yx_sum + exp_sum_x

    

    hess1 <- 0
    for (i in 1:n) {
      hess1 <- hess1 + exp(beta_0 + t(beta) %*% X[i, ])
    }
    hess1 <- -hess1

    hess2 <- matrix(0, nrow = p, ncol = p)
    for (i in 1:n) {
      hess2 <- hess2 + drop(exp(beta_0 + t(beta) %*% X[i, ]))* ( X[i, ] %*% t(X[i, ]))
    }
    hess2 <- -hess2
    hess2

    grad = c(grad1, grad2)

    H<- rbind(
      cbind(matrix(c(hess1)),t(matrix(-exp_sum_x))),
      cbind(matrix(-exp_sum_x), hess2)
    )
    d <- solve(H, grad)

    beta_0 <- beta_0 - d[1]
    beta <- beta - as.vector(d[2:length(d)])
  }
