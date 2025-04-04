library(ISLR2)
library(e1071)

str(OJ)

# sample 800 rows from the data
set.seed(123)
training_rows <- sample(1:nrow(OJ), 800, replace = FALSE)
oj_training <- OJ[training_rows, ]
oj_testing <- OJ[-training_rows, ]

# svc with cost = 0.01
svc_model <- svm(Purchase ~ ., 
                 data = oj_training,
                 kernel = "linear",
                 cost = 0.01)

summary(svc_model)

compute_errors <- function(model, training, testing) {
  pred <- predict(model, training)
  mat <- table(pred, training$Purchase)
  error_rate <- 1 - sum(diag(mat)) / sum(mat)

  pred_test <- predict(model, testing)
  mat_test <- table(pred_test, testing$Purchase)
  error_rate_test <- 1 - sum(diag(mat_test)) / sum(mat_test)

  return(list(training_error = error_rate, testing_error = error_rate_test))
}


tuned_svc_model <- tune(svm, Purchase ~ ., 
                     data = oj_training,
                     kernel = "linear",
                     ranges = list(cost = c(0.001, 0.01, 0.1, 1, 10)))


# Radial version
radial_model_1 <- svm(Purchase ~ ., 
                     data = oj_training,
                     kernel = "radial",
                     cost = 0.01
                     )
summary(radial_model_1)

# tune radial model
tuned_radial_model_1 <- tune(svm, Purchase ~ ., 
                            data = oj_training,
                            kernel = "radial",
                            ranges = list(cost = c(0.001, 0.01, 0.1, 1, 10)))


# polynomial version d=2
poly_model <- svm(Purchase ~ ., 
                     data = oj_training,
                     kernel = "polynomial",
                     cost = 0.01,
                     degree = 2
                     )
summary(poly_model)

tuned_poly_model <- tune(svm, Purchase ~ ., 
                            data = oj_training,
                            kernel = "polynomial",
                            ranges = list(cost = c(0.001, 0.01, 0.1, 1, 10)))


compute_errors(svc_model, oj_training, oj_testing)
compute_errors(tuned_svc_model$best.model, oj_training, oj_testing)
compute_errors(radial_model_1, oj_training, oj_testing)
compute_errors(tuned_radial_model_1$best.model, oj_training, oj_testing)
compute_errors(poly_model, oj_training, oj_testing)
compute_errors(tuned_poly_model$best.model, oj_training, oj_testing)
