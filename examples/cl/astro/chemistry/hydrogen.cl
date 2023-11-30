#ifndef _CHEMISTRY_CL
#define _CHEMISTRY_CL

// Dimensioning
#define PHY_CST_KB      (1.380649e-23)
#define PHY_CST_ALPHA_I (2.493e-22)

// Collisional ionisation rate in cm^{3}.s^{-1} (Maselli et al. 2003)
double gamma_h0(const double T)
{
    double res = 5.85e-11;
    res *= sqrt(T);
    res *= 1.0 / (1.0 + sqrt(T / 1.e5));
    res *= exp(-157809.1 / T);

    // Convert to m^{3}.s^{-1}
    res *= 1e-6;
    return res;
}

// Case A - Recombination rate in cm^{3}.s^{-1} (Hui & Gnedin 1997)
double alpha_ah(const double T)
{
    double lambda = 2.0 * 157807.0 / T;
    double res = 1.269e-13;
    res *= pow(lambda, 1.503);
    res /= pow(1.0 + pow(lambda / 0.522, 0.47), 1.923);

    // Convert to m^{3}.s^{-1}
    res *= 1e-6;
    return res;
}

// Case A - HII recombination cooling rate in erg.cm^{3}.s^{-1} (Hui & Gnedin
// 1997)
double recombination_cooling_rate_ah(const double T)
{
    double lambda = 2.0 * 157807.0 / T;
    double res = 1.778e-29 * pow(lambda, 1.965);
    res /= pow(1.0 + pow(lambda / 0.541, 0.502), 2.697);

    // Convert to erg.m^{3}.s^{-1}
    res *= 1e-6;

    // Convert to J.m^{3}.s^{-1}
    res *= 1e-7;
    return res;
}

// Case B - Recombination rate from in cm^{3}.s^{-1} (Hui & Gnedin 1997)
double alpha_bh(const double T)
{
    double lambda = 2.0 * 157807.0 / T;
    double res = 2.753e-14;
    res *= pow(lambda, 1.5);
    res /= pow(1.0 + pow(lambda / 2.74, 0.407), 2.242);

    // Convert to m^{3}.s^{-1}
    res *= 1e-6;
    return res;
}

// HI collisional ionisation coefficient in cm^{3}.s^{-1}.K^{3/2} (Hui & Gnedin
// 1997)
double beta_h(const double T)
{
    double lambda = 2.0 * 157807.0 / T;
    double res =
        21.11 * pow(T, -1.5) * exp(-lambda / 2.0) * pow(lambda, -1.089);
    res /= pow(1.0 + pow(lambda / 0.354, 0.874), 1.01);

    // Convert to m^{3}.s^{-1}
    res *= 1e-6;
    return res;
}

// Collisional ionisation cooling in erg.cm^{3}.s^{-1} (Maselli et al. 2003)
double ksi_h0(const double T)
{
    double res = 1.27e-21 * sqrt(T) / (1.0 + sqrt(T / 1.e5));
    res *= exp(-157809.1 / T);

    // Convert to erg.m^{3}.s^{-1}
    res *= 1e-6;

    // Convert to J.m^{3}.s^{-1}
    res *= 1e-7;
    return res;
}

// Recombination cooling for H0 in erg.cm^{3}.s^{-1} (Maselli et al. 2003)
// Case A or B or total ?
double eta_h0(const double T)
{
    double res =
        8.7e-27 * sqrt(T) * pow(T / 1.e3, -0.2) / (1.0 + pow(T / 1.e6, 0.7));

    // Convert to erg.m^{3}.s^{-1}
    res *= 1e-6;

    // Convert to J.m^{3}.s^{-1}
    res *= 1e-7;
    return res;
}

// Collisional exciation cooling for H0 in erg.cm^{3}.s^{-1} (Maselli et al.
// 2003)
double psi_h0(const double T)
{
    double res = 7.5e-19 / (1.0 + sqrt(T / 1.e5));
    res *= exp(-118348.0 / T);

    // Convert to erg.m^{3}.s^{-1}
    res *= 1e-6;

    // Convert to J.m^{3}.s^{-1}
    res *= 1e-7;
    return res;
}

// Bremsstrahlung cooling in erg.cm^{3}.s^{-1} (Maselli et al. 2003) WARNING: we
// took the densities out of the formula so one needs to multiply the result by
// rho_electrons^2 (in case of pure Hydrogen chemistry)
double beta_bremsstrahlung(const double T)
{
    double res = 1.42e-27 * sqrt(T);
    // Convert to erg.m^{3}.s^{-1}
    res *= 1e-6;

    // Convert to J.m^{3}.s^{-1}
    res *= 1e-7;
    return res;
}

// Total cooling rate (sum of terms below) in erg.cm^{3}.s^{-1}
double cooling_rate(const double T, const double x)
{
    // const double t0 = x * x;
    // const double t1 = 1.0 - x;
    // const double t2 = t1 * t1;
    // return (beta_bremsstrahlung(T) + eta_h0(T)) * t0 +
    //        (psi_h0(T) + ksi_h0(T)) * t2;

    return beta_bremsstrahlung(T) * x * x + psi_h0(T) * (1.0 - x) * (1.0 - x) +
           ksi_h0(T) * (1.0 - x) * (1.0 - x) + eta_h0(T) * x * x;
}

double cooling_rate_density(const double T, const double nH, const double x_n)
{
    // const double t0 = nH * x_n;
    // const double t1 = t0 * t0;
    // const double t2 = t0 * nH - t1;

    // return (beta_bremsstrahlung(T) + eta_h0(T)) * t1 +
    //        (psi_h0(T) + ksi_h0(T)) * t2;

    return beta_bremsstrahlung(T) * (nH * x_n) * (nH * x_n) +
           psi_h0(T) * (nH * x_n) * (nH * (1. - x_n)) +
           ksi_h0(T) * (nH * x_n) * (nH * (1. - x_n)) +
           eta_h0(T) * (nH * x_n) * (nH * x_n);
}

double heating_rate(const double nH, const double x, const double x_n,
                    const double N, const double al_i)
{
    const double e = (20.28 - 13.6) * 1.60218e-19;
    // Short time step
    return nH * (1. - x_n) * N * al_i * e * PHY_C_DIM;
}

// TODO: FUNCTION IS NOT SAFE !!!!!!!!!
double get_root_newton_raphson(const double a, const double b, const double c,
                               const double d)
{
    const double eps = 1e-6;
    double x = 0.5;
    double f = HUGE_VAL;
    double df, t2, t3;

    while (fabs(f) >= eps) {
        // Intermediate variables
        t2 = x * x;
        t3 = x * x * x;

        // Polynomial and derivative evaluation
        f = a * t3 + b * t2 + c * x + d;
        df = 3. * a * t2 + 2. * b * x + c;

        x -= f / df;
    }
    return x;
}

__kernel void chem_init_sol(__global real_t *nh, __global real_t *temp,
                            __global real_t *xi)
{
    // Current cell ID
    const long id = get_global_id(0);

    // Stromgren sphere test case values
    xi[id] = (real_t)1.2e-3;
    nh[id] = (real_t)1e3;
    temp[id] = (real_t)100.;
}

__kernel void chem_step(__global const real_t *nh, __global real_t *wn,
                        __global real_t *temp, __global real_t *xi)
{
    // Current cell ID
    const long id = get_global_id(0);

    // Photon density
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
    // const double t0 = nH * nH;
    // const double t1 = t0 * PHY_DT_DIM;
    // const double t2 = PHY_CST_ALPHA_I * PHY_C_DIM;
    // const double t3 = nH / t2;
    // const double t4 = 1. / (t2 * PHY_DT_DIM);

    // const double m = (al_b + bt) * t1;
    // const double n = nH - (al + bt) * t3 - (al_b + 2. * bt) * t1;
    // const double p = -nH * (1. + x) - N_pos - t4 + bt * (t3 + t1);
    // const double q = N_pos + x * (nH + t4);

    // Compute new x (x_n) (NON OPTIM)
    const double m = (al_b + bt) * PHY_DT_DIM * nH * nH;

    const double n = nH - (al + bt) * nH / (PHY_CST_ALPHA_I * PHY_C_DIM) -
                     (al_b + 2. * bt) * PHY_DT_DIM * nH * nH;

    const double p = -nH * (1. + x) - N_pos -
                     1. / (PHY_CST_ALPHA_I * PHY_C_DIM * PHY_DT_DIM) +
                     bt * nH / (PHY_CST_ALPHA_I * PHY_C_DIM) +
                     bt * PHY_DT_DIM * nH * nH;

    const double q =
        N_pos + x * nH + x / (PHY_CST_ALPHA_I * PHY_C_DIM * PHY_DT_DIM);

    double x_n = get_root_newton_raphson(m, n, p, q);

    // Compute new N (N_n) (OPTIM)
    // const double t5 = x_n * x_n;
    // const double c1 = bt * t1 * (x_n - t5);
    // const double c2 = -al_b * t1 * t5;
    // const double N_n = N + c1 + c2 + -nH * (x_n - x);

    const double c1 = bt * nH * nH * (1. - x_n) * x_n * PHY_DT_DIM;
    const double c2 = -al_b * nH * nH * x_n * x_n * PHY_DT_DIM;
    const double c3 = -nH * (x_n - x);
    const double N_n = N + c1 + c2 + c3;

    // Compute new T (T_n)
    const double L = cooling_rate_density(T, nH, x_n) * PHY_DT_DIM;
    const double H =
        heating_rate(nH, x, x_n, N_pos, PHY_CST_ALPHA_I) * PHY_DT_DIM;
    const double coef = 2. * (H - L) / (3. * nH * (1. + x_n) * PHY_CST_KB);
    double T_n = (coef + T) / (1. + x_n - x);

    // const double L = cooling_rate_density(T, nH, x_n);
    // const double H = heating_rate(nH, x, x_n, N_pos, PHY_CST_ALPHA_I);
    // const double coef =
    //     2. * (H - L) * PHY_DT_DIM / (3. * nH * (1. + x_n) * PHY_CST_KB);
    // double T_n = (coef + T) / (1. + x_n - x);

    T_n = max(T_n, 10.);

    // Update moments global buffer
    const real_t ratio = (real_t)(N_n / N);
    wn[id] = (real_t)(N_n / (PHY_W0_DIM));

    for (int k = 1; k < M; k++) {
        long imem = id + k * NGRID;
        wn[imem] = wn[imem] * ratio;
    }

    // Update x global buffer
    xi[id] = (real_t)x_n;

    // Update temperature global buffer
    temp[id] = (real_t)T_n;
}

#endif