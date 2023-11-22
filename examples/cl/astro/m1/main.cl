#ifndef M1_CL
#define M1_CL

// KEEP DEFINE BELOW
// Solver injected values
#define NGRID  __NGRID__
#define M      __M__
#define DT     __DT__
#define DX     __DX__
#define DY     __DY__
#define DIM    __DIM__
#define C_WAVE __C_WAVE__
#if DIM == 2
#define IS_2D
#else
#undef IS_2D
#define DZ __DZ__
#endif
// KEEP DEFINE ABOVE

#include <solver/muscl_finite_volume.cl>

// Model injected values
#define SRC_X           __SRC_X__
#define SRC_Y           __SRC_Y__
#define SRC_Z           __SRC_Z__
#define SRC_VACCUM      __SRC_Z__

#define PHY_CST_KB      (1.380649e-23)
#define PHY_CST_ALPHA_I (2.493e-22)
#define PHY_SCALE_X     (2.03676e20)
#define PHY_SCALE_C     (299792458.)

#define PHY_DX          (PHY_SCALE_X * DX)
#define PHY_DY          (PHY_SCALE_X * DY)
#define PHY_DZ          (PHY_SCALE_X * DZ)
#define PHY_DT          (PHY_SCALE_X * DT / PHY_SCALE_C)

#include "numfluxes/m1.cl"
#include "sources/gaussian_line.cl"
#include "sources/stromgren_sphere.cl"
#include "../h_chemistry.cl"

void model_init_cond(const real_t t, const real_t x[DIM], real_t s[M])
{
    // m1_src_gaussian_line_source(t, x, s);
    m1_src_stromgren_sphere(t, x, s);
}

void model_src(const real_t t, const real_t x[DIM], const real_t wn[M],
               real_t s[M])
{
    // m1_src_gaussian_line_source(t, x, s);
    // m1_src_null(t, x, s);
    m1_src_stromgren_sphere(t, x, s);
}

void model_flux_num(const real_t wL[M], const real_t wR[M],
                    const real_t vn[DIM], real_t flux[M])
{
    m1_num_flux_rusanov(wL, wR, vn, flux);
}

void model_flux_num_bd(const real_t wL[M], const real_t wR[M],
                       const real_t vn[DIM], real_t flux[M])
{
    m1_num_flux_rusanov(wL, wL, vn, flux);
}

#endif