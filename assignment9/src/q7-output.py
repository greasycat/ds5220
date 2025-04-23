# %%
# test GPU
import keras
import pandas as pd

# %%
# load ../Default.csv
df = pd.read_csv('../Default.csv')

# print the first 5 rows of the dataframe
print(df.head())



# %%
# encode No as 0 and Yes as 1
df['default'] = df['default'].map({'No': 0, 'Yes': 1})
df['student'] = df['student'].map({'No': 0, 'Yes': 1})

# print the first 5 rows of the dataframe
print(df.head())



# %%
# split the dataframe into X and y
X = df.drop('default', axis=1)
y = df['default']

# custom train_test_split
def train_test_split(X, y, test_size=0.2, random_state=42):
    from random import seed
    seed(random_state)
    X_train = X.sample(frac=test_size)
    X_test = X.drop(X_train.index)
    y_train = y.sample(frac=test_size)
    y_test = y.drop(y_train.index)
    return X_train, X_test, y_train, y_test

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


# %%
model = keras.Sequential([
    keras.layers.Dense(10, input_shape=(X_train.shape[1],), activation='relu'),
    keras.layers.Dense(1, activation='sigmoid')
])

model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

model.fit(X_train, y_train, epochs=10)

# %%
accuracy = model.evaluate(X_test, y_test)
print(f"Accuracy: {accuracy[1]}")

precision = model.evaluate(X_test, y_test)
print(f"Precision: {precision[1]}")


