# %%
from load_data import Data
import numpy as np
from q8 import neighbor
from tqdm import tqdm
import matplotlib.pyplot as plt
# %%
data = Data(subject='jh102', task="ictal", acquisition="ecog", session='presurgery', run='01', root='data', plot=False)

# %%

ch, n = data.X.shape
N = n/data.sf # number of seconds of data
m = int(N/(1/2)) # 1/2 second time windows
M = int(n/m) # number of data points per time window
print(f"Number of time windows: {m}")
print(f"Number of data points per time window: {M}")
# time window k=0,1,...,m-1
Thetas = []
for k in tqdm(range(m), desc="Processing time windows"):
    W = np.zeros([ch,M]) # kth time window of X
    for j in range(ch):
        for i in range(M):
            W[j,i] = data.X[j,k*M+i]
    Theta = neighbor(W.T, 0.01)
    Thetas.append(Theta)





# %%
save_path = "Theta.npy"
np.save(save_path, Thetas)
# %%
def compute_adjacency(Theta):
    p = Theta.shape[0]
    G = 1*(np.abs(Theta) > 0)
    return (np.sum(G)/2)/(p*(p-1)/2)

density = []
# load Thetas
for Theta in Thetas:
    density.append(compute_adjacency(Theta))

# %%
# plot density
onset = data.onset / 500
plt.plot(np.array(density) - np.mean(density))
plt.xlabel("Time window")
plt.ylabel("Density")
plt.title("Density of adjacency matrix")
plt.axvline(x=onset, color='r', linestyle='--', label='Onset')
plt.show()
# %%
# plot acf and pacf of density
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

density_np = np.array(density) - np.mean(density)

# %%
import statsmodels.api as sm
from scipy import stats

def chow_test(X, y, breakpoint):
    n = len(y)
    n1 = breakpoint
    n2 = n - breakpoint
    k = 2  # Number of parameters (including intercept)

    # Add constant term to X
    X = sm.add_constant(X)
    
    # Pooled regression
    model_pooled = sm.OLS(y, X).fit()
    RSSp = model_pooled.ssr

    # Subsample regressions
    model_1 = sm.OLS(y[:breakpoint], X[:breakpoint]).fit()
    RSS1 = model_1.ssr
    model_2 = sm.OLS(y[breakpoint:], X[breakpoint:]).fit()
    RSS2 = model_2.ssr

    # Chow test statistic
    chow_stat = ((RSSp - (RSS1 + RSS2)) / k) / ((RSS1 + RSS2) / (n1 + n2 - 2 * k))

    # P-value
    p_value = 1 - stats.f.cdf(chow_stat, k - 1, n1 + n2 - k * 2)
    return p_value

x = np.arange(0, len(density_np))
y = density_np

p = chow_test(x, y, int(onset))
print(f"Chow test p-value: {p}")
print(f"{'Difference is significant' if p < 0.05 else 'Difference is not significant'}")
# %%
