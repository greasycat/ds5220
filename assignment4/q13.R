# applied 13a-d

library(ISLR2)

summary(Weekly)

pairs(Weekly)

cor(subset(Weekly, select= -c(Direction)))

# logistic regression

glm.fit <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, data = Weekly, family = binomial)

summary(glm.fit)

# confusion matrix
glm.probs <- predict(glm.fit, type = "response")

glm.pred <- ifelse(glm.probs > 0.5, "Up", "Down")

# Ensure levels match
glm.pred <- factor(glm.pred, levels = levels(Weekly$Direction))

# Confusion matrix
conf_matrix <- table(Predicted = glm.pred, Actual = Weekly$Direction)
print(conf_matrix)

#          Actual
# Predicted Down  Up
#      Down   54  48
#      Up    430 557

# select year 2008 and earlier for training
train <- Weekly[Weekly$Year < 2009, ]
test <- Weekly[Weekly$Year >= 2009, ]

glm.fit <- glm(Direction ~ Lag2, data = train, family = binomial)
glm.probs <- predict(glm.fit, test, type = "response")
glm.pred <- ifelse(glm.probs > 0.5, "Up", "Down")
glm.pred <- factor(glm.pred, levels = levels(test$Direction))
conf_matrix <- table(Predicted = glm.pred, Actual = test$Direction)
print(conf_matrix)

#          Actual
# Predicted Down Up
#      Down    9  5
#      Up     34 56

# accuracy
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(accuracy)
# 0.625
