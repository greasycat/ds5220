library(ISLR)

str(Boston)
# sort by dis
Boston <- Boston[order(Boston$dis), ]

# fit polynomial regression
fit_poly <- lm(nox ~ poly(dis, degree = 3), data = Boston)
summary(fit_poly)
par(mfrow = c(1, 1))
plot(Boston$dis, Boston$nox)
lines(Boston$dis, predict(fit_poly, Boston), col = "red")
title("Polynomial fit with 3 degrees of freedom")


# fit 1 to 10 degree polynomials

color_map <- rainbow(10)
legend_text <- vector(mode = "character", length = 10)

plot(Boston$dis, Boston$nox)
for (deg in 1:10) {
  fit <- lm(nox ~ poly(dis, degree = deg), data = Boston)
  ssr <- sum(summary(fit)$residuals^2)
  color <- color_map[deg]
  lines(Boston$dis, predict(fit, Boston), col = color)
  legend_text[deg] <- paste("Degree", deg, "SSR:", ssr)
}
legend_text 
legend("topright", legend = legend_text, col = color_map, lty = 1)
title("Polynomial fits with degrees 1 to 10")


cv.poly <- function(k = 10, df, degs) {
  # get fixed indices for folds and shuffle
  indices <- c(1:nrow(df))
  indices <- sample(indices)

  # split into k folds
  folds <- split(indices, rep(1:k, length.out = length(indices)))

  avg_mse <- c()
  for (deg in degs) {
    mse <- c()
    for (fold in folds) {
      fit <- lm(nox ~ poly(dis, degree = deg), data = df[-fold, ])
      pred <- predict(fit, df[fold, ])
      mse <- c(mse, mean((pred - df[fold, ]$nox)^2))
    }
    avg_mse <- c(avg_mse, mean(mse))
  }

  # find the best index
  best_index <- which.min(avg_mse)
  return(list(best_deg = degs[best_index], avg_mse = avg_mse, degs = degs))
}

cv_results <- cv.poly(k = 10, df = Boston, degs = 1:13)
cv_results$best_deg

fit.bs <- lm(nox ~ bs(dis, df = 4, knots = c(3)), data = Boston)
plot(Boston$dis, Boston$nox)
lines(Boston$dis, predict(fit.bs, Boston), col = "red")
title("B-spline fit with 4 degrees of freedom and knots at 3")

# Knot is chosen by observing a change of curvature in the plot of nox vs dis

range_of_df <- c(3:6)
par(mfrow = c(2, 2))
for (df in range_of_df) {
  fit <- lm(nox ~ bs(dis, df = df), data = Boston)
  ssr <- sum(summary(fit)$residuals^2)
  plot(Boston$dis, Boston$nox)
  lines(Boston$dis, predict(fit, Boston), col = "red")
  title(paste("B-spline fit with", df, "degrees of freedom and knots at 3", "SSR:", ssr))
}


cv.bs <- function(k = 10, df, degs) {
  # get fixed indices for folds and shuffle
  indices <- c(1:nrow(df))
  indices <- sample(indices)

  # split into k folds
  folds <- split(indices, rep(1:k, length.out = length(indices)))

  avg_mse <- c()
  for (deg in degs) {
    mse <- c()
    for (fold in folds) {
      fit <- lm(nox ~ bs(dis, df = deg), data = df[-fold, ])
      pred <- predict(fit, df[fold, ])
      mse <- c(mse, mean((pred - df[fold, ]$nox)^2))
    }
    avg_mse <- c(avg_mse, mean(mse))
  }

  # find the best index
  best_index <- which.min(avg_mse)
  return(list(best_deg = degs[best_index], avg_mse = avg_mse, degs = degs))
}

cv_results_bs <- cv.bs(k = 10, df = Boston, degs = 4:10)
cv_results_bs$best_deg
















