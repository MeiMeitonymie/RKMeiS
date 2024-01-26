from __future__ import annotations
import os
import numpy as np

from rkms.model import M1
from rkms.solver import FVTimeMode
from rkms.common import pprint_dict

from astro import AstroFVSolverCL


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


if __name__ == "__main__":
    # Physical dimension of PN approximation
    dim = 3
    mesh_file = "unit_cube_nx65_ny65_nz65.msh"

    # Build PN Model

    m = M1(
        dim,
        cl_src_file="./cl/m1/main_beam.cl",
        cl_include_dirs=["./cl/m1"],
        cl_build_opts=["-cl-fast-relaxed-math"],
        # Values injected in "./cl/m1/main_beam.cl"
        cl_replace_map={},
	)


    # Build solver
    s = AstroFVSolverCL(
        filename=mesh_file,
        model=m,
        time_mode=FVTimeMode.FORCE_ITERMAX_FROM_CFL,
        tmax=None,
        cfl=0.9,
        dt=None,
        iter_max=400,
        use_muscl=False,
        export_idx=[0, 1, 2],
        export_frq=40,
        use_double=True,
    )

    # Run solver
    s.run()

