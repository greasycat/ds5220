library(ISLR2)
str(Boston)

Boston$y <- ifelse(Boston$crim > median(Boston$crim), TRUE, FALSE)
Boston <- subset(Boston, select = -c(crim))

rand_idx <- sample(1:nrow(Boston), nrow(Boston) * 0.8)
train <- Boston[rand_idx, ]
test <- Boston[-rand_idx, ]

glm.fit <- glm(y ~ ., data = train, family = binomial)

summary(glm.fit)
#               Estimate Std. Error z value Pr(>|z|)
# (Intercept) -39.579301   6.492978  -6.096 1.09e-09 ***
# zn           -0.065054   0.034724  -1.873  0.06101 .
# indus        -0.097390   0.050344  -1.935  0.05305 .  
# chas          0.591790   0.752860   0.786  0.43183
# nox          47.361449   7.972041   5.941 2.83e-09 ***
# rm           -0.556126   0.764264  -0.728  0.46682
# age           0.013887   0.013074   1.062  0.28816
# dis           0.638130   0.221236   2.884  0.00392 **
# rad           0.611631   0.173401   3.527  0.00042 ***
# tax          -0.003977   0.003063  -1.298  0.19414
# ptratio       0.428036   0.137806   3.106  0.00190 **
# lstat         0.089197   0.054505   1.636  0.10174
# medv          0.196003   0.078097   2.510  0.01208 *

# confusion matrix
glm.probs <- predict(glm.fit, test, type = "response")
glm.pred <- ifelse(glm.probs > 0.5, TRUE, FALSE)
conf_matrix <- table(Predicted = glm.pred, Actual = test$y)
print(conf_matrix)
#          Actual
# Predicted FALSE TRUE
#     FALSE    44    9
#     TRUE      4   45

# accuracy
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(accuracy)
# [1] 0.872549