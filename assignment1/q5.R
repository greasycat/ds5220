generate_n_gamma = function(n, alpha=1, beta=1) {
  delta = 1/beta
  
  gammas = c() 
  for (i in 1:n) {
    us = sample.int(.Machine$integer.max, size = alpha, replace=TRUE)
    us = us / .Machine$integer.max
    exp = -log(us) / delta
    gammas = c(gammas,sum(exp))
  }
  return (gammas)
}

d <- function(f, x, h = 1e-7) {
  (f(x + h) - f(x - h)) / (2*h)
}

newton_numderiv <- function(f, x0, tol = 1e-9, maxiter = 100) {
  x <- x0
  for (i in seq_len(maxiter)) {
    fx <- f(x)
    dfx <- d(f, x)
    
    if (abs(dfx) < 1e-15) {
      stop("Numerical derivative too small. Unable to proceed")
    }
    
    x_new <- x - fx / dfx
    
    if (abs(x_new - x) < tol) {
      return(x_new)
    }
    x <- x_new
  }
  stop("Max iterations reached without convergence")
}

mle_gamma <- function(xs){
  n = length(xs)
  x_bar = mean(xs)
  log_x_bar = mean(log(xs))
  f = function(alpha) log(alpha) - digamma(alpha) - (log(x_bar) - log_x_bar)
  a = newton_numderiv(f, 1)
  return (c(a, x_bar/a))
}

xs = generate_n_gamma(1000, 5, 10)

mle_gamma(xs)

evaulate_mle_abs_diff <- function(true_alpha=1, true_beta=1) {
  n_arr <- seq(10,1000,5)
  abs_diff_alpha <- c()
  abs_diff_beta <- c()
  for (n in n_arr) {
    x <- generate_n_gamma(n, true_alpha, true_beta)
    hats <- mle_gamma(x)
    abs_diff_alpha <- c(abs_diff_alpha, abs(hats[1]-true_alpha))
    abs_diff_beta <- c(abs_diff_beta,abs(hats[2]-true_beta))
  }
  
  
  par(mfrow=c(2,1))
  plot(n_arr, abs_diff_alpha, main = sprintf("MLE Alpha - True Alpha Diff (alpha=%s,beta=%s)", true_alpha, true_beta)) 
  plot(n_arr, abs_diff_beta, main = sprintf("MLE Beta - True Beta Diff (alpha=%s,beta=%s)", true_alpha, true_beta)) 
}

evaulate_mle_abs_diff(1,1)
evaulate_mle_abs_diff(1,20)
evaulate_mle_abs_diff(20,1)
evaulate_mle_abs_diff(20,20)

