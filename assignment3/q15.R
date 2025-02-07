library(ISLR2)

predictors = subset(Boston, select = -crim)
models = fits <- lapply(predictors, function(x) lm(Boston$crim ~ x))


# put p values in a dataframe
p_values = data.frame(p = sapply(models, function(x) summary(x)$coefficients[2, 4]))

print(p_values)

multiple_model = lm(crim ~ ., data = Boston)
summary(multiple_model)


uni_estimates = data.frame(estimates = sapply(models, function(x) summary(x)$coefficients[2, 1]))
print(uni_estimates)

multi_estimates = data.frame(estimates = summary(multiple_model)$coefficients[-1, 1])

multi_estimates

# plot (multi_estimates vs uni_estimates)
par(mfrow = c(1, 1))
plot(uni_estimates$estimates, multi_estimates$estimates)

cubic_models <- lapply(predictors, function(x) lm(Boston$crim ~ x + I(x^2) + I(x^3)))

for (name in names(cubic_models)) {
  cat(name, "\n")
  print(summary(cubic_models[[name]])$coefficients[,4])
    cat("\n")
}
