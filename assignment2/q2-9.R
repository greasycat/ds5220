library(ISLR2)

# (a)
summary(Auto)
sapply(Auto, class)
# Quantitative: mpg, displacement, horsepower, weight, acceleration, year
# Qualitative: cylinders, origin

# (b) (c)
continuous = c("mpg", "displacement", "horsepower", "weight", "acceleration", "year")
for (v in continuous) {
  cat(v,"\n")
  cat("range:", range(Auto[[v]]), "\t")
  cat("mean:", mean(Auto[[v]]), "\t")
  cat("sd:", sd(Auto[[v]]), "\n\n")
}

# (d)
Auto_subset <- Auto[-c(10:85),]

for (v in continuous) {
  cat(v,"\n")
  cat("range:", range(Auto_subset[[v]]), "\t")
  cat("mean:", mean(Auto_subset[[v]]), "\t")
  cat("sd:", sd(Auto_subset[[v]]), "\n\n")
}

pairs(Auto[,-ncol(Auto)])
# More Cylinder means less mpg
# Engine displacement and mpg are negatively related
# Acceleration and mpg are not strongly correlated

# (e)

# A few variables can be used to predict mpg, cylinders, displacement, horsepower, weight because they shows strong linear pattern with mpg