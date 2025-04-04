library(reticulate)
use_python("/home/rongfei/WorkSpace/ds5220/assignment9/.venv/bin/python") # for local testing
library(keras3)
library(ISLR2)


# logistic regression on the Default dataset
logistic_model <- glm(default ~ student + income + balance, data = Default, family = binomial)
\
# Summary of the model
summary(logistic_model)



modnn <- keras_model_sequential () %>%
  layer_dense(units = 19, activation = "relu",input_shape = 3) %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 1, activation="softmax") # output layer for binary classification

modnn %>% compile(loss = "crossentropy", # loss function for binary classification
                 optimizer = optimizer_rmsprop(), # using RMSprop optimizer
                 metrics = c("accuracy") # metrics to monitor during training
)
summary(modnn) # Display the model summary

hist <- modnn %>% fit(
  as.matrix(Default[, c("student", "income", "balance")]), # Features
  as.matrix(ifelse(Default$default == "Yes", 1, 0)), # Target variable, convert to binary
  epochs = 50, # Number of epochs for training
  batch_size = 32, # Size of each batch
  validation_split = 0.2 # Use 20% of the data for validation
)
