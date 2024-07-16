"""
Import the numpy library for numerical computations.
"""
import numpy as np
"""
Import the matplotlib.pyplot module from the matplotlib library for creating plots and visualizations.
"""
import matplotlib.pyplot as plt
"""
Import the numba library for just-in-time (JIT) compilation of Python code, which can significantly improve performance.
"""
import numba
"""
mpl_toolkits.mplot3d is a module from the matplotlib library that provides tools for creating 3D plots and visualizations.
"""
from mpl_toolkits.mplot3d import Axes3D
"""
matplotlib.cm is a module from the matplotlib library that provides a large set of colormaps for visualizing data in plots.
"""
from matplotlib import cm

from plotly.subplots import make_subplots
import plotly.graph_objects as go
import plotly.io as py


def potential_block(x, y):
    """
    Determine the potential value for a given (x, y) coordinate.

    Parameters:
    x (float): The x-coordinate.
    y (float): The y-coordinate.

    Returns:
    float: The potential value for the given (x, y) coordinate.
    """
    return np.select([(x>0.5)*(x<0.7)*(y>0.5)*(y<0.7),
                      (x<=0.5)+(x>=0.7)+(y<=0.5)+(y>=0.7)],
                     [1.,
                      0])
@numba.jit("f8[:,:](f8[:,:], b1[:,:], i8)", nopython=True, nogil=True)
def compute_potential(potential, fixed_bool, n_iter):
    """
    Compute the potential

    Parameters:
    - potential (numpy.ndarray): 2D array representing the potential.
    - fixed_bool (numpy.ndarray): 2D boolean array indicating fixed points.
    - n_iter (int): Number of iterations to perform.

    Returns:
    - potential (numpy.ndarray): Updated potential after performing the iterations.
    """
    length = len(potential[0])
    for n in range(n_iter):
        for i in range(1, length-1):
            for j in range(1, length-1):
                if not(fixed_bool[j][i]):
                    potential[j][i] = 1/4 * (potential[j+1][i] + potential[j-1][i] + potential[j][i+1] + potential[j][i-1])
    return potential
# define conductivity of the plate (siemens/m)
sigma = 0.001
# define size of plate in meters
width=1
height=1
# define number of grid points in one direction
n=300
# define grid points
x = np.linspace(0, width, n)
y = np.linspace(0, height, n)
# define potential at boundary points
upper_y = 0 * np.sin(x*np.pi)
lower_y = 0 * x
upper_x = 0 * y
lower_x = 0 * y
# create meshgrid for 2D potential xv are the x coordinates and yv are 
# the y coordinates at each point, for example xv[0,0] is the x coordinate
# of the first point and yv[0,0] is the y coordinate of the first point
xv, yv = np.meshgrid(x, y)
# create 2d array for potential
potential = np.zeros((n,n))
# set potential at boundary points
potential[0,:]= lower_y
potential[-1,:]= upper_y
potential[:,0]= lower_x
potential[:,-1]= upper_x
# set potential inside the mesh to a predefined value one
fixed = potential_block(xv,yv)
fixed_bool = fixed!=0
potential[fixed_bool] = fixed[fixed_bool]
# calculate potential with numberical method and make n_iter iterations
potential = compute_potential(potential,fixed_bool, n_iter=30000)
# create a plot of the potential
fig, ax = plt.subplots(1, 1, figsize=(8,6))
clr_plot = ax.contourf(xv, yv, potential, 30)
ax.set_xlabel('x-direction [m]')
ax.set_ylabel('y-direction [m]')
fig.colorbar(clr_plot, label='$Voltage [V]$')
ax.set_title('Potential distribution in the plate')
# plt.show()
# safe plot with high resolution
fig.savefig('potential_distribution.png', dpi=600)
# Calculate the power of the field
Ex, Ey = np.gradient(-potential)
#Calculate the power dissipated in the plate (there is a small error since at the boundary the areas is not 1/(width*n*height*n), but I neglect that here)
gradient=np.gradient(potential)
power_per_point=(np.square(gradient[0])+np.square(gradient[1]))*sigma
power_per_square=power_per_point/((width/n)*(height/n))
power=power_per_point.sum()
print(f"Power is: {power.sum()*1000}mW")
# fig = make_subplots(rows=1, cols=2)
# fig = go.Figure(data=[go.Surface(z=potential, x=xv, y=yv)])
# fig.update_layout(title='Potential distribution in the plate (Voltage [V])',
#                   scene = dict(
#                     xaxis_title='x-direction [m]',
#                     yaxis_title='y-direction [m]',
#                     zaxis_title='Potential',
#                     aspectratio = dict(x=1, y=1, z=1),
#                     aspectmode = 'manual'
#                   ),width=800, height=600)
# fig.show()
# safe plot as image


from plotly.subplots import make_subplots
import plotly.graph_objects as go
import plotly.io as py  # Import the required module

fig = make_subplots(rows=1, cols=2)
fig = go.Figure(data=[go.Surface(z=potential, x=xv, y=yv)])
fig.update_layout(title='Potential distribution in the plate (Voltage [V])',
                  scene = dict(
                    xaxis_title='x-direction [m]',
                    yaxis_title='y-direction [m]',
                    zaxis_title='Potential',
                    aspectratio = dict(x=1, y=1, z=1),
                    aspectmode = 'manual'
                  ),width=800, height=600)

# Save the figure as a png image. You can replace 'my_figure.png' with your preferred file path and name.
py.write_image(fig, 'my_figure.png')

fig.show()