func <- function(n) {
    1 - ((n - 1) / n)^n
}

n <- 1:10000
plot(n, func(n),
    type = "l", col = "blue", xlab = "n", ylab = "f(n)",
    main = "f(n) = 1 - ((n-1)/n)^n", ylim = c(0, 1), log = "x"
)

store <- rep(NA, 10000)
for (i in 1:10000) {
    store[i] <- sum(sample(1:100, rep = TRUE) == 4) > 0 # nolint
}
mean(store)
