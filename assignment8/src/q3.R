X <- rbind(
c(3,4),
c(2,2),    
c(4,4),
c(1,4),
c(2,1),
c(4,3),
c(4,1)
)

y <- c(1,1,1,1,0,0,0)

# plot the data
plot(X, col = ifelse(y == 1, "red", "blue"), pch = 19, cex = 2,
     xlab = "x1", ylab = "x2", main = "Data Points", xlim = c(0, 5), ylim = c(0, 5))

p1 <- c(2, 1.5)
p2 <- c(4, 3.5)
slope <- (p2[2] - p1[2]) / (p2[1] - p1[1])
intercept <- p1[2] - slope * p1[1]
cat("Intercept:", intercept, "\n")
cat("Slope:", slope, "\n")

abline(a = intercept, b = slope, col = "green", lwd = 2)
abline(a = intercept+0.2, b = slope, col = "orange", lwd = 2)

{
  xlim <- par("usr")[1:2]  # Get current x limits of plot
  x <- seq(xlim[1], xlim[2], length.out = 100)

  upper <- intercept + 0.5 + slope * x
  lower <- intercept - 0.5 + slope * x

  polygon(c(x, rev(x)), c(lower, rev(upper)), 
          col = rgb(0.5, 0.5, 0.5, 0.3), 
          border = NA)
}

X_new <- rbind(X, c(3,3))
y_new <- c(y, 0)


plot(X_new, col = ifelse(y_new == 1, "red", "blue"), pch = 19, cex = 2,
     xlab = "x1", ylab = "x2", main = "Data Points", xlim = c(0, 5), ylim = c(0, 5))
