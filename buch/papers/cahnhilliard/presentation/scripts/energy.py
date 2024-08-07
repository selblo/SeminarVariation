import pathlib

import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.ticker as tick
import numpy as np
import plotting


def _plot():
    figsize = (5, 2.5)
    d = 1e-12
    b = 0.1
    c = np.concatenate(
        [np.linspace(d, b, 21), np.linspace(b, 1 - b, 31), np.linspace(1 - b, 1 - d, 21)], axis=0
    )

    omega = 5.875
    r = 1
    thresh = omega / (2 * r)
    temp = np.array([0.7, 1, 1.2]) * thresh
    f = np.stack(
        [omega * c * (1 - c) + r * t * ((1 - c) * np.log(1 - c) + c * np.log(c)) for t in temp],
        axis=-1,
    )

    fig, ax = plt.subplots(constrained_layout=True, figsize=figsize)
    for fi, symbol in zip(f.T, ["<", "=", ">"]):
        ax.plot(c, fi, label=f"$T {symbol}" + r" T_\text{krit}$")
    ax.grid(1, "both", "both")
    ax.set_xlim(0, 1)
    min_f = np.min(f)
    max_f = np.max(f)
    df = max_f - min_f
    step = 0.025 * df
    ax.set_ylim(-1, max_f + step)
    ax.xaxis.set_minor_locator(tick.MultipleLocator(0.1))
    ax.xaxis.set_major_locator(tick.MultipleLocator(0.2))
    ax.yaxis.set_minor_locator(tick.MultipleLocator(0.1))
    ax.yaxis.set_major_locator(tick.MultipleLocator(0.5))
    ax.set_xlabel("$c$")
    ax.set_ylabel("$F(c)$")
    ax.legend(loc="lower right")
    return fig, ax


@plotting.ost_style(cycler="short")
def presentation():
    fig, ax = _plot()
    return __file__, fig, ax


@plotting.book_style()
def book():
    fig, ax = _plot()
    path = pathlib.Path(__file__).with_suffix(".book.pdf")
    return path, fig, ax


def _plot_colorbar(size):
    mpl.rcParams["figure.dpi"] = 300
    fig, axs = plt.subplots(
        1,
        3,
        constrained_layout=True,
        figsize=2 * (size,),
        gridspec_kw={"width_ratios": [0.5, 0.125, 0.375]},
    )
    norm = plt.Normalize(vmin=0, vmax=1)
    sm = plt.cm.ScalarMappable(cmap="plasma", norm=norm)
    sm.set_array([])
    fig.colorbar(sm, cax=axs[1], fraction=1.0, ticks=[0, 0.5, 1.0])
    for ax in axs[[0, 2]]:
        ax.axis("off")
    return fig


if __name__ == "__main__":
    presentation()
    book()

    # Save the colorbar as an image
    image_folder = pathlib.Path(__file__).parent.parent / "images"
    fig = _plot_colorbar(1.75)
    fig.savefig(image_folder / "colorbar.book.pdf")
    fig = _plot_colorbar(1.25)
    fig.savefig(image_folder / "colorbar.pdf")

    plt.close(fig)
