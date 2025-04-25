# %%
from load_data import Data
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.metrics import  f1_score, roc_auc_score
import keras
from tqdm import tqdm
# %%
downsampling = 1
data = Data(subject='jh101', task="ictal", acquisition="ecog", session='presurgery', run='01', root='data', plot=True, plot_channel=0)

# %%
channels = 0
preictal, preictal_time = data.get_truncated(0, data.onset)
ictal, ictal_time = data.get_truncated(data.onset, data.X.shape[1])
print(preictal.shape)
print(ictal.shape)

# %%
def create_windowed_dataset(preictal, ictal, window_size, stride=1, test_size=0.2, random_state=42):
    preictal_windows = []
    for i in range(0, len(preictal) - window_size + 1, stride):
        window = preictal[i:i+window_size]
        preictal_windows.append(window)
    
    # Create windows for ictal data
    ictal_windows = []
    for i in range(0, len(ictal) - window_size + 1, stride):
        window = ictal[i:i+window_size]
        ictal_windows.append(window)

    # Convert to numpy arrays and create labels
    X_preictal = np.array(preictal_windows)
    X_ictal = np.array(ictal_windows)
    y_preictal = np.zeros(len(preictal_windows))
    y_ictal = np.ones(len(ictal_windows))
    X = np.vstack((X_preictal, X_ictal))
    y = np.hstack((y_preictal, y_ictal))

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=test_size, random_state=random_state)
    return X_train, X_test, y_train, y_test

window_size = 256  
stride = 128       

def train_on_channel(channel):
    X_train, X_test, y_train, y_test = create_windowed_dataset(
        preictal[channel, :], ictal[channel, :], window_size=window_size, stride=stride)

    model = keras.Sequential()
    model.add(keras.layers.SimpleRNN(50, activation='relu', input_shape=(window_size, 1)))
    model.add(keras.layers.Dense(1))
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

    model.fit(X_train, y_train, epochs=10, validation_split=0.2, batch_size=32)

    # evaulate accuracy
    predictions = model.predict(X_test)
    predictions = (predictions > 0.5).astype(int)

    return f1_score(y_test, predictions), roc_auc_score(y_test, predictions)

# %%
f1_scores = []
auc_scores = []
for ch in tqdm(range(preictal.shape[0]), desc="Training on channels"):
    f1, auc = train_on_channel(ch)
    f1_scores.append(f1)
    auc_scores.append(auc)

# %%
# save the scores
np.save("f1_scores.npy", f1_scores)
np.save("auc_scores.npy", auc_scores)


# %%
import seaborn as sns

# load the scores
f1_scores = np.load("f1_scores.npy")
auc_scores = np.load("auc_scores.npy")

#%%

# add indices to the scores
f1_scores = np.array(f1_scores)
auc_scores = np.array(auc_scores)
f1_scores = np.column_stack((np.arange(len(f1_scores)), f1_scores))
auc_scores = np.column_stack((np.arange(len(auc_scores)), auc_scores))

# sort the scores by f1 score
f1_scores = f1_scores[f1_scores[:, 1].argsort()]
auc_scores = auc_scores[auc_scores[:, 1].argsort()]


# find the top 10% scores
top_10_f1_scores = f1_scores[-int(len(f1_scores) * 0.1):]
top_10_auc_scores = auc_scores[-int(len(auc_scores) * 0.1):]

# find the bottom 10% scores
bottom_10_f1_scores = f1_scores[:int(len(f1_scores) * 0.1)]
bottom_10_auc_scores = auc_scores[:int(len(auc_scores) * 0.1)]

# %%
# plot the distribution of the scores
fig, axs = plt.subplots(2, 1, figsize=(10, 10))
axs[0].hist(f1_scores[:, 1], bins=20, edgecolor='black')
axs[0].set_xlabel('F1 Score')
axs[0].set_ylabel('Frequency')
axs[0].set_title('Distribution of F1 Scores')
axs[1].hist(auc_scores[:, 1], bins=20, edgecolor='black')
axs[1].set_xlabel('AUC Score')
axs[1].set_ylabel('Frequency')
axs[1].set_title('Distribution of AUC Scores')
plt.show()


# %%
print(f1_scores)

# %%

