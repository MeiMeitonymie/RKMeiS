#ifndef PN_CL
#define PN_CL

// KEEP DEFINE BELOW
// Solver injected values
#define NGRID  __NGRID__
#define M      __M__
#define DT     __DT__
#define DX     __DX__
#define DY     __DY__
#define DIM    __DIM__
#define C_WAVE (1.0)
#if DIM == 2
#define IS_2D
#else
#undef IS_2D
#define DZ __DZ__
#endif //DIM
// KEEP DEFINE ABOVE

#include <solver/muscl_finite_volume.cl>

// Model injected values
#define PHY_C_DIM  __PHY_C_DIM__
#define PHY_DT_DIM __PHY_DT_DIM__
#define PHY_W0_DIM __PHY_W0_DIM__
#define SIG __SIG__
#define FILTER __FILTER__

#if FILTER != 0
#define FILTERING
#else
#undef FILTERING
#endif

#if FILTER == 1
#define LANCOS
#undef SPLINES
#undef EXPO
#endif
#if FILTER == 2
#undef LANCOS
#define SPLINES
#undef EXPO
#endif
#if FILTER == 2
#undef LANCOS
#undef SPLINES
#define EXPO
#endif

#ifdef USE_SPHERICAL_HARMONICS_P1
#include "numfluxes/p1.cl"
#endif

#ifdef USE_SPHERICAL_HARMONICS_P3
#include "numfluxes/p3.cl"
#endif

#ifdef USE_SPHERICAL_HARMONICS_P5
#include "numfluxes/p5.cl"
#endif

#ifdef USE_SPHERICAL_HARMONICS_P7
#include "numfluxes/p7.cl"
#endif

#ifdef USE_SPHERICAL_HARMONICS_P9
#include "numfluxes/p9.cl"
#endif

#ifdef USE_SPHERICAL_HARMONICS_P11
#include "numfluxes/p11.cl"
#endif

#ifdef FILTERING
#include "sources/filtering.cl"
#endif

// Add beam sources
#include "sources/clump.cl"

// Add chemistry module
#ifdef USE_CHEMISTRY
#include "../chemistry/hydrogen_clump.cl"
#endif

void model_init_cond(const real_t t, const real_t x[DIM], real_t s[M])
{
    pn_src_clump(t, x, s);
}

void model_src(const real_t t, const real_t x[DIM], const real_t wn[M],
               real_t s[M])
{
    pn_src_clump(t, x, s);

    #ifdef FILTERING
    Pn_filter(wn,s);
    #endif

    // WARNING: Divide by DT (adim) is required to fit test case
    for (int k = 0; k < M; k++) {
        s[k] = s[k] /*/ DT*/;
    }
}

void model_flux_num(const real_t wL[M], const real_t wR[M],
                    const real_t vn[DIM], real_t flux[M])
{
    num_flux_rus(wL, wR, vn, flux);

}

void model_flux_num_bd(const real_t wL[M], const real_t wR[M],
                       const real_t vn[DIM], real_t flux[M])
{
    real_t w[M];
    
    for (int k = 0; k < M; k++) {
        w[k] = 1e-8F;
    }

    
    num_flux_rus(wL, w, vn, flux);
    
    //num_flux_rus(wL, wL, vn, flux);
}
#endif