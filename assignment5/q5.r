library(alr4)
str(fuel2001)

# Suggested by Weisberg, 2014
fuel2001 <- transform(fuel2001,
     Dlic=1000 * Drivers/Pop,
     Fuel=1000 * FuelC/Pop,
     Income=Income/1000)
fuel2001$logMiles <- log(fuel2001$Miles)

subset <- c("Fuel", "logMiles", "Dlic", "Income", "Tax")
predictors <- subset(subset, subset != "Fuel")

alpha = 0.05


bootstrap_estimates <- function(data, n) {
  boot_estimates <- replicate(n, {
    boot_data <- data[sample(nrow(data), replace = TRUE), ]
    lm_fit <- lm(Fuel ~ ., data = boot_data[, subset])
    coef(lm_fit)
  })
  
  lower <- apply(boot_estimates, 1, function(x) quantile(x, alpha/2))
  upper <- apply(boot_estimates, 1, function(x) quantile(x, 1 - alpha/2))
  
  return(list(boot_estimates, cbind(lower, upper)))
}


result <- bootstrap_estimates(fuel2001, 1000)
boot_estimates <- result[[1]]
bootstrap_ci <- result[[2]]
bootstrap_ci

# > bootstrap_ci
#                    lower       upper
# (Intercept) -129.9221362 813.4622044
# logMiles      -8.8573949  45.9460361
# Dlic           0.1217037   0.7519390
# Income        -9.5889428  -2.6001191
# Tax          -10.3790729   0.6019043

ols_fit <- lm(Fuel ~ ., data = fuel2001[, subset])
ols_estimates <- coef(ols_fit)
ols_estimates
# > ols_estimates
#   (Intercept)      logMiles          Dlic        Income           Tax
#   154.1928446    26.7551756     0.4718712 -6135.3309704    -4.2279832
ols_ci <- confint(ols_fit)
ols_ci
> ols_ci
#                    2.5 %      97.5 %
# (Intercept) -238.1329083 546.5185975
# logMiles       7.9600165  45.5503346
# Dlic           0.2131871   0.7305553
# Income       -10.5508863  -1.7197756
# Tax           -8.3144050  -0.1415614

# histogram of bootstrap estimates

par(mfrow = c(length(predictors), 1))

for (i in 1:length(predictors)) {
  hist(boot_estimates[i+1, ],
      main = paste("Histogram of Bootstrap Estimates for", predictors[i]), xlab = "Estimate")
}
