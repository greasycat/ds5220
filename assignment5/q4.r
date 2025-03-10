library(alr4)
log_fert = log(UN11$fertility)

xbar = mean(log_fert)
s = sd(log_fert)
n = length(log_fert)
se = s / sqrt(n)
alpha <- 0.05
t_critical <- qt(1 - alpha/2, df = n - 1) # t-critical value

lower_log <- xbar - t_critical * se
upper_log <- xbar + t_critical * se

ci <- c(lower_log, upper_log)
ci
median_ci <- exp(ci)
median_ci
# > median_ci
# [1] 2.339729 2.649665

bootstrap_samples <- function(data, n) {
  boot_medians <- replicate(n, median(sample(data, size = length(data), replace = TRUE)))
  
  lower <- quantile(boot_medians, alpha/2)
  upper <- quantile(boot_medians, 1 - alpha/2)
  
  return(c(lower, upper))
}


bootstrap_ci <- bootstrap_samples(UN11$fertility, 1000)
bootstrap_ci
# > bootstrap_ci
#  2.5% 97.5%
# 2.148 2.422
