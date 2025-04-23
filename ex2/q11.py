# %%
import numpy as np
from load_data import load_data
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, LSTM
import matplotlib.pyplot as plt
from tqdm import tqdm
# %%
downsampling = 100
data, time, onset = load_data(downsampling=downsampling)
print(data.shape)
# %%
seq_len = 10

def create_sequences(data, seq_len):
    X = []
    y = []
    for i in range(len(data) - seq_len):
        X.append(data[i:i+seq_len])
        y.append(data[i+seq_len])
    return np.array(X), np.array(y)

# %%
channels = 0

before_onset = data[channels, :onset//downsampling]
after_onset = data[channels, onset//downsampling:]

train_X, train_y = create_sequences(before_onset, seq_len)
test_X, test_y = create_sequences(after_onset, seq_len)
print(train_X.shape)
print(train_y.shape)
print(test_X.shape)
print(test_y.shape)
# %%
model = Sequential()
model.add(LSTM(50, activation='relu', input_shape=(seq_len, 1)))
model.add(Dense(1))
model.compile(optimizer='adam', loss='mse')
history = model.fit(train_X, train_y, epochs=20, validation_data=(test_X, test_y), batch_size=32)

# plot the loss
plt.plot(history.history['loss'], label='train')
plt.plot(history.history['val_loss'], label='test')
plt.legend()
plt.show()

# %%
def predict_future(model, last_seq, future_len):
    future_pred = []
    current_seq = last_seq.copy()
    for _ in tqdm(range(future_len), desc="Predicting future values"):
        next_pred = model.predict(current_seq.reshape(1, seq_len), verbose=0)[0]
        future_pred.append(next_pred[0])
        current_seq = np.append(current_seq[1:], next_pred[0])
    
    future_pred = np.array(future_pred).reshape(-1, 1)
    return future_pred

# %%
last_seq = train_X[-1, :]
future_pred = predict_future(model, last_seq, 100)
# %%

# plot the predicted and actual values
plt.plot(test_y, label='actual')
plt.plot(future_pred, label='predicted')
plt.legend()
plt.show()






# %%
