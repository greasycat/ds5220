# Plan: train 2 models one for onset and one for offset and compare the complexity of the models
# %%
import numpy as np
from load_data import Data
import keras
import matplotlib.pyplot as plt
from tqdm import tqdm
from sklearn.model_selection import TimeSeriesSplit
# %%
data = Data(subject='jh101', task="ictal", acquisition="ecog", session='presurgery', run='01', root='data', plot=True)

# %%
preictal,_ = data.get_truncated(0, 5*data.sf)
ictal,_ = data.get_truncated(data.onset, 5*data.sf)

print(preictal.shape)
print(ictal.shape)

# %%
seq_len = 20

def create_sequences(data, seq_len):
    X = []
    y = []
    for i in range(len(data) - seq_len):
        X.append(data[i:i+seq_len])
        y.append(data[i+seq_len])
    return np.array(X), np.array(y)

def sequence_cross_validation(data, seq_len, n_splits=5):
    X, y = create_sequences(data, seq_len)
    tscv = TimeSeriesSplit(n_splits=n_splits)
    for train_index, test_index in tscv.split(X):
        X_train, X_test = X[train_index], X[test_index]
        y_train, y_test = y[train_index], y[test_index]
        yield X_train, X_test, y_train, y_test

# %%
def get_sequences_from_channel(channel, seq_len):
    preictal_X, preictal_y = create_sequences(preictal[channel,:], seq_len)
    ictal_X, ictal_y = create_sequences(ictal[channel,:], seq_len)
    return preictal_X, preictal_y, ictal_X, ictal_y

# %%
preictal_model = keras.Sequential()
preictal_model.add(keras.layers.SimpleRNN(50, activation='relu', input_shape=(seq_len, 1)))
preictal_model.add(keras.layers.Dense(1))
preictal_model.compile(optimizer='adam', loss='mse', metrics=['mse'])

def cv_model(model, data, seq_len, n_splits=5):
    average_mse = 0
    for X_train, X_test, y_train, y_test in sequence_cross_validation(data, seq_len, n_splits):
        model = keras.models.clone_model(preictal_model)
        model.fit(X_train, y_train, epochs=5, validation_split=0.2, batch_size=32, verbose=0)
        test_loss = model.evaluate(X_test, y_test, verbose=0)
        average_mse += test_loss[1]
    average_mse /= n_splits
    return average_mse

preictal_mse = []
ictal_mse = []
random_sample_channels = np.random.randint(0, preictal.shape[0], 10)
for i in tqdm(random_sample_channels, desc="Training models"):
    preictal_mse.append(cv_model(preictal_model, preictal[i,:], seq_len))
    ictal_mse.append(cv_model(preictal_model, ictal[i,:], seq_len))
    print(f"Channel {i} preictal mse: {preictal_mse[-1]}, ictal mse: {ictal_mse[-1]}")

# %%
import seaborn as sns
import numpy as np

data = {
    'Channel': list(range(len(preictal_mse))) * 2,
    'MSE': preictal_mse + ictal_mse,
    'State': ['Preictal'] * len(preictal_mse) + ['Ictal'] * len(ictal_mse)
}

sns.barplot(x='Channel', y='MSE', hue='State', data=data)
plt.title('MSE Comparison: Preictal vs Ictal States')
plt.xlabel('Channel')
plt.ylabel('Mean Squared Error')
plt.legend(title='State')
plt.show()
# %%
# %%
