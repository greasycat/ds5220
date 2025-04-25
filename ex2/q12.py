# %%
from load_data import Data
import numpy as np
from sklearn.covariance import GraphicalLasso
from q8 import neighbor
from tqdm import tqdm
import matplotlib.pyplot as plt
# %%
data = Data(subject='jh101', task="ictal", acquisition="ecog", session='presurgery', run='01', root='data', plot=False)

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
for Theta in Thetas:
    density.append(compute_adjacency(Theta))

# %%
# plot density
onset = data.onset / 500
plt.plot(density)
plt.xlabel("Time window")
plt.ylabel("Density")
plt.title("Density of adjacency matrix")
plt.axvline(x=onset, color='r', linestyle='--', label='Onset')
plt.show()
# %%
