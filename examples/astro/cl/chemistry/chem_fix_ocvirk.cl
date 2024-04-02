__kernel void chem_step(__global const real_t *nh, __global real_t *wn,
                        __global real_t *temp, __global real_t *xi)
{
    // Current cell ID
    const long id = get_global_id(0);

    // Use PHY_W0_DIM to give physical dimension
    const double N = (double)(wn[id] * PHY_W0_DIM);
    const double N_pos = max(0., N);
    
    const double x = (double)xi[id];
    const double T = (double)temp[id];
    const double nH = (double)nh[id];

    // Chemistry coefficients
    const double al = alpha_ah(T);
    const double al_b = alpha_bh(T);
    const double bt = beta_h(T);

    // Intermediate vars
    const double t0 = nH * nH;
    const double t1 = t0 * PHY_DT_DIM;
    const double t2 = PHY_CST_ALPHA_I * PHY_C_DIM;
    const double t3 = nH / t2;
    const double t4 = 1. / (t2 * PHY_DT_DIM);

    // Compute x
    const double m = (al_b + bt) * t1;
    const double n = nH - (al + bt) * t3 - (al_b + 2. * bt) * t1;
    const double p = -nH * (1. + x) - N_pos - t4 + bt * (t3 + t1);
    const double q = N_pos + x * (nH + t4);
    const double x_n = get_root_newton_raphson(m, n, p, q, x);

    // Compute N
    const double t5 = x_n * x_n;
    const double c1 = bt * t1 * (x_n - t5);
    const double c2 = -al_b * t1 * t5;
    const double N_n = N + c1 + c2 + -nH * (x_n - x);
    
    // Patch
    // const double N_n = fabs(N) + c1 + c2 + -nH * (x_n - x);

    // Compute T
    const double L = cooling_rate_density(T, nH, x_n);
    const double H = heating_rate(nH, x, x_n, N_pos, PHY_CST_ALPHA_I);
    const double coef =
        2. * (H - L) * PHY_DT_DIM / (3. * nH * (1. + x_n) * PHY_CST_KB);
    const double T_n = max((coef + T) / (1. + x_n - x), 10.);
    //const double T_n = 1.e4;

    // Update N (moment 0)
    // Use PHY_W0_DIM to remove physical dimension
    
    // Cap small new density to +-DBL_EPSILON or +-FLT_EPISLON
#ifdef USE_DOUBLE
    wn[id] = copysign(max(DBL_EPSILON, fabs(N_n) / PHY_W0_DIM),N_n);
#else
    wn[id] = copysign(max(FLT_EPSILON, (float)(fabs(N_n) / PHY_W0_DIM)), (float)N_n);
#endif
   
   // Cap inversion of old density to +-DBL_EPSILON or +-FLT_EPISLON
#ifdef USE_DOUBLE
    const double t6 =1. /  copysign(max(DBL_EPSILON, fabs(N)), N);
#else
    const float t6 = 1.f / copysign(max(FLT_EPSILON, fabs((float)N)), (float)N);
#endif

    // Update moments > 0
    const real_t ratio = (real_t)(N_n * t6);
    for (int k = 1; k < M; k++) {
        long imem = id + k * NGRID;
        wn[imem] = wn[imem] * ratio;
    }

    // Update x
    xi[id] = (real_t)x_n;

    // Update T
    temp[id] = (real_t)T_n;
}