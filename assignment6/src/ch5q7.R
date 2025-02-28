library(ISLR2)
library(boot)

logi_model_1 <- glm(Direction ~ Lag1 + Lag2, data = Weekly, family <- binomial)
summary(logi_model_1)


# All but first observation
logi_model_2 <- glm(Direction ~ Lag1 + Lag2, data = Weekly[2:nrow(Weekly),], family <- binomial)

first_obs_pred <- predict(logi_model_2, Weekly[1,], type = "response")

first_obs_pred <- ifelse(first_obs_pred > 0.5, "Up", "Down")
first_obs_pred == Weekly[1,]$Direction
# NO

err <- c()
for (n in 1:(nrow(Weekly) - 1)) {
  logi_model <- glm(Direction ~ Lag1 + Lag2, data = Weekly[-n,], family <- binomial)
  pred <- predict(logi_model, Weekly[n,], type = "response")
  pred <- ifelse(pred > 0.5, "Up", "Down")
  if (pred == Weekly[n,]$Direction) {
    err <- c(err, 0)
  } else {
    err <- c(err, 1)
  }
}

mean(err)
# 0.4504
# Slightly lower than 50% error rate





