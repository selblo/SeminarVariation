#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Utitlities to plot using OST style guide.

Defines colors, color cyclers, colormaps and other plotting utilities.
"""
import os
from pathlib import Path

import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
from cycler import cycler

EPSILON = 1e-6
colors = {
    "black": "#191919",
    "blackberry": "#8c195f",
    "raspberry": "#d72864",
    "light pink": "#f087b0",
    "grey": "#878786",
    "light grey": "#c6c6c5",
    "dark red": "#c32e15",
    "red": "#e84d0e",
    "light red": "#f39a8b",
    "dark orange": "#d18e00",
    "orange": "#fbb900",
    "light orange": "#fcd6ae",
    "dark green": "#007e6b",
    "green": "#1cae8d",
    "light green": "#a7d5c2",
    "dark blue": "#0072af",
    "blue": "#0085cd",
    "light blue": "#5fbfed",
    "dark purple": "#6b3881",
    "purple": "#945fa4",
    "light purple": "#d0a9d0",
}

cyclers = {
    k: cycler(color=c)
    for k, c in {
        "short": [
            colors["dark purple"],
            colors["dark green"],
            colors["dark red"],
            colors["dark blue"],
            colors["dark orange"],
            colors["grey"],
        ],
        "default": [
            colors["dark purple"],
            colors["light purple"],
            colors["dark green"],
            colors["light green"],
            colors["dark red"],
            colors["light red"],
            colors["dark blue"],
            colors["light blue"],
            colors["dark orange"],
            colors["light orange"],
        ],
        "long": [
            colors["dark purple"],
            colors["purple"],
            colors["light purple"],
            colors["dark green"],
            colors["green"],
            colors["light green"],
            colors["dark red"],
            colors["red"],
            colors["light red"],
            colors["dark blue"],
            colors["blue"],
            colors["light blue"],
            colors["dark orange"],
            colors["orange"],
            colors["light orange"],
            colors["grey"],
            colors["light grey"],
        ],
    }.items()
}

cmaps = {
    k: mpl.colors.LinearSegmentedColormap.from_list(f"ost_{k}", c)
    for k, c in {
        "default": [
            [0.0, colors["black"]],
            [0.2, colors["blackberry"]],
            [0.5, colors["raspberry"]],
            [0.8, colors["orange"]],
            [1.0, colors["light orange"]],
        ],
        "light": [
            [0.0, colors["black"]],
            [0.2, colors["blackberry"]],
            [0.5, colors["raspberry"]],
            [1.0, colors["light orange"]],
        ],
        "dark": [
            [0.0, colors["black"]],
            [0.2, colors["blackberry"]],
            [0.5, colors["raspberry"]],
            [1.0, colors["orange"]],
        ],
    }.items()
}


def ost_style(cycler="default"):
    """Decorator to create plots following the OST style guide.

    Initializees OST style and creates a PDF in the corresponding 'image' folder.
    Decorated functions have to return the path to the script, the figure and
    axes object(s).

    Args:
        cycler (str, optional): Color cylcer used. Possible values are "short", "default",
            "long". Defaults to "default".
    """

    def dec(func):
        def wrapper(*args, **kwargs):
            # Set OST style
            init_style()
            if cycler == "short":
                use_short_cycler()
            elif cycler == "long":
                use_long_cycler()

            # Call decorated function
            file, fig, ax = func(*args, **kwargs)

            # Create image folder if it doesn't exist
            root = str(Path(file).parent)
            output_folder = f"{root}/../images"
            os.makedirs(output_folder, exist_ok=True)

            # Save the plot as PDF
            img_path = f"{output_folder}/{Path(file).stem}.pdf"
            fig.savefig(img_path)
            return fig, ax

        return wrapper

    return dec


def init_style():
    """Initialize OST style.

    Loads the right Latex packages, sets the default color cycler and
    registers the OST colormaps.

    OST colormaps can be accessed like any other matplotlib cmaps.
    Values are "ost_default", "ost_light", "ost_dark".
    """
    plt.rcParams["text.usetex"] = True
    plt.rcParams["text.latex.preamble"] = r"\usepackage{lmodern}"
    plt.rc("axes", prop_cycle=cyclers["default"])
    plt.rc("image", cmap="ost_default")
    _cmaps = plt.colormaps()
    for v in cmaps.values():
        if v.name not in _cmaps:
            plt.register_cmap(cmap=v)


def use_short_cycler():
    """Use the color cycler with less colors, but more contrast."""
    plt.rc("axes", prop_cycle=cyclers["short"])


def use_default_cycler():
    """Use the default color cycler."""
    plt.rc("axes", prop_cycle=cyclers["default"])


def use_long_cycler():
    """Use the color cycler with more colors, but less contrast."""
    plt.rc("axes", prop_cycle=cyclers["long"])


def _get_ticks(start, end, step=1):
    ticks = np.arange(step * (start // step), end + EPSILON, step)
    return ticks[ticks != 0]


def create_arrow_axis(
    x_step,
    y_step,
    xlim,
    ylim,
    ax=None,
    xlabel="$x$",
    ylabel="$y$",
    head_length=1.0,
    head_width=0.6,
    x_stop=False,
    y_stop=False,
    axisbelow=False,
):
    """Create a axis with arrows which go trough 0.

    Args:
        x_step (float): Step size of x ticks
        y_step (float): Step size of y ticks
        xlim ((float, float)): Limits of x axis
        ylim ((float, float)): Limits of y axis
        ax (plt.Axes, optional): Axes in which to plot in. Defaults to None.
        xlabel (str, optional): Label of x axis. Defaults to "$x$".
        ylabel (str, optional): Label of y axis. Defaults to "$y$".
        head_length (float, optional): Length of arrow head. Defaults to 1.0.
        head_width (float, optional): Width of arrow head. Defaults to 0.6.
        x_stop (bool, optional): Stop x axis at 0.
            Overwrites xlim smaller then 0 if True. Defaults to False.
        y_stop (bool, optional): Stop y axis at 0.
            Overwrites ylim smaller then 0 if True. Defaults to False.
        axisbelow (bool, optional): Draw axis below plotted lines. Defaults to False.
    """
    if ax is None:
        ax = plt.gca()

    arrowprops = {
        "arrowstyle": f"-|>,head_length={head_length},head_width={head_width/2}",
        "shrinkA": 0,
        "shrinkB": 0,
        "facecolor": "black",
        "linewidth": 0,
    }

    dx = xlim[1] - xlim[0]
    dy = ylim[1] - ylim[0]

    ax.set_axisbelow(axisbelow)
    ax.tick_params(direction="inout")
    ax.set_xticks(_get_ticks(*xlim, x_step))
    ax.set_xlim(*xlim)
    ax.xaxis.set_label_coords(1.01 * dx + xlim[0], -0.01 * dy, ax.transData)
    ax.set_xlabel(xlabel, ha="left", va="top", fontsize="large")

    ax.set_yticks(_get_ticks(*ylim, y_step))
    ax.set_ylim(*ylim)
    ax.yaxis.set_label_coords(-0.01 * dx, 1.01 * dy + ylim[0], ax.transData)
    ax.set_ylabel(ylabel, rotation=0, ha="right", va="bottom", fontsize="large")

    ax.spines[["left", "bottom"]].set_position("zero")
    ax.spines[["left", "bottom"]].set_zorder((1 - axisbelow) * 2)
    ax.spines[["right", "top"]].set_visible(False)
    ax.xaxis.set_ticks_position("bottom")
    ax.spines["bottom"].set_bounds(xlim[0] * (not x_stop), xlim[1] - 0.01 * dx)
    ax.spines["left"].set_bounds(ylim[0] * (not y_stop), ylim[1] - 0.01 * dy)

    ax.annotate(
        " ",
        (1.01 * dx + xlim[0], 0),
        xytext=[xlim[0], 0],
        arrowprops=arrowprops,
        ha="right",
        va="center",
        annotation_clip=False,
    )
    ax.annotate(
        " ",
        (0, 1.01 * dy + ylim[0]),
        xytext=[0, ylim[0]],
        arrowprops=arrowprops,
        ha="center",
        va="top",
        annotation_clip=False,
    )


if __name__ == "__main__":
    import scipy.special as ss

    init_style()

    x = np.linspace(0, 1, 101)

    # Demo of cyclers
    _, axs = plt.subplots(3, 1, sharex=True, sharey=True, constrained_layout=True)
    for i, (ax, name) in enumerate(
        zip(
            axs,
            ["short", "default", "long"],
        )
    ):
        ax.set_prop_cycle(cyclers[name])
        N = len(cyclers[name])
        step = 1 / (N + 1)
        y = 0 * x[:, None] + np.arange(step, 1 - step / 2, step)
        ax.plot(x, y, linewidth=4)
        ax.grid(1)
        ax.set_ylabel(f"{name.capitalize()} Cycler")
    axs[0].set_xlim(0, 1)
    axs[0].set_ylim(0, 1)

    # Demo of colormaps
    img = x[None] + 0 * x[:, None]
    # img = 1 - np.clip(4 * (np.abs(x - 0.5) ** 2 + np.abs(x.T - 0.5) ** 2), 0, 1)
    fig2, axs2 = plt.subplots(
        1, len(cmaps), sharex=True, sharey=True, constrained_layout=True, num=2
    )
    for ax, name in zip(axs2, cmaps.keys()):
        ax.set_title(f"{name.capitalize()} Colormap")
        mp = ax.imshow(img, cmap=plt.get_cmap(f"ost_{name}"))
        fig2.colorbar(mp, ax=ax)

    # Demo of arrow axis
    N = 401
    xlim = (-5.3, 5.3)
    xstep = 1
    ylim = (-0.9, 0.9)
    ystep = 0.5
    figsize = (5.9, 2)
    x = np.linspace(*xlim, N)
    C, S = ss.fresnel(x)
    use_short_cycler()
    fig3, ax3 = plt.subplots(
        num=3, clear=True, constrained_layout=True, figsize=figsize
    )
    ax3.plot(x, S, label="$S(x)$")
    ax3.plot(x, C, label="$C(x)$")
    create_arrow_axis(xstep, ystep, xlim, ylim, ax3)
    ax3.legend(labelcolor="linecolor", edgecolor="w")
    plt.show()
