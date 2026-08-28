"""
plot_freq_load1shed.py
Reads and plots freq_load1shed.txt from the provided folder.
"""

from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd


def main() -> None:
    data_folder = Path(r"C:\Users\e0891832\OneDrive - Eaton\CICERO_TAS")
    file_path = data_folder / "freq_load1shed.txt"

    if not file_path.is_file():
        raise FileNotFoundError(f"File not found: {file_path}")

    # File format observed: optional header row, then comma-separated numeric columns.
    df = pd.read_csv(file_path, header=None, skipinitialspace=True)

    # Convert everything to numeric; header-like strings become NaN and are dropped.
    df = df.apply(pd.to_numeric, errors="coerce").dropna(how="all")

    if df.empty:
        raise ValueError(f"No numeric data found in {file_path}")

    if df.shape[1] == 1:
        y = df.iloc[:, 0].dropna().to_numpy()
        x = range(len(y))
        x_label = "Sample Index"
    else:
        xy = df.iloc[:, :2].dropna()
        if xy.empty:
            raise ValueError("No valid time/value pairs found in first two columns.")
        x = xy.iloc[:, 0].to_numpy()
        y = xy.iloc[:, 1].to_numpy()
        x_label = "Time (s)"

    plt.figure(figsize=(10, 5), facecolor="white")
    plt.plot(x, y, color="tab:blue", linewidth=1.5)
    plt.grid(True, alpha=0.35)
    plt.xlabel(x_label)
    plt.ylabel("Frequency (Hz)")
    plt.title("freq_load1shed Time Series")
    plt.tight_layout()
    plt.show()

    print(f"Loaded {len(y)} samples from {file_path}")


if __name__ == "__main__":
    main()
