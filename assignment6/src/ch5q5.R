library(ISLR2)

logi_model <- glm(default ~ income + balance, data = Default, family <- binomial)

summary(logi_model)

# Validation Set Approach
validation_error <- function(seed_num) {
  set.seed(seed_num)
  train <- sample(1:nrow(Default), nrow(Default)/2)
  test <- -train
  train_data <- Default[train, ]
  test_data <- Default[test, ]
  
  logi_model_val <- glm(default ~ income + balance, data = train_data, family = binomial)
  pred_val <- predict(logi_model_val, newdata = test_data, type = "response")
  
  # convert the post prob to factor Yes and No
  pred_val <- ifelse(pred_val > 0.5, "Yes", "No")
  
  # compute and return the validation set error rate
  return(mean(pred_val != test_data$default))
}

validation_error(1)
validation_error(2)
validation_error(3)

validation_error_2 <- function(seed_num) {
  set.seed(seed_num)
  train <- sample(1:nrow(Default), nrow(Default)/2)
  test <- -train
  train_data <- Default[train, ]
  test_data <- Default[test, ]
  
  logi_model_val <- glm(default ~ income + balance + student, data = train_data, family = binomial)
  pred_val <- predict(logi_model_val, newdata = test_data, type = "response")
  
  # convert the post prob to factor Yes and No
  pred_val <- ifelse(pred_val > 0.5, "Yes", "No")
  
  # compute and return the validation set error rate
  return(mean(pred_val != test_data$default))
}

validation_error_2(1)
validation_error_2(2)
validation_error_2(3)

