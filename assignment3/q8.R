library(ISLR2)
model <- lm(mpg ~ horsepower, data = Auto)
summary(model)

# set plot ratio
plot(Auto$horsepower, Auto$mpg, asp = 5)
abline(model)

plot(model, which=1)

