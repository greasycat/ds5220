$$
A^T A = I
$$

if $A$ is orthonormal 

Remark: In the context of multiple linear regression, the inverse matrix from $\hat \beta = (X^T X)^-1X^Ty$ can be obtain from simply taking reciprocal.

# PCA

Principal Component Vectors
$X\in \mathbb R^{n\times p}$ with centered columns

Now the Singular Value Decomposition
$$
X = UDV^T
$$
where
- $U$ is an $\mathbb R^{n\times p}$ and it is orthonormal
- $D$ is an $\mathbb R^{p\times p}$ 
- $V^T$ is an $\mathbb R^{p\times p}$ and it is orthonormal
$P = UD$

Find the vector that represents the most variability

define $u = Xv$
minimize $||u||^2$ to maximize the variability is equivalent to minimize the $||Xv||^2$
$$
\begin{align*}
||Xv||^2 &= (X^Tv)^T(Xv)\\
&= v^T(X^TvX)v\\
\end{align*}
$$


Note that $X^TX$ is the covariance of X
since ith row of X^T times ith column  of X is 

$$x_i \cdot x_j$$

Define A = $X^TX$, from lemma we know A is symmetric then $A=V\Theta V^T$ then the V, which is the matrix of eigenvectors is orthonormal

Note we want to maximize
$$\hat x^T A x = \sum \Theta_k (v_k \cdot x_k)^2$$
then $x = v_i$ is the solution which maximize $x^TAx$ to be $\sum \Theta$
then $u_i=Xv_i$

We have principal components matrix
$$P=XV=UDV'V = UD$$

Note
$$
\begin{align*}
X^TX &= (UDV^T)^T(UDV^T) \\
&= VD^TU^TUDV^T \\
&=VD^2V^T
\end{align*}
$$


Theorem: The eigenvalues of $\lambda_1, \ldots, \lambda_p\ge 0$

Then $$XX$$ are equal to the singular values of X

# Releigh Coefficient


# Find next PC

$$
\begin{align*}
\mathbf A &= \mathbf V \mathbf \Theta \mathbf V^T \\
&= \sum \mathbf \Theta_k \mathbf v_k \mathbf v_k^T
\end{align*}
$$

$\mathbf B = \mathbf A - \mathbf \Theta_1 \mathbf v_1 \mathbf v_1^T$
Find the eigenvector of $\mathbf B$ which is the next PC

# Logistic regression

Given $(y_1, x_1), (y_2, x_2), (y_n, x_n)$

Logistic Function
$$
\begin{align*}
\phi(x) &= \frac{e^x}{1+e^{x}} \\
\end{align*}
$$

Note
$$
\begin{align*}
\mathrm Pr(y=1|x) &= p^y(1-p)^{1-y} \\
&= \mathrm exp(y\log p + (1-y)\log(1-p)) \\
&= \mathrm exp(y\cdot \underset{\mathrm{logit}(p)}{\log \frac{p}{1-p}} + \log(1-p)) \\
\end{align*}
$$

Note that $\log \frac{p}{1-p}$ is the logit function
$$
\begin{align*}
a = \log(\frac{p}{1-p}) &\Rightarrow p = \frac{e^a}{1+e^a} \\
\end{align*}
$$

Then we have
$$
\begin{align*}
\mathrm Pr(y=1|x) &= \mathrm exp(y\cdot a + \log(1-p)) \\
&= \mathrm exp(y\cdot a + \log(1-\frac{e^a}{1+e^a})) \\
&= \mathrm exp(y\cdot a + \log(\frac{1}{1+e^a})) \\
&= \mathrm exp(y\cdot a - \log(1+e^a)) \\
&= \frac{e^{ya}}{1+e^a} = \phi (a)\\
\end{align*}
$$

We let $a = \beta_0 + \beta_1 x_1 + \ldots + \beta_p x_p$

Then we have

$$
\begin{align*}
\mathrm Pr(y=1|x) &= \phi(\beta_0 + \beta_1 x_1 + \ldots + \beta_p x_p) \\
\end{align*}
$$

# Multiple Logistic Regression
$$
\begin{align*}
\eta &= \beta_0 + \beta_1 x_1 + \ldots + \beta_p x_p \\
\end{align*}
$$

$$
\begin{align*}
\mathrm Pr(Y=y|X_1 = x_1, \ldots, X_n = x_n) &= \phi(\eta) \\
\end{align*}
$$

Suppose that $y_1, \ldots, y_n \overset{\rm iid}{\sim} \mathrm{Bernoulli}(p)$

Likelihood 
$$
\begin{align*}
L(\beta_0, \ldots, \beta_p) &= \prod_{i=1}^n p^{n \cdot \bar y} (1-p)^{n \cdot \bar y} \\
\end{align*}
$$

# Cross-Entropy to minimize
$$
\frac{1}{n} \log L(\beta_0, \ldots, \beta_p) = \bar y \log p + (1-\bar y) \log(1-p)
$$

when y = 1
$$
\begin{align*}
L(p|y=1) &= -\log p \\
\end{align*}
$$
when y = 0
$$
L(p|y=0) = -\log(1-p)
$$

$$
L(\hat \beta | \hat y, X) = - \frac{1}{n} \sum_{i=1}^n \left[ y_i \log\hat \pi (x_i) + (1-y_i) \log(1-\hat \pi (\hat x_i)) \right]
$$

where
$$
\hat \pi(x) = \frac{e^{\hat \beta_0 + \hat \beta_1 x_1 + \ldots + \hat \beta_p x_p}}{1+e^{\hat \beta_0 + \hat \beta_1 x_1 + \ldots + \hat \beta_p x_p}}
$$

# Convex Estimation

Newton's Method comes from Taylor approximation    

$f(x_1) = f(x_0) + f'(x_0)(x_1-x_0)$

$f(\mathrm x) = f(\mathrm x_0) + \nabla f(\mathrm x_0) (\mathrm x - \mathrm x_0)$

But we interested in the gradient

$$
\nabla f(\mathrm x_0) = \nabla f(\mathrm x_0) + \nabla^2 f(\mathrm x_0)(\mathrm x - \mathrm x_0)
$$

Newton's update
$$
\mathrm x_1 = \mathrm x_0 - [\nabla^2 f(\mathrm x_0)]^{-1} \nabla f(\mathrm x_0)
$$

Gradient Descent doesn't require inversion of Hessian, but slower to converge

