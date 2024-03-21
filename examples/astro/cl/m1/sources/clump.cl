#ifndef SRC_CLUMP_CL
#define SRC_CLUMP_CL

#ifdef USE_DOUBLE
#define SRC_X      (0.0)
#define SRC_Y      (0.5)
#define SRC_Z      (0.5)
#define SRC_VACCUM (DBL_EPSILON)
#else
#define SRC_X      (0.0f)
#define SRC_Y      (0.5f)
#define SRC_Z      (0.5f)
#define SRC_VACCUM (FLT_EPSILON)
#endif

static inline void m1_src_clump(const real_t t, const real_t x[DIM],
                                           real_t w[M])
{
    const real_t t0 = SRC_VACCUM;

#ifdef USE_DOUBLE
    const double t1 = 0.1;
    const double t2 = 0.;
    const double t3 = 1. / DT; 
    const double t4 = 0.9 * t3; //bc of M1 approximation
#else
    const float t1 = 0.1f;
    const float t2 = 0.f;
    const float t3 = 1.f / (float)(DT);
    const float t4 = 0.9f * t3; //bc of M1 approximation
#endif
    const real_t t5 = t0 * t1;

    if (t >= DT) {
        w[0] = t2;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    } else {
        // Apply some vaccum (non zero) when initializing solution
        w[0] = t0;
        w[1] = t5;
        w[2] = t5;
#ifndef IS_2D
        w[3] = t5;
#endif
    }

    const real_t t6 = t4 * DX;
    const real_t t7 = t4 * DY;
#ifndef IS_2D
    const real_t t8 = t4 * DZ;
#endif

    // Locate cell at the center of the geometry
    if ((x[0] >= SRC_X) && (x[0] <= (SRC_X+DX)))  {
        w[0] = t3;
        w[1] = t4;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;

        //const double test = sqrt(w[1]*w[1] + w[2]*w[2] + w[3] * w[3]) / w[0];
        //printf("\n%lf", test);

#endif
    }
}
#endif
