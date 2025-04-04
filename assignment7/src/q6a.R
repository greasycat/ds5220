library(ISLR2)

data(Wage)
min(Wage$age)
max(Wage$age)

cv.poly <- function(k = 10, Wage, degs) {
  # get fixed indices for folds and shuffle
  indices <- c(1:nrow(Wage))
  indices <- sample(indices)

  # split into k folds
  folds <- split(indices, rep(1:k, length.out = length(indices)))

  avg_mse <- c()
  for (deg in degs) {
    mse <- c()
    for (fold in folds) {
      fit <- lm(wage ~ poly(age, degree = deg), data = Wage[-fold, ])
      pred <- predict(fit, Wage[fold, ])
      mse <- c(mse, mean((pred - Wage[fold, ]$wage)^2))
    }
    avg_mse <- c(avg_mse, mean(mse))
  }

  # find the best index
  best_index <- which.min(avg_mse)
  return(list(best_deg = degs[best_index], avg_mse = avg_mse, degs = degs))
}

cv_results <- cv.poly(k = 10, Wage, degs = 2:12)
cv_results$best_deg
# best degree is 9

plot(cv_results$avg_mse ~ cv_results$degs, type = "l", xlab = "Degree", ylab = "Average MSE", main = "10-Fold Cross-Validation MSE for Different Degrees")

# best model
best_model <- lm(wage ~ poly(age, degree = 9), data = Wage)
summary(best_model)

pred <- predict(best_model, data.frame(age = seq(0, 100, 1)))

# xlim from 0 to 100
# ylim from 0 to 300
plot(pred ~ seq(0, 100, 1), xlab = "Age", ylab = "Predicted Wage", main = "Predicted Wage vs Age", type = "l", col = "red", xlim = c(0, 100), ylim = c(0, 300))
points(Wage$age, Wage$wage)




models <- lapply(1:12, function(deg) lm(wage ~ poly(age, degree = deg), data = Wage))
# anova all models
do.call(anova, models)

