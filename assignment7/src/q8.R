library(ISLR2)
library(splines)

pairs(Auto)

# sort the data by acceleration
Auto <- Auto[order(Auto$acceleration), ]

plot(mpg ~ acceleration, data = Auto)

fit_lm <- lm(mpg ~ acceleration, data = Auto)

# fit a bs spline to the data
fit_bs <- lm(mpg ~ bs(acceleration, df = 4), data = Auto)

# fit a natural spline to the data
fit_ns <- lm(mpg ~ ns(acceleration, df = 4), data = Auto)

# fit a polynomial to the data
fit_poly <- lm(mpg ~ poly(acceleration, degree = 4), data = Auto)


# plot the data
par(mfrow = c(1, 1))
plot(mpg ~ acceleration, data = Auto)

# plot the fitted lines
lines(Auto$acceleration, predict(fit_bs), col = "red")
lines(Auto$acceleration, predict(fit_ns), col = "blue")
lines(Auto$acceleration, predict(fit_poly), col = "green")

# legend
legend("topright", legend = c("bs df = 4", "ns df = 4", "poly df = 4"), col = c("red", "blue", "green"), lty = 1)


# normality plot
par(mfrow = c(2, 1))
plot(fit_lm, which = 1)
plot(fit_lm, which = 2)











