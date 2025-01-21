library(alr4)

set.seed(256) 

total_rows <- nrow(Heights)
con_set_size <- floor(total_rows / 3)
val_set_size <- total_rows - con_set_size

con_indices <- sample(seq_len(total_rows), size = con_set_size)
con_set <- Heights[con_indices, ]
val_set <- Heights[-con_indices, ]

X_train <- as.matrix(cbind(Intercept = 1, con_set$mheight))
y_train <- as.matrix(con_set$dheight)
X_val <- as.matrix(cbind(Intercept = 1, val_set$mheight))
y_val <- as.matrix(val_set$dheight)

XtX <- t(X_train) %*% X_train
XtX_inv <- solve(XtX)
Xty <- t(X_train) %*% y_train
beta <- XtX_inv %*% Xty

val_set$pred <- X_val %*% beta
val_set$resid <- val_set$dheight - val_set$pred
mse <- mean(val_set$resid^2)
rmse <- sqrt(mse)
cat(rmse) # 2.205687

resid_train <- y_train - X_train %*% beta
RSS <- sum(resid_train^2)
n <- nrow(X_train)
p <- ncol(X_train)
sigma2 <- RSS / (n - p)
X_val_XtX_inv <- X_val %*% XtX_inv
val_set$SE_pred <- sqrt(sigma2 * (1 + rowSums(X_val_XtX_inv * X_val)))
mse2 = mean(val_set$SE_pred^2)
rmse2 = sqrt(mse2)
cat(rmse2) # 2.392998
