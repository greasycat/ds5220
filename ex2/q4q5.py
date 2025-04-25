# %% 
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm

# %%
def simulate_ma(seed=42):
    np.random.seed(seed)
    q = 5
    theta_sig = 1
    theta = np.random.normal(0,theta_sig,q)
    t = int(1e3)
    sig = 1
    eps = np.zeros(t+q)
    eps[q:] = np.random.normal(0,sig,t)
    y = np.zeros(t)
    for k in range(t):
        epsix = np.arange(k,k+q)
        y[k] = np.dot(theta,eps[epsix[::-1]])+eps[k]
    return y

# %%
y = simulate_ma()

# %%
# method of moment estimation
def estimate_ma1_mom(data):
    mu = np.mean(data)
    centered_data = data - mu
    
    n = len(centered_data)
    numerator = sum(centered_data[1:] * centered_data[:-1])
    denominator = sum(centered_data**2)
    acf_1 = numerator / denominator

    print("acf_1: ", acf_1)
    if abs(acf_1) > 0.5:
        acf_1 = 0.499 * np.sign(acf_1)

    d = 1 - 4 * acf_1**2

    if acf_1 > 0:
        theta = (1 - np.sqrt(d)) / (2 * acf_1)
    else:
        theta = (1 + np.sqrt(d)) / (2 * acf_1)
    
    return theta

# %%
theta = estimate_ma1_mom(y)
print(theta)

# %%
# estimate MA(1) model with statsmodels
model = sm.tsa.arima.ARIMA(y, order=(0,0,1))
results = model.fit()

# get the estimated theta
theta_hat = results.params[1]
print(theta_hat)

# %%
# ACF plot
sm.graphics.tsa.plot_pacf(y, lags=10)
plt.show()

# %%
