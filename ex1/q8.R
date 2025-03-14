source("ex1/q5.R")

n <- nrow(X)
XtX <- t(X)%*%X/n

pm <- function(A,v1=rnorm(ncol(A)),eps=1e-6){
	v1 <- v1/max(abs(v1))
	v0 <- v1+1
	while(max(abs(v1-v0))>eps){
		v0 <- v1
		v1 <- A%*%v1
		v1 <- sign(v1[1])*v1/max(abs(v1))
	}
	v1 <- v1/sqrt(sum(v1*v1))
	list(lam=t(v1)%*%(A%*%v1),v=v1)
}

e <- pm(XtX)
p <- X%*%e$v

pmall <- function(A,eps=1e-6){
	n <- ncol(A)
	V <- matrix(0,n,n)
	lam = rep(0,n)
	for(k in 1:n){
		e <- pm(A,eps=eps)
		lam[k] <- e$lam
		V[,k] <- e$v
		A <- A-lam[k]*outer(V[,k],V[,k])
	}
	list(lam=lam,V=V)
}

E <- pmall(XtX)

principal <- function(X,eps=1e-6){
	A <- t(X)%*%X
	E <- pmall(A,eps=eps)
	X%*%E$V
}

P <- principal(X)


# model 1, y ~ PC1
pc_model1 <- newton_method(as.matrix(P[,1]), y)
summary_newton(pc_model1)

# model 2, y ~ PC1 + PC2
pc_model2 <- newton_method(as.matrix(P[,1:2]), y)
summary_newton(pc_model2)

# model 3, y ~ PC1 + PC2 + PC3
pc_model3 <- newton_method(as.matrix(P[,1:3]), y)
summary_newton(pc_model3)


