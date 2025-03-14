source("ex1/q1.R")

boot.fn <- function(data, index) {
  d <- data[index, ]
  model <- glm(y ~ ., family = poisson, data = d)

  return (coef(model))
}

bootstrap <- function(data, boot.fn, R = 1000) {
  initial_stat <- boot.fn(data, 1:nrow(data))
  
  stat_length <- length(initial_stat)

  boot_results <- matrix(NA, nrow = R, ncol = stat_length)
  
  # Perform bootstrap
  for(i in 1:R) {
    indices <- sample(nrow(data), replace = TRUE)
    
    boot_stat <- boot.fn(data, indices)
    
    boot_results[i, ] <- boot_stat
  }
  
  boot_means <- colMeans(boot_results, na.rm = TRUE)
  boot_se <- apply(boot_results, 2, sd, na.rm = TRUE)
  
  ci_lower <- apply(boot_results, 2, quantile, probs = 0.025, na.rm = TRUE)
  ci_upper <- apply(boot_results, 2, quantile, probs = 0.975, na.rm = TRUE)

  ci_width <- ci_upper - ci_lower
  
  bias <- boot_means - initial_stat
  
  # Prepare results
  result <- data.frame(
    bias = bias,                      # Bootstrap bias estimates
    ci_lower=ci_lower,
    ci_upper= ci_upper,
    ci_width = ci_width
    ) 
  
  names = colnames(data)[2:ncol(data)]
  names = c("Intercept", names)
  rownames(result) <- names

  return(list(
    result = result,
    boot_results = boot_results
  ))
}

bootstrap_results <- bootstrap(yX, boot.fn, R = 1000)$result

options(digits=4)

ci_width_1 = data.frame(ci_with_nb = ci[,2] - ci[,1])

bootstrap_results <- cbind(bootstrap_results, ci_width_1)

print(bootstrap_results)
