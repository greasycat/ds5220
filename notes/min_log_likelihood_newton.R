newton <- function(f, grad, H, rps=1e-6) {
  v1 <- rnorm(p)
  v0 <- v1+1

  while(max(abs(v1-v0)) > eps) {
    v0 <- v1
    H_inv <- solve(H(v0))
    v1 <- v0 - H_inv%*%grad(v0)
  }
  v1
}
