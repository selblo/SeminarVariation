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

dt = 5.0e-06  # time step
theta = 0.5  # time stepping family, e.g. theta=1 -> backward Euler, theta=0.5 -> Crank-Nicholson


def no_grad(path):
    log.set_output_file("log.txt")
    dt = 10e-9

    n_elem = 96
    msh = create_unit_square(MPI.COMM_WORLD, n_elem, n_elem, CellType.triangle)
    V = functionspace(msh, ("Lagrange", 1))

    dt_ = Constant(msh, dt)
    q = ufl.TestFunction(V)

    c = Function(V)  # current solution
    c0 = Function(V)  # solution from previous converged step

    # Zero u
    c.x.array[:] = 0.0

    # Interpolate initial condition
    rng = np.random.default_rng(42)
    c.interpolate(lambda x: 0.63 + 0.02 * (0.5 - rng.random(x.shape[1])))
    c.x.scatter_forward()

    # Compute the chemical potential df/dc
    c_var = ufl.variable(c)
    f = 100 * c_var**2 * (1 - c_var) ** 2
    dfdc = ufl.diff(f, c_var)

    # which is then used in the definition of the variational forms:

    # Weak statement of the equations
    F = inner(c, q) * dx - inner(c0, q) * dx + dt_ * inner(grad(dfdc), grad(q)) * dx

    # Create nonlinear problem and Newton solver
    problem = NonlinearProblem(F, c)
    solver = NewtonSolver(MPI.COMM_WORLD, problem)
    solver.convergence_criterion = "incremental"
    solver.rtol = np.sqrt(np.finfo(default_real_type).eps) * 1e-2
    solver.max_it = 35

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
    T = 1e0

    # Prepare viewer for plotting the solution during the computation
    if have_pyvista:
        # Create a VTK 'mesh' with 'nodes' at the function dofs
        topology, cell_types, x = plot.vtk_mesh(V)
        grid = pv.UnstructuredGrid(topology, cell_types, x)

        # Set output data
        grid.point_data["c"] = c.x.array.real
        grid.set_active_scalars("c")

        p = pvqt.BackgroundPlotter(title="concentration", auto_update=True)
        p.add_mesh(grid, clim=[0, 1])
        p.view_xy(True)
        p.add_text(f"time: {t}", font_size=12, name="timelabel")
        p.save_graphic(f"{path}/0.pdf")

    c0.x.array[:] = c.x.array
    i = 0
    while t < T:
        t += dt_.value
        try:
            r = solver.solve(c)
        except RuntimeError:
            t -= dt_.value
            dt_.value *= 0.5
            continue

        print(f"Step {i}: num iterations: {r[0]}")
        c0.x.array[:] = c.x.array
        # file.write_function(c, t)

        # Update the plot window
        if have_pyvista:
            p.add_text(f"time: {t:.2e}", font_size=12, name="timelabel")
            grid.point_data["c"] = c.x.array.real
            p.app.processEvents()
        i += 1
        if (i % 10) == 0:
            period = int(t // dt)
            p.save_graphic(f"{path}/{period}.pdf")
            dt_.value *= 1.5

    file.close()


def cahnhilliard(path, lmbda=1e-2):
    log.set_output_file("log.txt")

    msh = create_unit_square(MPI.COMM_WORLD, 96, 96, CellType.triangle)
    P1 = element("Lagrange", msh.basix_cell(), 1, dtype=default_real_type)
    ME = functionspace(msh, mixed_element([P1, P1]))

    # Trial and test functions of the space `ME` are now defined:
    dt_ = Constant(msh, dt)

    q, v = ufl.TestFunctions(ME)

    u = Function(ME)  # current solution
    u0 = Function(ME)  # solution from previous converged step

    # Split mixed functions
    c, mu = ufl.split(u)
    c0, mu0 = ufl.split(u0)

    # Zero u
    u.x.array[:] = 0.0

    # Interpolate initial condition
    rng = np.random.default_rng(42)
    u.sub(0).interpolate(lambda x: 0.66 + 0.02 * (0.5 - rng.random(x.shape[1])))
    u.x.scatter_forward()

    # Compute the chemical potential df/dc
    c_var = ufl.variable(c)
    f = 100 * c_var**2 * (1 - c_var) ** 2
    dfdc = ufl.diff(f, c_var)

    # mu_(n+theta)
    mu_mid = (1.0 - theta) * mu0 + theta * mu

    # which is then used in the definition of the variational forms:

    # Weak statement of the equations
    F0 = inner(c, q) * dx - inner(c0, q) * dx + dt_ * inner(grad(mu_mid), grad(q)) * dx
    F1 = inner(mu, v) * dx - inner(dfdc, v) * dx - lmbda * inner(grad(c), grad(v)) * dx
    F = F0 + F1

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

    # Output file
    file = XDMFFile(MPI.COMM_WORLD, f"{path}/output.xdmf", "w")
    file.write_mesh(msh)

    # Step in time
    t = 0.0
    T = 1e0

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
        p.save_graphic(f"{path}/0.pdf")

    c = u.sub(0)
    u0.x.array[:] = u.x.array
    i = 0
    while t < T:
        t += dt_.value
        try:
            r = solver.solve(u)
        except RuntimeError:
            t -= dt_.value
            dt_.value *= 0.5
            continue
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
            period = int(t // dt)
            p.save_graphic(f"{path}/{period}.pdf")
        if (i % 10) == 0:
            dt_.value *= 1.5

    file.close()


if __name__ == "__main__":
    pv.global_theme.cmap = "plasma"
    # no_grad("no_grad")
    cahnhilliard("demo_ch", 1e-2)
