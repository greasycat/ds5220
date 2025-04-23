import numpy as np
from sklearn import linear_model
from sklearn.covariance import empirical_covariance, graphical_lasso

def neighbor(W, alpha=0.01):
    n, p = W.shape
    Theta = np.zeros((p, p))
    var = np.zeros(p)  # To store residual variances
    
    for k in range(p):
        y = W[:, k]
        X = np.delete(W, k, axis=1)
        
        model = linear_model.Lasso(alpha=alpha)
        model.fit(X, y)
        beta = model.coef_
        
        y_pred = model.predict(X)
        residual = y - y_pred
        var[k] = np.var(residual)
        
        Theta[k, np.arange(p) != k] = -beta / var[k]
    
    np.fill_diagonal(Theta, 1 / var)
    
    Theta = (Theta.T + Theta) / 2 # symmetrize
    return Theta

def generate_random_precision_matrix(n_dim):
    A = np.random.randn(n_dim, n_dim) 
    
    A = A + A.T
    
    min_eig = np.min(np.linalg.eigvalsh(A))
    if min_eig < 0:
        A = A + (-min_eig + 1) * np.eye(n_dim)
    
    return A

def simulate_mvn_with_precision(n_samples, precision, mean=None):
    n_dim = precision.shape[0]
    
    if mean is None:
        mean = np.zeros(n_dim)
    
    covariance = np.linalg.inv(precision)
    samples = np.random.multivariate_normal(mean, covariance, size=n_samples)
    return samples, covariance

def mse(pred_cov, real_cov):
    diff_squared = np.square(pred_cov - real_cov)
    n = real_cov.shape[0]
    return np.sum(diff_squared) / (n*n)

def main():
    np.random.seed(1)
    precision = generate_random_precision_matrix(10)
    # print with 2 decimal places
    print(np.round(precision, 2))

    samples, covariance = simulate_mvn_with_precision(1000, precision)
    Theta = neighbor(samples)
    print("Estimated Theta:")
    print(np.round(Theta, 2))

    print("Estimated Theta with graphical lasso:")
    empirical_cov = empirical_covariance(samples)
    _, glasso = np.round(graphical_lasso(empirical_cov, alpha=0.01), 2)
    print(np.round(glasso, 2))

    print("MSE of estimated Theta:")
    print(mse(Theta, precision))
    print("MSE of estimated Theta with graphical lasso:")
    print(mse(glasso, precision))

if __name__ == "__main__":
    main()