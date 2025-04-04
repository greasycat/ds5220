library(png)

f <- function(x) {
  sin(x) + 0.1 * x
}

f_prime <- function(x) {
  return(cos(x) + 0.1)
}

png("assignment9/figs/q6a.png", width=800, height=600)
x_vals <- seq(-6, 6, length.out=100)
y_vals <- f(x_vals)
plot(x_vals, y_vals, type='l', col='blue', lwd=2,
     main='Plot of f(x) = sin(x) + 0.1 * x',
     xlab='x', ylab='f(x)')
dev.off()

gradient_descent <- function(f, f_prime, x0, learning_rate=0.01, tolerance=1e-6, max_iter=1000) {
  hist <- c() # To store the history of x values
  x <- x0
  for (i in 1:max_iter) {
    x_new <- x - learning_rate * f_prime(x)
    hist <- c(hist, x_new) 
    
    if (abs(x_new - x) < tolerance) {
      cat("Converged after", i, "iterations.\n")
      return(list(
        x = x, 
        hist = hist
      ))
    }
    
    x <- x_new
  }
  
  cat("Max iterations reached without convergence.\n")
  return(list(
    x = x, 
    hist = hist
  ))
}

sample_points <- function(f, x, percentage = 0.2) {
  # evenly sample percentage of points in x
  n <- length(x)
  if (n <= 1) {
    return(x)
  }

  # Calculate the number of points to sample
  num_points <- max(1, round(n * percentage))

  # Sample indices
  indices <- seq(1, n, length.out = num_points)

  # Return the sampled points
  sampled_x <- x[indices]
  return(data.frame(
    x = sampled_x,
    y = f(sampled_x)
  ))
}

d1 <- gradient_descent(
  f = f, 
  f_prime = f_prime, 
  x0 = 2.3, # Starting point
  learning_rate = 0.1, 
  tolerance = 1e-6, 
  max_iter = 1000
)

png("assignment9/figs/q6c.png", width=800, height=600)
# Plot the history of x values
plot(x_vals, y_vals, type='l', col='blue', lwd=2,
     main='Plot of f(x) = sin(x) + 0.1 * x',
     xlab='x', ylab='f(x)')
points(sample_points(f, d1$hist, 1), col='red', lwd=2,
     main='Convergence of Gradient Descent',
     xlab='Iteration', ylab='x value')
abline(h=d1$x, col='blue', lty=2) 
text(x=0, y=d1$x-0.1, 
     labels=paste("Converged to x =", round(d1$x, 4)), pos=4, col='blue')
dev.off()



d2 <- gradient_descent(
  f = f, 
  f_prime = f_prime, 
  x0 = 1.4, # Starting point
  learning_rate = 0.1, 
  tolerance = 1e-6, 
  max_iter = 1000
)

png("assignment9/figs/q6d.png", width=800, height=600)
# Plot the history of x values scatter
plot(x_vals, y_vals, type='l', col='blue', lwd=2,
     main='Plot of f(x) = sin(x) + 0.1 * x',
     xlab='x', ylab='f(x)')
points(sample_points(f, d2$hist, 1), col='red', lwd=2,
     main='Convergence of Gradient Descent',
     xlab='Iteration', ylab='x value')
abline(h=d2$x, col='blue', lty=2) 
text(x=0, y=d2$x-0.1, 
     labels=paste("Converged to x =", round(d2$x, 4)), pos=4, col='blue')
dev.off()
