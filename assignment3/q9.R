library(ISLR2)
# exclude the name column
Auto <- Auto[, -9]
str(Auto)

# a
pairs(Auto)

# b
cor(Auto)

# c
model <- lm(mpg ~ ., data = Auto)
summary(model)
par(mfrow = c(1, 2))
plot(model, which=1)
plot(model, which=5)

model_2 <- lm(mpg ~ . + cylinders:horsepower, data = Auto)
summary(model_2)

model_2 <- lm(mpg ~ . + acceleration:origin, data = Auto)
summary(model_2)


model_3 <- lm (mpg ~ cylinders+I(displacement)^2 + log(weight)+ weight + year + acceleration + origin + horsepower, data = Auto)
summary(model_3)
