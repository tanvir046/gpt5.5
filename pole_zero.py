import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# Time vector
t = np.linspace(0, 5, 1000)

fig, axes = plt.subplots(1, 2, figsize=(12, 5))

# --------------------------------------------------
# Subplot 1: Effect of Pole Location
# G(s) = 1/(s+a)
# --------------------------------------------------
pole_values = [1, 2, 5, 10]

for a in pole_values:
    num = [1]
    den = [1, a]

    sys = signal.TransferFunction(num, den)
    tout, y = signal.step(sys, T=t)

    axes[0].plot(tout, y, label=f'Pole = -{a}')

axes[0].set_title("Effect of Pole Location")
axes[0].set_xlabel("Time (s)")
axes[0].set_ylabel("Output")
axes[0].grid(True)
axes[0].legend()

# --------------------------------------------------
# Subplot 2: Effect of Zero Location
# G(s) = (s+z)/(s+5)
# Pole fixed at -5
# --------------------------------------------------
zero_values = [0.5, 2, 5, 10]

for z in zero_values:
    num = [1, z]
    den = [1, 5]

    sys = signal.TransferFunction(num, den)
    tout, y = signal.step(sys, T=t)

    axes[1].plot(tout, y, label=f'Zero = -{z}')

axes[1].set_title("Effect of Zero Location")
axes[1].set_xlabel("Time (s)")
axes[1].set_ylabel("Output")
axes[1].grid(True)
axes[1].legend()

plt.tight_layout()
plt.savefig('pole_zero_plot.png', dpi=100, bbox_inches='tight')
print("Plot saved as pole_zero_plot.png")
try:
    plt.show()
except:
    pass