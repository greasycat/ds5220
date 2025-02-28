f1 <- function(beta) {
  return ((10-beta)^2 + 2*beta^2)
}

par(mfrow = c(1, 1))
# plot the function
curve(f1, from = -5, to = 10, xlab = "beta", ylab = "f(beta)", main = "f(beta) vs beta")

beta_sol <- 10/(1+2)

# plot the solution
abline(v = beta_sol, col = "red", lty = 2)

# legend
legend("topright", legend = c("f(beta)", "solution"), col = c("black", "red"), lty = c(1, 2))

# save the plot
dev.copy(png, "assignment6/ch6q6-0.png")
dev.off()

f2 <- function(y, lambda, beta) {
  return ((y - beta)^2 + lambda*abs(beta))
}

lambda <- 2
y <- c(2, 0, -2)

beta_sols <- c(1, 0, -1)

# plot the functions in 3 subplots
par(mfrow = c(3, 1))
for (i in 1:3) {
curve(f2(y[i], lambda, x), from = -5, to = 5, xlab = "beta", ylab = "f(beta)", main = paste("f(beta) vs beta for y =", y[i], "and lambda =", lambda))
  
  # plot the solution
  abline(v = beta_sols[i], col = "red", lty = 2)
  
  # legend
  legend("topright", legend = c("f(beta)", "solution"), col = c("black", "red"), lty = c(1, 2))
}

# save the plot
dev.copy(png, "assignment6/ch6q6-1.png")
dev.off()






