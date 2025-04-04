library(ISLR2)

data(Wage)
min(Wage$age)
max(Wage$age)

fit_step_function <- function(x, y, k) {
  breaks <- seq(min(x), max(x), length.out = k + 1)
  
  intervals <- cut(x, breaks = breaks, include.lowest = TRUE)
  
  step_heights <- tapply(y, intervals, mean)
  
  predict_step <- function(new_x) {
    new_intervals <- cut(new_x, breaks = breaks, include.lowest = TRUE)
    return(step_heights[as.character(new_intervals)])
  }
  
  return(list(
    breaks = breaks,
    heights = step_heights,
    predict = predict_step
  ))
}

cv.step <- function(k = 10, Wage, cuts) {
  # get fixed indices for folds and shuffle
  indices <- c(1:nrow(Wage))
  indices <- sample(indices)

  # split into k folds
  folds <- split(indices, rep(1:k, length.out = length(indices)))

  avg_mse <- c()
  for (cut in cuts) {
    mse <- c()
    for (fold in folds) {
      fit <- fit_step_function(Wage$age[-fold], Wage$wage[-fold], cut)
      pred <- fit$predict(Wage[fold, ]$age)
      mse <- c(mse, mean((pred - Wage[fold, ]$wage)^2))
    }
    avg_mse <- c(avg_mse, mean(mse))
  }

  # find the best index
  best_index <- which.min(avg_mse)
  return(list(best_cuts = cuts[best_index], avg_mse = avg_mse, cuts = cuts))
}

cv_results <- cv.step(k = 10, Wage, cuts = 2:12)
cv_results$best_cuts
# best degree is 9

plot(cv_results$avg_mse ~ cv_results$cuts, type = "l", xlab = "Cuts", ylab = "Average MSE", main = "10-Fold Cross-Validation MSE for Different Cuts")

# best model
best_model <- fit_step_function(Wage$age, Wage$wage, cv_results$best_cuts)

pred <- best_model$predict(seq(0, 100, 1))

# xlim from 0 to 100
# ylim from 0 to 300
plot(pred ~ seq(0, 100, 1), xlab = "Age", ylab = "Predicted Wage", main = "Predicted Wage vs Age", type = "l", col = "red", xlim = c(0, 100), ylim = c(0, 300))
points(Wage$age, Wage$wage)


models <- lapply(1:12, function(deg) lm(wage ~ poly(age, degree = deg), data = Wage))
# anova all models
do.call(anova, models)

