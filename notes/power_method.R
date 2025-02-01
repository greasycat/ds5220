library(ISLR)
pm <- function(A, v1=rnorm(ncol(A)), eps=1e-6) {
  v_0 <- v1+1
  md <- max(abs(v1 - v0))
  ms <- max(abs(v1 + v0)) # handle negative eigenvalues
  while (min(ms,md)>eps) {
    v0 <- v1
    v1 <- A%*%v1
    v1 <- v1/max(abs(v1))
    md <- max(abs(v1 - v0))
    ms <- max(abs(v1 + v0)) # handle negative eigenvalues
  }
  normalize_v1 = v1/sqrt(sum(v1*v1))
  list(lambda = t(v1)%*%(A%*%v1), v = v1)
}

pmall <- function(A, eps=1e-7) {
  n <- ncol(A)
  V <- matrix(0, n, n)
  lam <- rep(0, n)
  for (i in 1:n) {
    res <- pm(A, eps)
    lam[i] <- res$lambda
    V[,i] <- res$v
    A <- A - lam[i]*v[,i]*outer(V[,i], V[,i])
  }
}

E <- pmall(XtX)
principal_components <- function(X, eps=1e-7) {
  A<- t(X)%*%X
  E <- pmall(A, eps)
  X%*%E$v
}
