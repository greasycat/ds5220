set.seed(42)
w_1 <- matrix(rnorm(4*2), nrow=4)
b_1 <- matrix(rnorm(2), ncol=2) # bias for the first layer, 2 neurons

w_2 <- matrix(rnorm(2*3), nrow=2)
b_2 <- matrix(rnorm(3), ncol=3) 

z <- matrix(rnorm(3), nrow=3)
b_3 <- matrix(rnorm(1), ncol=1) 

X <- matrix(c(1,2,3,4), ncol=4)

g <- function(x) {
  return(pmax(0, x))
}

a1 <- g(X %*% w_1 + b_1)

a1

a2 <- g(a1 %*% w_2 + b_2)

z <- g(a2 %*% z + b_3)

z