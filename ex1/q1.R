# 1a
#install.packages("COUNT")
data(loomis)
str(loomis)

# drop income and travel
loomis$income <- NULL
loomis$travel <- NULL

# remove rows with NAs
loomis_preped <- na.omit(loomis)

str(loomis_preped)
# count NAs

# 1b
# fit glm possion model
glm_1b <- glm(anvisits ~ ., data = loomis_preped, family = poisson)

summary(glm_1b)

# Some values are NA in the summary because of the collinearity
# which means that the design matrix is not full rank
cat("Rank of the model matrix:", qr(glm_1b$model)$rank, "\n")
cat("Coefficient number (with intercept):", length(coef(glm_1b)), "\n")

# Rank of the model matrix: 8
# Coefficient number: 9


# copy data
dat <- loomis_preped
y <- dat[, 1] # dat is my data frame after completing 1 a
# create transformed dummy variables
# gender :
gen <- dat$gender - 1
# income :
inc25p <- as.numeric(apply(dat[, c(4, 5, 6)], 1, function(x) 1 * (sum(x) > 0)))
inc55p <- as.numeric(apply(dat[, c(5, 6)], 1, function(x) 1 * (sum(x) > 0)))
inc95p <- dat[, 6]
# travel
tra025p <- as.numeric(apply(dat[, c(8, 9)], 1, function(x) 1 * (sum(x) > 0)))
tra400p <- dat[, 9]
# create data matrix

X <- cbind( gen , inc25p , inc55p , inc95p , tra025p , tra400p )

yX <- data.frame(cbind(y, X))
# 1d
# fit glm model
glm_1d <- glm(y ~ ., family = poisson, data = yX)

summary(glm_1d)

# 1e CI of the coefficients

coef <- glm_1d$coefficients
coef
se <- summary(glm_1d)$coefficients[, 2]

# 95% CI
ci <- cbind(coef - 1.96 * se, coef + 1.96 * se)
ci

# 1f


cat(exp(coef[1] + coef[3] + coef[4]))
cat(exp(coef[1] + coef[2] + coef[3] + coef[4]))

# row c(0, 1, 1, 0, 0, 0))
newdata <- data.frame(
  gen = 0,
  inc25p = 1,
  inc55p = 1,
  inc95p = 0,
  tra025p = 0,
  tra400p = 0
)
# copy data


pred_2 <- predict(glm_1d, newdata = newdata, type = "response")

pred_2

ci
