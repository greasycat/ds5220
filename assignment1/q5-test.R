# ------------------------------------------------------------
# 1. Define f(alpha) and f'(alpha)
# ------------------------------------------------------------

# f(alpha) = -n * digamma(alpha) 
#            - n * log(mean(x)) 
#            + n * alpha 
#            + sum(log(x))

f <- function(alpha, x) {
  n    <- length(x)
  barx <- mean(x)
  
  val <- -n * digamma(alpha) -
    n * log(barx) +
    n * alpha +
    sum(log(x))
  
  return(val)
}

# f'(alpha) = derivative of the above wrt alpha
#           = -n * trigamma(alpha) + n

fprime <- function(alpha, x) {
  n <- length(x)
  
  val <- -n * trigamma(alpha) + n
  
  return(val)
}

# ------------------------------------------------------------
# 2. Newton's Method
# ------------------------------------------------------------
# This function implements the iterative procedure:
#
#   alpha_{k+1} = alpha_k - f(alpha_k) / f'(alpha_k)
#
# until convergence or max iterations are reached.

newton_alpha <- function(x, alpha_init, tol = 1e-8, max_iter = 100) {
  alpha <- alpha_init
  
  for (iter in 1:max_iter) {
    current_f      <- f(alpha, x)
    current_fprime <- fprime(alpha, x)
    
    # Update step
    alpha_new <- alpha - current_f / current_fprime
    
    # Check for convergence
    if (abs(alpha_new - alpha) < tol) {
      message(sprintf("Converged in %d iterations.", iter))
      return(alpha_new)
    }
    
    alpha <- alpha_new
  }
  
  warning("Newton method did not converge within max_iter iterations.")
  return(alpha)
}

# ------------------------------------------------------------
# 3. Example Usage
# ------------------------------------------------------------

# Example data
set.seed(123)
x_data <- rgamma(n = 50, shape = 2, rate = 1)  # some gamma-distributed data

# Initial guess for alpha
alpha_guess <- 1.0  

# Solve for alpha using Newton's method
alpha_est <- newton_alpha(x_data, alpha_guess)
alpha_est
