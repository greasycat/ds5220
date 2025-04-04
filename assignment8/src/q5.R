library(e1071) # for SVM
x1 <- runif (500) - 0.5
x2 <- runif (500) - 0.5
y <- 1 * (x1^2 - x2^2 > 0)

data <- data.frame(x1 = x1, x2 = x2, y = as.factor(y))

png(filename = "assignment8/figs/q5-1.png", width = 800, height = 600, res = 100)
plot(x1, x2, col = ifelse(y == 0, "red", "blue"), pch = 19, cex = 0.5,
     xlab = expression(X[1]), ylab = expression(X[2]), main = "Data with two classes")
dev.off()

logistic_model <- glm(y ~ x1 + x2, data = data, family = binomial)
pred_1 <- predict(logistic_model, type = "response")
pred_1 <- ifelse(pred_1 > 0.5, 1, 0)

png(filename = "assignment8/figs/q5-2.png", width = 800, height = 600, res = 100)
plot(x1, x2, col = ifelse(pred_1 == 0, "red", "blue"), pch = 19, cex = 0.5,
     xlab = expression(X[1]), ylab = expression(X[2]), main = "Simple Logistic Regression Prediction")
# save the plot
dev.off()



logistic_model_2 <- glm(y ~ x1 + x2 + I(x1*x2) + I(x1)^2, data = data, family = binomial)
pred_2 <- predict(logistic_model_2, type = "response")
pred_2 <- ifelse(pred_1 > 0.5, 1, 0)
png(filename = "assignment8/figs/q5-3.png", width = 800, height = 600, res = 100)
plot(x1, x2, col = ifelse(pred_2 == 0, "red", "blue"), pch = 19, cex = 0.5,
     xlab = expressiopredictions <- predict(svm_model, data)n(X[1]), ylab = expression(X[2]), main = "Non-linear function Logistic Regression Prediction")
# save the plot
dev.off()

# support vector classifier
svc_model <- svm(y ~ ., 
                data = data,
                kernel = "linear",
                cost = 10)
pred_svc <- predict(svc_model, data)
png(filename = "assignment8/figs/q5-4.png", width = 800, height = 600, res = 100)
plot(x1, x2, col = ifelse(pred_svc == 0, "red", "blue"), pch = 19, cex = 0.5,
     xlab = expression(X[1]), ylab = expression(X[2]), main = "SVC Prediction")
# save the plot
dev.off()



svm_model <- svm(y ~ ., 
                data = data,
                kernel = "radial",
                gamma = 0.5,
                cost = 10)

pred_svm <- predict(svm_model, data)
png(filename = "assignment8/figs/q5-5.png", width = 800, height = 600, res = 100)
plot(x1, x2, col = ifelse(pred_svm == 0, "red", "blue"), pch = 19, cex = 0.5,
     xlab = expression(X[1]), ylab = expression(X[2]), main = "SVM Prediction")
# save the plot
dev.off()
# Save the models for later use
