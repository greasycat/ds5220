###
### Loading iEEG Data
###
### Data Source:
###     https://openneuro.org/datasets/ds003029/versions/1.0.7
###
### Download:
###     https://openneuro.org/datasets/ds003029/versions/1.0.7/download
###

# pip install mne
# pip install mne_bids
import mne
from mne_bids import BIDSPath, read_raw_bids
import numpy as np
import matplotlib.pyplot as plt

def load_data(subject='jh101',
              task="ictal",
              acquisition="ecog",
              session='presurgery',
              run='01',
              root='data',
              plot=False, downsampling=1000):
    # Define the path to your BIDS-compatible folder
    bids_path = BIDSPath(
        subject=subject,
        task=task,
        acquisition=acquisition,
        session=session,
        run=run,
        datatype='ieeg',
        root=root)

    # Read the raw BIDS file
    raw = read_raw_bids(bids_path=bids_path)

    # sampling frequency
    sf = raw.info["sfreq"]
    print(f"Sampling frequency: {sf} Hz")
    
    # You can then access the data as a Raw object
    X = raw.get_data()
    p,n = np.shape(X)
    print(f"Shape: {p}x{n}")

    # create time vector
    time = np.linspace(0,(n-1)/sf,n)

    # Standardize data
    for j in range(p):
        X[j] = (X[j]-np.mean(X[j]))/np.std(X[j])
        
    # Get seizure onset time point
    events,eventsdict = mne.events_from_annotations(raw)
    print(events)
    for event_name, event_id in eventsdict.items():
        print(event_name, event_id)
    szid = None
    for key in eventsdict:
        if key.startswith('SZ EVENT '):
            szid = eventsdict[key]
            print("Key found")
    if szid is None:
        print("No key starting with 'SZ EVENT ' found")
    onset = events[np.where(events[:, 2] == szid)][0][0]

    if plot:
        # Plot series
        plt.plot(time,X[0])
        plt.xlabel('time (seconds)')
        plt.ylabel('standardized voltage')
        plt.axvline(time[onset],color='black')

    return X[:,::downsampling],time[::downsampling],onset

if __name__ == "__main__":
    X, time, onset = load_data(subject='jh101', task="ictal", acquisition="ecog", session='presurgery', run='01', root='data', plot=True, downsampling=1000)
    print(X.shape)
    print(time.shape)
    print(onset)
