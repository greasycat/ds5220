# Create grid of points
x1 <- seq(-4, 2, length.out = 100)
x2 <- seq(-1, 5, length.out = 100)
grid <- expand.grid(x1 = x1, x2 = x2)

# Compute function values
z <- with(grid, (x1 + 1)^2 + (2 - x2)^2 - 4)

# Convert to matrix for contour plot
z_matrix <- matrix(z, nrow = length(x1), ncol = length(x2))


# Create plot
plot(0, 0, type = "n", xlim = c(-4, 4), ylim = c(-1, 9),
     xlab = expression(x[1]), ylab = expression(x[2]))
contour(x1, x2, z_matrix, levels = 0, add = TRUE, drawlabels = FALSE, lwd = 2)

text(2,3, expression((x[1] + 1)^2 + (2 - x[2])^2 == 4))
text(2, 2, "Any points on the boundary of the circle satisfies above", cex = 0.8)


text(-1,6, expression((x[1] + 1)^2 + (2 - x[2])^2 > 4))
text(-1, 5, "Any points outside the circle satisfies above", cex = 0.8)
text(-1, 2, expression((x[1] + 1)^2 + (2 - x[2])^2 < 4))
text(-1, 1, "Any points inside the circle satisfies above", cex = 0.8)

points_to_check = rbind(c(0,0), c(-1,1), c(2,2), c(3,8))

for (i in 1:nrow(points_to_check)) {
  x1_pt <- points_to_check[i, 1]
  x2_pt <- points_to_check[i, 2]
  val <- round((x1_pt + 1)^2 + (2 - x2_pt)^2, 2)
  
  if(val < 4) {
    col = "red"
    label = paste0("(", x1_pt, ",", x2_pt,") < 4")
  } else {
    col = "blue"
    label = paste0("(", x1_pt, ",", x2_pt,") > 4")
  }
  
  points(x1_pt, x2_pt, pch = 16, col = col)
  text(x1_pt, x2_pt, label, pos = sample(1:4, 1))
}

points(-1, 2, pch = 16, col = "red")
text(-1, 2, "(-1,2)", pos = 4)

# Sample 5 points inside the circle
set.seed(123)  # For reproducibility
inside_points <- matrix(0, nrow = 5, ncol = 2)
count <- 0
while(count < 5) {
  x1_pt <- runif(1, -3, 1)
  x2_pt <- runif(1, 0, 4)
  if(((x1_pt + 1)^2 + (2 - x2_pt)^2) < 4) {
    count <- count + 1
    inside_points[count,] <- c(x1_pt, x2_pt)
  }
}

# Sample 5 points outside the circle
outside_points <- matrix(0, nrow = 5, ncol = 2)
count <- 0
while(count < 5) {
  x1_pt <- runif(1, -4, 2)
  x2_pt <- runif(1, -1, 5)
  if(((x1_pt + 1)^2 + (2 - x2_pt)^2) > 4) {
    count <- count + 1
    outside_points[count,] <- c(x1_pt, x2_pt)
  }
}

# Add inside points and text
points(inside_points, pch = 16, col = "blue")
for(i in 1:5) {
  val <- round((inside_points[i,1] + 1)^2 + (2 - inside_points[i,2])^2, 2)
  text(inside_points[i,1], inside_points[i,2], 
       paste0(val, " < 4"), pos = sample(1:4, 1))
}

# Add outside points and text
points(outside_points, pch = 16, col = "orange")
for(i in 1:5) {
  val <- round((outside_points[i,1] + 1)^2 + (2 - outside_points[i,2])^2, 2)
  text(outside_points[i,1], outside_points[i,2], 
       paste0(val, " > 4"), pos = sample(1:4, 1))
}