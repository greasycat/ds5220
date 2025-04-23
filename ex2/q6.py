# %%
# %load_ext autoreload
# %autoreload 2

# %%
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import pacf
from load_data import load_data
import itertools
from statsmodels.tsa.arima.model import ARIMA
import pandas as pd
import numpy as np
import statsmodels.api as sm
import warnings
from pmdarima import auto_arima
# %%
data,time,onset = load_data(plot=True)

# %%
print(data.shape)


# %%
# auto-arima
with warnings.catch_warnings():
    warnings.filterwarnings("ignore")
    orders = []
    for i in range(data.shape[0]):
        print(f"Fitting model for channel {i}")
        model = auto_arima(data[i,:], start_p=0, start_q=0, max_p=60, max_q=60, m=1,
                   start_P=0, 
                   seasonal=False,
                   d=0, 
                   trace=False,
                   error_action='ignore',  
                   suppress_warnings=True, 
                   stepwise=True)
        orders.append(model.order)
# %%
count_dict = {}
for order in orders:
    count_dict[order] = count_dict.get(order, 0) + 1

for order, count in count_dict.items():
    print(f"Order: {order}, Count: {count}")

# %%
df

# %%

# %% randomly sample channels and plot ACF and PACF

random_channels = np.random.randint(0, data.shape[0], 5)
for i in random_channels:
    sm.graphics.tsa.plot_acf(data[i,:], lags=100)
    plt.show()
    sm.graphics.tsa.plot_pacf(data[i,:], lags=100)
    plt.show()

# %%