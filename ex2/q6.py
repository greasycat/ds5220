# %%
# %load_ext autoreload
# %autoreload 2

# %%
import matplotlib.pyplot as plt
from load_data import Data
import numpy as np
import statsmodels.api as sm
import warnings
from pmdarima import auto_arima
from tqdm import tqdm
# %%
data = Data(subject='jh101', task="ictal", acquisition="ecog", session='presurgery', run='01', root='data')

# %%
preictal, preictal_time = data.get_truncated(0, 500)
ictal, ictal_time = data.get_truncated(data.onset, 500)


# %%
# auto-arima
def auto_arima_orders(data):
    with warnings.catch_warnings():
        warnings.filterwarnings("ignore")
        orders = []
        for i in tqdm(range(data.shape[0]), desc="Fitting channels"):
            model = auto_arima(data[i,:], start_p=0, start_q=0, max_p=13, max_q=13, m=1,
                    start_P=0, 
                    seasonal=False,
                    d=0, 
                    trace=False,
                    error_action='ignore',  
                    suppress_warnings=True, 
                    stepwise=True, n_jobs=-1)
            orders.append(model.order)
    return orders

# %%
preictal_orders = auto_arima_orders(preictal)
np.save('preictal_orders.npy', preictal_orders)

# %%
ictal_orders = auto_arima_orders(ictal)
np.save('ictal_orders.npy', ictal_orders)

# %%

# %% randomly sample channels and plot ACF and PACF

# plot order[0] on x axis and order[1] on y axis
preictal_orders_np = np.array(preictal_orders)
ictal_orders_np = np.array(ictal_orders)
fig, ax = plt.subplots(1, 2, figsize=(10, 5))
ax[0].scatter(preictal_orders_np[:,0], preictal_orders_np[:,2])
ax[0].set_xlabel('AR order: p')
ax[0].set_ylabel('MA order: q')
ax[0].set_title('Preictal Orders')
ax[1].scatter(ictal_orders_np[:,0], ictal_orders_np[:,2])
ax[1].set_xlabel('AR order: p')
ax[1].set_ylabel('MA order: q')
ax[1].set_title('Ictal Orders')
ax[1].set_xlim(0, 13)
ax[1].set_ylim(0, 13)
# draw a line from (0,0) to (60,60)
ax[0].plot([0, 12], [0, 12], 'k--')
ax[1].plot([0, 12], [0, 12], 'k--')
plt.show()





# %%