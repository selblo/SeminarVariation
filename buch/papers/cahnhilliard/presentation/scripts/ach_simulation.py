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
from dolfinx.fem import (
    Constant,
    Function,
    functionspace,
)
from dolfinx.fem.petsc import (
    NonlinearProblem,
)
from dolfinx.io import XDMFFile
from dolfinx.mesh import (
    CellType,
    create_unit_square,
)
from dolfinx.nls.petsc import NewtonSolver
from mpi4py import MPI
from ufl import dot, dx, grad, inner

try:
    import pyvista as pv
    import pyvistaqt as pvqt

    have_pyvista = True
    if pv.OFF_SCREEN:
        pv.start_xvfb(wait=0.5)
except ModuleNotFoundError:
    print("pyvista and pyvistaqt are required to visualise the solution")
    have_pyvista = False

dt = 5.0e-04  # time step
theta = 0.5  # time stepping family, e.g. theta=1 -> backward Euler, theta=0.5 -> Crank-Nicholson


def periodic_boundary_condition(x, alpha):
    shift = np.random.uniform(0, 2 * np.pi)
    return alpha * np.sin(2 * np.pi * x + shift)


class RandomStirringField:
    def __init__(self, alpha: float):
        self._alpha = alpha

    def __call__(self, x):
        v = np.zeros((2, x.shape[1]))
        v[0] = periodic_boundary_condition(x[1], self._alpha)
        v[1] = periodic_boundary_condition(x[0], self._alpha)
        return v


class AlternatingStirringField(RandomStirringField):
    def __init__(self, alpha: float):
        super().__init__(alpha)
        self._i = 0
        self._j = 1

    def _swap(self):
        j = self._j
        self._j = self._i
        self._i = j

    def __call__(self, x):
        v = np.zeros((2, x.shape[1]))
        v[self._i] = np.sqrt(2) * periodic_boundary_condition(x[self._j], self._alpha)
        self._swap()
        return v


def advective_cahnhilliard(path, lmbda=1e-2, alpha=1.0):
    log.set_output_file("log.txt")

    msh = create_unit_square(MPI.COMM_WORLD, 96, 96, CellType.triangle)
    P1 = element("Lagrange", msh.basix_cell(), 1, dtype=default_real_type)
    PV1 = element(
        "Lagrange", msh.basix_cell(), 1, dtype=default_real_type, shape=(msh.geometry.dim,)
    )
    V2 = functionspace(msh, PV1)
    ME = functionspace(msh, mixed_element([P1, P1]))
    V0, dofs0 = ME.sub(0).collapse()

    # Trial and test functions of the space `ME` are now defined:
    dt_ = Constant(msh, dt)

    p, q = ufl.TestFunctions(ME)

    u = Function(ME)  # current solution
    u0 = Function(ME)  # solution from previous converged step

    # Split mixed functions
    c, mu = ufl.split(u)
    c0, mu0 = ufl.split(u0)
    v = Function(V2)

    # Zero u
    u.x.array[:] = 0.0

    # Interpolate initial condition
    np.random.seed(42)
    radius = np.sqrt(1 / (3 * np.pi))
    u.sub(0).interpolate(
        lambda x: (np.sqrt((x[0] - 0.5) ** 2 + (x[1] - 0.5) ** 2) < radius).astype(float)
    )

    u.x.scatter_forward()

    # Compute the chemical potential df/dc
    c_var = ufl.variable(c)
    # f = 100 * c_var**2 * (1 - c_var) ** 2
    f = 0.5 * c_var**2 * (c_var - 1) ** 2
    dfdc = ufl.diff(f, c_var)

    mu_mid = (1.0 - theta) * mu0 + theta * mu

    # Weak statement of the equations
    F0 = (
        inner(c, p) * dx
        - inner(c0, p) * dx
        + dt_ * dot(v, grad(c)) * p * dx
        + dt_ * inner(grad(mu_mid), grad(p)) * dx
    )
    F1 = inner(mu, q) * dx - inner(dfdc, q) * dx - lmbda * inner(grad(c), grad(q)) * dx
    F = F0 + F1  # + F2

    vel_field = RandomStirringField(alpha)
    # vel_field = AlternatingStirringField(alpha)
    v.x.array[:] = 0
    v.x.scatter_forward()

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

    # Output file
    file = XDMFFile(MPI.COMM_WORLD, f"{path}/output.xdmf", "w")
    file.write_mesh(msh)

    # Step in time
    t = 0.0
    t_end = 1000 * dt

    # Prepare viewer for plotting the solution during the computation
    if have_pyvista:
        # Create a VTK 'mesh' with 'nodes' at the function dofs
        topology, cell_types, x = plot.vtk_mesh(V0)
        pv.global_theme.cmap = "plasma"
        grid = pv.UnstructuredGrid(topology, cell_types, x)

        # Set output data
        grid.point_data["c"] = u.x.array[dofs0].real
        grid.set_active_scalars("c")

        plotter = pvqt.BackgroundPlotter(title="concentration", auto_update=True)
        plotter.add_mesh(grid, clim=[0, 1])
        plotter.view_xy(True)
        plotter.add_text(f"time: {t}", font_size=12, name="timelabel")
        plotter.save_graphic(f"{path}/0.pdf")

    c = u.sub(0)
    mu = u.sub(1)
    u0.x.array[:] = u.x.array
    i = 0
    file.write_function(c, t)
    file.write_function(mu, t)
    file.write_function(v, t)
    while t < t_end:
        t += dt_.value
        v.interpolate(vel_field)
        v.x.scatter_forward()

        try:
            r = solver.solve(c)
        except RuntimeError:
            t -= dt_.value
            dt_.value *= 0.5
            vel_field._alpha *= 2
            continue

        print(f"Step {i}: num iterations: {r[0]}")
        u0.x.array[:] = u.x.array
        file.write_function(c, t)
        file.write_function(mu, t)
        file.write_function(v, t)

        # Update the plot window
        if have_pyvista:
            plotter.add_text(f"time: {t:.2e}", font_size=12, name="timelabel")
            grid.point_data["c"] = u.x.array[dofs0].real
            plotter.app.processEvents()
        i += 1
        if (i % 5) == 0:
            plotter.save_graphic(f"{path}/{i}.pdf")

    file.close()


if __name__ == "__main__":
    # try with 25, 40, 50, 200
    alpha = 25

    advective_cahnhilliard("stirring", 1e-2 / 800, alpha)
