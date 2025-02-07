
### Clear workspace

rm(list=ls())

### Logistic function

phi <- function(z) 1/(1+exp(-z))

###
### We simulate the data
###

### Set the size of the problem

n <- 25
p <- 1

### Simulate the x-values

sigx <- 1 # standard deviation of the x-values
X <- cbind(1,matrix(rnorm(n*p,0,sigx),n,p))
X

### Simulate the true beta values

sigb <- 1 # standard deviation of the true beta-values
beta <- rnorm(p+1,0,sigb)

### Simulate the y-values

eta <- as.numeric(X%*%beta)
y <- rep(0,n)
for(i in 1:n){
	pr <- phi(eta[i])
	y[i] <- rbinom(1,1,pr)
}

###
### We estimate the parameters from the data.
###

grad <- function(beta,y,X){
	eta <- as.numeric(X%*%beta)
	colSums(sweep(X,1,phi(eta)-y,"*"))
}

hess <- function(beta,y,X){
	peta <- phi(as.numeric(X%*%beta))
	t(X)%*%sweep(X,1,peta,"*")
}

logreg <- function(y,X,eps=1e-6){
	pp1 <- ncol(X) # pp1 = p+1
	beta1 <- rnorm(pp1)
	beta0 <- beta1+1
	ct <- 0
	while(max(abs(beta1-beta0))>eps){
		ct <- ct+1
		beta0 <- beta1
		beta1 <- beta0-as.numeric(solve(hess(beta0,y,X))%*%grad(beta0,y,X))
		print(max(abs(beta1-beta0)))
	}
	beta1
}

betahat <- logreg(y,X)

betahat

m <- glm(y~.,data=data.frame(X[,-1]),family=binomial)

data.frame(cbind(betahat,m$coef))

### Plot what we have
### Along with the true logistic function

# the truth
par(mfrow=c(1,1))
plot(eta,y,pch=19,
	main="binary response versus linear predictor",
	xlab="linear predictor (eta)",
	ylab="y")
ix <- sort(eta,index.return=TRUE)$ix
lines(eta[ix],phi(eta[ix]),lwd=3)
abline(h=c(0,1/2,1))
abline(v=0)

# the estimated model

etahat <- as.numeric(X%*%betahat)
ix <- sort(etahat,index.return=TRUE)$ix
lines(etahat[ix],phi(etahat[ix]),lwd=2,lty=2,col='red')

# misclassification rate

yhat <- 1*(phi(etahat)>0.5)
mean(y!=yhat)
