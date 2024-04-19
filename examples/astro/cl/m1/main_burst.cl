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

#include "numfluxes/m1.cl"

// Add beam sources
#include "sources/src_burst.cl"

// Add chemistry module
#ifdef USE_CHEMISTRY
#include "../chemistry/hydrogen.cl"
#endif

void model_init_cond(const real_t t, const real_t x[DIM], real_t s[M])
{
    m1_src_burst(t, x, s);
}

void model_src(const real_t t, const real_t x[DIM], const real_t wn[M],
               real_t s[M])
{
    m1_src_burst(t, x, s);
}

void model_flux_num(const real_t wL[M], const real_t wR[M],
                    const real_t vn[DIM], real_t flux[M])
{
    m1_num_flux_rusanov(wL, wR, vn, flux);
}

void model_flux_num_bd(const real_t wL[M], const real_t wR[M],
                       const real_t vn[DIM], real_t flux[M])
{
    /*real_t w[M];
    
    for (int k = 0; k < M; k++) {
        w[k] = 1e-8F;
    }

    
    m1_num_flux_rusanov(wL, w, vn, flux);    */
    m1_num_flux_rusanov(wL, wL, vn, flux);
}

#endif
