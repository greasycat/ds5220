
# %%
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import pacf
from load_data import Data
from tqdm import tqdm

# %%
data = Data(subject='jh101', task="ictal", acquisition="ecog", session='presurgery', run='01', root='data')

# %%
print(f"Onset: {data.onset/1000} seconds")
print(f"Data shape: {data.X.shape}")
print(f"Time shape: {data.time.shape}")
plt.plot(data.time, data.X[0])
plt.axvline(data.onset/1000, color='red')

# %%
# check each row and see if 0 is in the confidence interval and stop when it is
def find_order(data):
    orders = []
    for i in tqdm(range(data.shape[0]), desc="Finding orders"):
        pacf_values,confint = pacf(data[i, :], nlags=len(data[i, :])//2, method='ywm', alpha=0.05)
        last_significant_i = 0
        for i in range(len(pacf_values)):
            if confint[i][0] > 0 or 0 > confint[i][1]:
                last_significant_i = i
        orders.append(last_significant_i)
    return orders

preictal, preictal_time = data.get_truncated(0, 5*100)
ictal, ictal_time = data.get_truncated(data.onset, 5*100)
print(preictal.shape)
print(ictal.shape)

first_order = find_order(preictal)
second_order = find_order(ictal)


# %%
# subplot distribution of full, first, and second orders
fig, axs = plt.subplots(2, 1, figsize=(10, 15))
axs[0].hist(first_order, bins=range(0, 100, 1))
axs[0].set_xlabel('Order')
axs[0].set_ylabel('Frequency')
axs[0].set_title('Distribution of Orders for each channel over first half of time')

axs[1].hist(second_order, bins=range(0, 100, 1))
axs[1].set_xlabel('Order')
axs[1].set_ylabel('Frequency')
axs[1].set_title('Distribution of Orders for each channel over second half of time')


fig.tight_layout()

plt.savefig('figs/q2.png')






