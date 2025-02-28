library(ISLR2)
library(boot)

# set the seed
logi_model <- glm(default ~ income + balance, data = Default, family <- binomial)

summary(logi_model)

# Coefficients:
#               Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -1.154e+01  4.348e-01 -26.545  < 2e-16 ***
# income       2.081e-05  4.985e-06   4.174 2.99e-05 ***
# balance      5.647e-03  2.274e-04  24.836  < 2e-16 ***

boot.fn <- function(data, index) {
  d <- data[index, ]
  logi_model <- glm(default ~ income + balance, data = d, family = binomial)
  return(summary(logi_model)$coef[2:3, 2])
}

boot_results <- boot(Default, boot.fn, 1000, parallel = "multicore", ncpus = 16)

boot_results
# Bootstrap Statistics :
#         original       bias     std. error
# t1* 4.985167e-06 1.503909e-08 1.409532e-07
# t2* 2.273731e-04 1.204649e-06 1.135513e-05

# the income std error from the bootstrap is higher than the original model 
# where the balance std error is lower, such change could suggest an underestimation of income std error 
# and an overestimation of balance std error

