import numpy as np
import matplotlib.pyplot as plt
import scipy.constants as const

# Enable LaTeX text rendering
plt.rcParams.update({
    "text.usetex": True,                # Use LaTeX for all text rendering
    "font.family": "serif",             # Use a serif font (Times)
    "font.serif": "Times",              # Match the Times font in TikZ
    "mathtext.fontset": "cm",           # Set math fonts to Computer Modern (like LaTeX)
    "axes.labelsize": 14,               # Size of the labels
    "xtick.labelsize": 10,              # Size of the tick labels
    "ytick.labelsize": 10,              # Size of the tick labels
    "grid.alpha": 0.5,                  # Set grid transparency
    "axes.grid": True,                  # Enable grid
    "grid.linestyle": "--",             # Dashed grid lines (as in pgfplots)
    "grid.color": "gray",               # Light gray grid
    "lines.linewidth": 1.4,             # Match line width to TikZ
})

# Parameters
t = np.linspace(0, 12, 1000)  # Time vector

# Function to calculate velocity vx(t) for a given beta
def calculate_vx(beta, E_x, t):
    K_1 = beta * const.c / np.sqrt(1 - beta**2)
    zaehler = -const.e * E_x * t / const.m_e + K_1
    vx = zaehler / np.sqrt(1 + (zaehler / const.c)**2)
    return vx

# Calculate vx for two different beta values
vx_beta_00_1 = calculate_vx(0.0, -1e-3, t)
vx_beta_07_1 = calculate_vx(0.7, -1e-3, t)
vx_beta_00_05 = calculate_vx(0.0, -0.5e-3, t)

# Create the plot
fig, ax = plt.subplots(figsize=(6, 4))

# Plot the two graphs
ax.plot(t, vx_beta_00_1/const.c, label=r'$\beta_0 = 0.0$, $E_x=1\, \small\frac{\textrm{mV}}{\textrm{m}}$', color='blue')
ax.plot(t, vx_beta_00_05/const.c, label=r'$\beta_0 = 0.0$, $E_x=0.5\, \small\frac{\textrm{mV}}{\textrm{m}}$', color='red')
ax.plot(t, vx_beta_07_1/const.c, label=r'$\beta_0 = 0.7$, $E_x=1\, \small\frac{\textrm{mV}}{\textrm{m}}$', color='green')

# Set axis labels (with LaTeX math mode)
ax.set_xlabel(r"$t$ in s")
ax.set_ylabel(r"$\beta_x(t)$")

# Set axis limits
ax.set_ylim(0, 1)

# Add a legend
ax.legend(loc='lower right', fontsize=12)

# Customize ticks to look more like TikZ
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')
ax.tick_params(direction='in', which='both', width=1)

# Set tighter margins similar to TikZ
ax.margins(x=0, y=0.05)

# Add grid and set aesthetics
ax.grid(True)

# Save the plot as a PDF
plt.tight_layout()
plt.savefig("buch/papers/relativ/images/elektron_e-feld.pdf", format='pdf')

# Show the plot
plt.show()
