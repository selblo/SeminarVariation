import os

try:
    import dolfinx
    from petsc4py import PETSc

    # if not dolfinx.has_petsc:
    #     print("This demo requires DOLFINx to be compiled with PETSc enabled.")
    #     exit(0)
except ModuleNotFoundError:
    print("This demo requires petsc4py.")
    exit(0)

import numpy as np
import ufl
from basix.ufl import element, mixed_element
from dolfinx import default_real_type, log, plot
from dolfinx.fem import Function, functionspace
from dolfinx.fem.petsc import NonlinearProblem
from dolfinx.io import XDMFFile
from dolfinx.mesh import CellType, create_unit_square
from dolfinx.nls.petsc import NewtonSolver
from mpi4py import MPI
from ufl import dx, grad, inner

try:
    import pyvista as pv
    import pyvistaqt as pvqt

    have_pyvista = True
    if pv.OFF_SCREEN:
        pv.start_xvfb(wait=0.5)
except ModuleNotFoundError:
    print("pyvista and pyvistaqt are required to visualise the solution")
    have_pyvista = False

# Save all logging to file
log.set_output_file("log.txt")
# -

# Next, various model parameters are defined:

lmbda = 1.0e-02  # surface parameter
dt = 5.0e-06  # time step
theta = 0.5  # time stepping family, e.g. theta=1 -> backward Euler, theta=0.5 -> Crank-Nicholson

# A unit square mesh with 96 cells edges in each direction is created,
# and on this mesh a
# {py:class}`FunctionSpace <dolfinx.fem.FunctionSpace>` `ME` is built
# using a pair of linear Lagrange elements.

msh = create_unit_square(MPI.COMM_WORLD, 96, 96, CellType.triangle)
P1 = element("Lagrange", msh.basix_cell(), 1, dtype=default_real_type)
ME = functionspace(msh, mixed_element([P1, P1]))

# Trial and test functions of the space `ME` are now defined:

q, v = ufl.TestFunctions(ME)

# ```{index} split functions
# ```
#
# For the test functions, {py:func}`TestFunctions<function
# ufl.argument.TestFunctions>` (note the 's' at the end) is used to
# define the scalar test functions `q` and `v`. Some mixed objects of
# the {py:class}`Function<dolfinx.fem.function.Function>` class on `ME`
# are defined to represent $u = (c_{n+1}, \mu_{n+1})$ and $u0 = (c_{n},
# \mu_{n})$, and these are then split into sub-functions:

# +
u = Function(ME)  # current solution
u0 = Function(ME)  # solution from previous converged step

# Split mixed functions
c, mu = ufl.split(u)
c0, mu0 = ufl.split(u0)
# -

# The line `c, mu = ufl.split(u)` permits direct access to the
# components of a mixed function. Note that `c` and `mu` are references
# for components of `u`, and not copies.
#
# ```{index} single: interpolating functions; (in Cahn-Hilliard demo)
# ```
#
# The initial conditions are interpolated into a finite element space:

# +
# Zero u
u.x.array[:] = 0.0

# Interpolate initial condition
rng = np.random.default_rng(42)
u.sub(0).interpolate(lambda x: 0.63 + 0.02 * (0.5 - rng.random(x.shape[1])))
u.x.scatter_forward()
# -

# The first line creates an object of type `InitialConditions`.  The
# following two lines make `u` and `u0` interpolants of `u_init` (since
# `u` and `u0` are finite element functions, they may not be able to
# represent a given function exactly, but the function can be
# approximated by interpolating it in a finite element space).
#
# ```{index} automatic differentiation
# ```
#
# The chemical potential $df/dc$ is computed using UFL automatic
# differentiation:

# Compute the chemical potential df/dc
c = ufl.variable(c)
f = 100 * c**2 * (1 - c) ** 2
dfdc = ufl.diff(f, c)

# The first line declares that `c` is a variable that some function can
# be differentiated with respect to. The next line is the function $f$
# defined in the problem statement, and the third line performs the
# differentiation of `f` with respect to the variable `c`.
#
# It is convenient to introduce an expression for $\mu_{n+\theta}$:

# mu_(n+theta)
mu_mid = (1.0 - theta) * mu0 + theta * mu

# which is then used in the definition of the variational forms:

# Weak statement of the equations
F0 = inner(c, q) * dx - inner(c0, q) * dx + dt * inner(grad(mu_mid), grad(q)) * dx
F1 = inner(mu, v) * dx - inner(dfdc, v) * dx - lmbda * inner(grad(c), grad(v)) * dx
F = F0 + F1

# This is a statement of the time-discrete equations presented as part
# of the problem statement, using UFL syntax.
#
# ```{index} single: Newton solver; (in Cahn-Hilliard demo)
# ```
#
# The DOLFINx Newton solver requires a
# {py:class}`NonlinearProblem<dolfinx.fem.NonlinearProblem>` object to
# solve a system of nonlinear equations

# +
# Create nonlinear problem and Newton solver
problem = NonlinearProblem(F, u)
solver = NewtonSolver(MPI.COMM_WORLD, problem)
solver.convergence_criterion = "incremental"
solver.rtol = np.sqrt(np.finfo(default_real_type).eps) * 1e-2

# We can customize the linear solver used inside the NewtonSolver by
# modifying the PETSc options
ksp = solver.krylov_solver
opts = PETSc.Options()  # type: ignore
option_prefix = ksp.getOptionsPrefix()
opts[f"{option_prefix}ksp_type"] = "preonly"
opts[f"{option_prefix}pc_type"] = "lu"
sys = PETSc.Sys()  # type: ignore
# For factorisation prefer superlu_dist, then MUMPS, then default
if sys.hasExternalPackage("superlu_dist"):
    opts[f"{option_prefix}pc_factor_mat_solver_type"] = "superlu_dist"
elif sys.hasExternalPackage("mumps"):
    opts[f"{option_prefix}pc_factor_mat_solver_type"] = "mumps"
ksp.setFromOptions()
# -

# The setting of `convergence_criterion` to `"incremental"` specifies
# that the Newton solver should compute a norm of the solution increment
# to check for convergence (the other possibility is to use
# `"residual"`, or to provide a user-defined check). The tolerance for
# convergence is specified by `rtol`.
#
# To run the solver and save the output to a VTK file for later
# visualization, the solver is advanced in time from $t_{n}$ to
# $t_{n+1}$ until a terminal time $T$ is reached:

# +
# Output file
file = XDMFFile(MPI.COMM_WORLD, "demo_ch/output.xdmf", "w")
file.write_mesh(msh)

# Step in time
t = 0.0

#  Reduce run time if on test (CI) server
if "CI" in os.environ.keys() or "GITHUB_ACTIONS" in os.environ.keys():
    T = 3 * dt
else:
    T = 1000 * dt

# Get the sub-space for c and the corresponding dofs in the mixed space
# vector
V0, dofs = ME.sub(0).collapse()

# Prepare viewer for plotting the solution during the computation
if have_pyvista:
    # Create a VTK 'mesh' with 'nodes' at the function dofs
    topology, cell_types, x = plot.vtk_mesh(V0)
    grid = pv.UnstructuredGrid(topology, cell_types, x)

    # Set output data
    grid.point_data["c"] = u.x.array[dofs].real
    grid.set_active_scalars("c")

    p = pvqt.BackgroundPlotter(title="concentration", auto_update=True)
    p.add_mesh(grid, clim=[0, 1])
    p.view_xy(True)
    p.add_text(f"time: {t}", font_size=12, name="timelabel")
    p.save_graphic("demo_ch/0.pdf")

c = u.sub(0)
u0.x.array[:] = u.x.array
i = 0
while t < T:
    t += dt
    r = solver.solve(u)
    print(f"Step {i}: num iterations: {r[0]}")
    u0.x.array[:] = u.x.array
    file.write_function(c, t)

    # Update the plot window
    if have_pyvista:
        p.add_text(f"time: {t:.2e}", font_size=12, name="timelabel")
        grid.point_data["c"] = u.x.array[dofs].real
        p.app.processEvents()
    i += 1
    if (i % 5) == 0:
        p.save_graphic(f"demo_ch/{i}.pdf")

file.close()

# Update ghost entries and plot
if have_pyvista:
    u.x.scatter_forward()
    grid.point_data["c"] = u.x.array[dofs].real
    screenshot = None
    if pv.OFF_SCREEN:
        screenshot = "c.png"
    pv.plot(grid, show_edges=True, screenshot=screenshot)
