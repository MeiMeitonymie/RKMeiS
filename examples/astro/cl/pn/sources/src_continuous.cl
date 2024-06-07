#ifndef SRC_STROMGREN_SPHERE_CL
#define SRC_STROMGREN_SPHERE_CL

#ifdef USE_DOUBLE
#define SRC_X_1    (0.25)
#define SRC_X_2    (0.75)
#define SRC_Y      (0.5)
#define SRC_Z      (0.5)
#define SRC_VACCUM (DBL_EPSILON)
#else
#define SRC_X_1    (0.25)
#define SRC_X_2    (0.75)
#define SRC_Y      (0.5f)
#define SRC_Z      (0.5f)
#define SRC_VACCUM (FLT_EPSILON)
#endif

static inline void src_cont(const real_t t, const real_t x[DIM],
                                           real_t w[M])
{
    const real_t t0 = SRC_VACCUM;

#ifdef USE_DOUBLE
    const double t1 = 0.1;
    const double t2 = 0.;
    const double t3 = 1./(DX*DY*DZ);
    const double t4 = 0.5;
#else
    const float t1 = 0.1f;
    const float t2 = 0.f;
    const float t3 = 1.f/(DX*DY*DZ);
    const double t4 = 0.5f;
#endif
    const real_t t5 = t0 * t1;
    const real_t t6 = t4 * DX;
    const real_t t7 = t4 * DY;
    const real_t t8 = t4 * DZ;

    if (t >= DT) {
        for (int k = 0; k < M; k++) {
            w[k] = t2;
        }
    } else {
        for (int k = 0; k < M; k++) {
            w[k] = t2;
        }
    }

    if ((x[0] >= SRC_X_1 - t6) && (x[0] <= SRC_X_1 + t6) && (x[1] >= SRC_Y - t7) &&
        (x[1] <= SRC_Y + t7) && (x[2] >= SRC_Z - t8) && (x[2] <= SRC_Z + t8)) {
            w[0] = t3;
    }
    if ((x[0] >= SRC_X_2 - t6) && (x[0] <= SRC_X_2 + t6) && (x[1] >= SRC_Y - t7) &&
        (x[1] <= SRC_Y + t7) && (x[2] >= SRC_Z - t8) && (x[2] <= SRC_Z + t8)) {
            w[0] = t3;
    }

}
#endif
