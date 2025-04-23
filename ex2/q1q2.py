# %%
# %load_ext autoreload
# %autoreload 2

# %%
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import pacf
from load_data import load_data

# %%
data,time,onset = load_data(plot=True)

# %%
print(f"Onset: {onset/1000} seconds")
print(f"Data shape: {data.shape}")
print(f"Time shape: {time.shape}")
plt.plot(time, data[0])
plt.axvline(onset/1000, color='red')

# %%
# check each row and see if 0 is in the confidence interval and stop when it is
def find_order(data):
    orders = []
    for i in range(data.shape[0]):
        pacf_values,confint = pacf(data[i], nlags=len(data[i])//2, method='ywm', alpha=0.05)
        last_significant_i = 0
        for i in range(len(pacf_values)):
            if confint[i][0] > 0 or 0 > confint[i][1]:
                last_significant_i = i
        orders.append(last_significant_i)
    return orders

full_orders = find_order(data)
middle_point = 59
first_order = find_order(data[:, :middle_point])
second_order = find_order(data[:, middle_point:])
partial_orders = find_order(data[:, :middle_point + 15])


# %%
# subplot distribution of full, first, and second orders
fig, axs = plt.subplots(4, 1, figsize=(10, 15))
axs[0].hist(full_orders, bins=range(0, 100, 1))
axs[0].set_xlabel('Order')
axs[0].set_ylabel('Frequency')
axs[0].set_title('Distribution of Orders for each channel over all time')

axs[1].hist(first_order, bins=range(0, 100, 1))
axs[1].set_xlabel('Order')
axs[1].set_ylabel('Frequency')
axs[1].set_title('Distribution of Orders for each channel over first half of time')

axs[2].hist(second_order, bins=range(0, 100, 1))
axs[2].set_xlabel('Order')
axs[2].set_ylabel('Frequency')
axs[2].set_title('Distribution of Orders for each channel over second half of time')

axs[3].hist(partial_orders, bins=range(0, 100, 1))
axs[3].set_xlabel('Order')
axs[3].set_ylabel('Frequency')
axs[3].set_title('Distribution of Orders for each channel over first half of time + 15 seconds')

fig.tight_layout()

plt.savefig('figs/q2.png')






