library(ISLR2)

# randomly sample index and train test split
set.seed(123)
index <- sample(1:nrow(Default), 0.8 * nrow(Default))
train_data <- Default[index, ]
test_data <- Default[-index, ]

# encode No as 0 and Yes as 1
Default$default <- ifelse(Default$default == "No", 0, 1)
Default$student <- ifelse(Default$student == "No", 0, 1)

# logistic regression on the Default dataset
logistic_model <- glm(default ~ student + income + balance, data = train_data, family = binomial)
# Summary of the model
summary(logistic_model)

# accuracy of the model
predicted_values <- predict(logistic_model, test_data, type = "response")
predicted_values <- ifelse(predicted_values > 0.5, 1, 0)
accuracy <- mean(predicted_values == test_data$default)
accuracy

