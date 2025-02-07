library(ISLR2)
cols <- colnames(subset(Auto, select = -c(name)))

median <- median(Auto$mpg)
Auto$mpg01 <- ifelse(Auto$mpg > median, TRUE, FALSE)
Auto$cylinders <- as.factor(Auto$cylinders)

str(Auto)

ncols <- length(cols)
w <- ceiling(sqrt(ncols))
par(mfrow = c(w, w))
for (col in cols) {
  boxplot(Auto[[col]] ~ Auto$mpg01, ylab = col, xlab = "mpg01")
  title(sprintf("Boxplot of %s", col))
}

rand_idx <- sample(1:nrow(Auto), nrow(Auto) * 0.8)
train <- Auto[rand_idx, ]
test <- Auto[-rand_idx, ]

# logistic regression

glm.fit <- glm(mpg01 ~ cylinders + displacement + horsepower + weight, , data = train, family = binomial)

# compute test error
glm.probs <- predict(glm.fit, test, type = "response")
glm.pred <- ifelse(glm.probs > 0.5, TRUE, FALSE)
error_rate <- mean(glm.pred != test$mpg01)
error_rate
