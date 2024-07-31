import matplotlib.pyplot as plt
import matplotlib.ticker as tick
import numpy as np
import ost_plotting as ost


@ost.ost_style(cycler="short")
def plot():
    figsize = (5, 2.5)
    d = 0.15
    c = np.linspace(-d, 1 + d, 101)
    f1 = 10 * c**2 * (c - 1) ** 2
    f2 = 3.5 * (c - 0.5) ** 4

    fig, ax = plt.subplots(constrained_layout=True, figsize=figsize)
    ax.plot(c, f1, label="$T < T_{krit}$")
    ax.plot(c, f2, label="$T > T_{krit}$")
    ax.grid(1, "both", "both")
    ax.set_xlim(c[0], c[-1])
    ax.set_ylim(-0.01, np.max(np.concatenate([f1, f2]) + 0.025))
    ax.xaxis.set_minor_locator(tick.MultipleLocator(0.1))
    ax.xaxis.set_major_locator(tick.MultipleLocator(0.2))
    ax.yaxis.set_minor_locator(tick.MultipleLocator(0.1))
    ax.yaxis.set_major_locator(tick.MultipleLocator(0.2))
    ax.set_xlabel("$c$")
    ax.set_ylabel("$F(c)$")
    ax.legend(loc="upper right")
    return __file__, fig, ax


if __name__ == "__main__":
    plot()
    c = np.linspace(0, 1, 101)
    img = c[None] * c[:, None]
    fig, ax = plt.subplots(constrained_layout=True, figsize=(3.5, 2.5))
    plot = ax.imshow(img, cmap="viridis")
    fig.colorbar(plot, ax=ax)
    fig.savefig("ccb.png")
    # plt.show()
