from __future__ import annotations

import os

import numpy as np
from astro import AstroFVSolverCL

from rkms.common import pprint_dict
from rkms.mesh import MeshStructured
from rkms.model import M1, PN
from rkms.solver import FVTimeMode

# Configure environment variables for controlling pyopencl and NVIDIA platform
# behaviors

# Disable caching in pyopencl
os.environ["PYOPENCL_NO_CACHE"] = "1"

# Enable compiler output in pyopencl
os.environ["PYOPENCL_COMPILER_OUTPUT"] = "1"

# Disable CUDA caching
os.environ["CUDA_CACHE_DISABLE"] = "1"

# Auto-select OpenCL platform #0
os.environ["PYOPENCL_CTX"] = "0"


def get_hmin(dim, dx, dy, dz):
    if dim == 2:
        cell_v = dx * dy
        cell_s = 2.0 * (dx + dy)

    else:
        cell_v = dx * dy * dz
        cell_s = 2.0 * (dx * dy + dy * dz + dz * dx)

    return cell_v / cell_s


def get_dim_coeff(
    dim, cfl, dx_adim, dy_adim, dz_adim, c_adim, x_phy_value, c_phy_value
):
    dx_adim = np.float64(dx_adim)
    dy_adim = np.float64(dy_adim)
    dz_adim = np.float64(dz_adim)

    x_phy_value = np.float64(x_phy_value)
    c_phy_value = np.float64(c_phy_value)

    
    dt_adim = (
        np.float64(cfl)
        * np.float64(get_hmin(dim, dx_adim, dy_adim, dz_adim))
        / np.float64(c_adim)
    )
    print("dt_adim ",dt_adim)

    dx_dim = dx_adim * x_phy_value
    dy_dim = dy_adim * x_phy_value
    dz_dim = dz_adim * x_phy_value
    dt_dim = dt_adim * x_phy_value / c_phy_value

    return dx_dim, dy_dim, dz_dim, dt_dim


if __name__ == "__main__":
    # Model
    use_m1 = True
    use_pn = False
    pn_order = 5

    # CFL
    cfl = 0.8

    # Build Mesh
    dim = 3
    mesh_nx = 64
    mesh_ny = 64
    mesh_nz = 64 if dim == 3 else 0

    mesh_file = f"unit_cube_nx{mesh_nx}_ny{mesh_ny}_nz{mesh_nz}.msh"

    # Dim values
    cdiv = 1000.0
    x_phy_value = 6.6 * 3.086e19 * 2 #*2
    c_phy_value = 3.0e8 / cdiv
    w_phy_value = 5.0e48 #emissivity

    # FILTERING
    """
    Filtering types:
    0 = no filtering
    1 = Lancos
    2 = Splines
    3 = Exp
    """
    sig_value = 0.16
    filter_type = 0

    dx_dim, dy_dim, dz_dim, dt_dim = get_dim_coeff(
        dim,
        cfl,
        dx_adim=1.0 / mesh_nx,
        dy_adim=1.0 / mesh_ny,
        dz_adim=1.0 / mesh_ny,
        c_adim=1.0,
        x_phy_value=x_phy_value,
        c_phy_value=c_phy_value,
    )

    iter = int(np.floor(w_phy_value / dt_dim))
    if mesh_nx%2==0:
        w0_rescale = dt_dim * w_phy_value / (2*dx_dim * 2*dy_dim * 2*dz_dim)
    else:
        w0_rescale = dt_dim * w_phy_value / (dx_dim * dy_dim * dz_dim)

    pprint_dict(
        {
            "Speed of light 'c'": c_phy_value,
            "Length 'x": x_phy_value,
            "Photon flux, 'w'": w_phy_value,
        },
        header_msg="PHYSICAL CONSTANTS",
    )

    pprint_dict(
        {
            "Photon density 'w0'": w0_rescale,
        },
        header_msg="RESCALING VALUES",
    )

    mesh = MeshStructured(
        filename=None,
        nx=mesh_nx,
        ny=mesh_ny,
        nz=mesh_nz,
        xmin=0.0,
        xmax=1.0,
        ymin=0.0,
        ymax=1.0,
        zmin=0.0,
        zmax=1.0,
        use_periodic_bd=False,
    )

    # Build M1 Model
    if use_m1:
        print("Using M1")
        m = M1(
            dim,
            cl_src_file="./cl/m1/main_stromgren_sphere.cl",
            cl_include_dirs=["./cl/m1"],
            cl_build_opts=["-cl-fast-relaxed-math"],
            # Values injected in "./cl/m1/main_stromgren_sphere.cl"
            cl_replace_map={
                "__PHY_C_DIM__": c_phy_value,
                "__PHY_DT_DIM__": dt_dim,
                "__PHY_W0_DIM__": w0_rescale,
            },
        )

    if use_pn:
        print("Using P"+str(pn_order))
        m = PN(
            pn_order,
            dim,
            cl_src_file="./cl/pn/main_stromgren_sphere.cl",
            cl_include_dirs=["./cl/pn"],
            cl_build_opts=[
                f"-D USE_SPHERICAL_HARMONICS_P{pn_order}",
                "-cl-fast-relaxed-math",
            ],
            # Values injected in "./cl/pn/main_stromgren_sphere.cl"
            cl_replace_map={
                "__PHY_C_DIM__": c_phy_value,
                "__PHY_DT_DIM__": dt_dim,
                "__PHY_W0_DIM__": w0_rescale,
                "__SIG__":sig_value,
                "__FILTER__":filter_type,
            },
        )

    #nb_iter=5000
    endt = 4*122.34e6 #*2#yrs
    nb_iter = int(endt*3600*24*365/dt_dim)
    if nb_iter>200:
        export_freq = int(nb_iter/40)
    else:
        export_freq=1

    s = AstroFVSolverCL(
        mesh=mesh,
        model=m,
        time_mode=FVTimeMode.FORCE_ITERMAX_FROM_CFL,
        tmax=None,
        cfl=cfl,
        dt=None,
        iter_max=nb_iter,
        use_muscl=False,
        export_idx=[0, 1, 2],
        export_frq=export_freq,
        use_double=True,
        use_chemistry=True,
    )

    print("Simulation time in years: ", (dt_dim*nb_iter)/(3600*24*365))
    print("Number of iterations :",nb_iter)
    print("Export frequency :",export_freq)
    print("Export frequency :",export_freq)
    if filter_type==0:
        print("No Filtering")
    else:
        print("Filtering coef: ",sig_value)
    # Run solver
    s.run()
