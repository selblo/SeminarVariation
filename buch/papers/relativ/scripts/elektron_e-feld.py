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

# Function to calculate velocity beta_x(t) for a given beta0
def calculate_betax(beta0, E_x, t):
    eta = - const.e * E_x / (const.c * const.m_e)
    K_1 = beta0 / np.sqrt(1 - beta0**2)
    betax = (eta * t + K_1) / np.sqrt(1 + (eta * t + K_1)**2)
    return betax

# Calculate vx for different beta0 and E_x values
vx_beta_00_1 = calculate_betax(0.0, -1e-3, t)
vx_beta_07_1 = calculate_betax(0.7, -1e-3, t)
vx_beta_00_05 = calculate_betax(0.0, -0.5e-3, t)

# Create the plot
fig, ax = plt.subplots(figsize=(6, 4))

# Plot the graphs
ax.plot(t, vx_beta_00_1, label=r'$\beta_0 = 0.0$, $E_x=1\, \small\frac{\textrm{mV}}{\textrm{m}}$', color='blue')
ax.plot(t, vx_beta_00_05, label=r'$\beta_0 = 0.0$, $E_x=0.5\, \small\frac{\textrm{mV}}{\textrm{m}}$', color='red')
ax.plot(t, vx_beta_07_1, label=r'$\beta_0 = 0.7$, $E_x=1\, \small\frac{\textrm{mV}}{\textrm{m}}$', color='green')

# Set axis labels
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
