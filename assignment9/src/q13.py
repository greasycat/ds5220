# %%
import tensorflow as tf
from keras.datasets import imdb
from keras.preprocessing.sequence import pad_sequences
from sklearn.metrics import classification_report, accuracy_score

def experiment_vocab_size(vocab_size, max_len=500, epochs=3):
    print(f"Experiment with vocabulary size: {vocab_size}, max_len: {max_len}")
    (x_train, y_train), (x_test, y_test) = imdb.load_data(num_words=vocab_size)
    
    x_train_padded = pad_sequences(x_train, maxlen=max_len)
    x_test_padded = pad_sequences(x_test, maxlen=max_len)
    
    model = tf.keras.Sequential([
        tf.keras.layers.Embedding(input_dim=vocab_size, 
                                 output_dim=32,  # embedding dimension
                                 input_length=max_len),
        tf.keras.layers.LSTM(units=32),
        tf.keras.layers.Dense(1, activation='sigmoid')
    ])
    
    model.compile(optimizer='adam',
                 loss='binary_crossentropy',
                 metrics=['accuracy'])
    
    model.fit(
        x_train_padded, y_train,
        epochs=epochs,
        batch_size=64,
        validation_split=0.2,
        verbose=0
    )
    
    y_pred = model.predict(x_test_padded)
    y_pred_classes = (y_pred > 0.5).astype(int).flatten()
    
    accuracy = accuracy_score(y_test, y_pred_classes)
    
    cr = classification_report(y_test, y_pred_classes, output_dict=True)
    
    return {
        'vocab_size': vocab_size,
        'max_len': max_len,
        'accuracy': accuracy,
        'precision': cr['weighted avg']['precision'],
        'recall': cr['weighted avg']['recall'],
        'f1_score': cr['weighted avg']['f1-score'],
    }

# Run experiments with different vocabulary sizes
vocab_sizes = [1000, 3000, 5000, 10000]
max_lengths = [500]

results = []

for vocab_size in vocab_sizes:
    for max_len in max_lengths:
        result = experiment_vocab_size(vocab_size, max_len)
        results.append(result)


# %%

print("\n\nSummary of Results:")
print(f"{'Vocab Size':<12} {'Accuracy':<10} {'F1 Score':<10}")
print("-" * 65)

for r in results:
    print(f"{r['vocab_size']:<12}{r['accuracy']:<10.4f} "
          f"{r['f1_score']:<10.4f}")


