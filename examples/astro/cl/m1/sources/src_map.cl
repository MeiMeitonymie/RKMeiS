#ifndef SRC_STROMGREN_SPHERE_CL
#define SRC_STROMGREN_SPHERE_CL

#ifdef USE_DOUBLE
#define SRC_X      (0.5)
#define SRC_Y      (0.5)
#define SRC_Z      (0.5)
#define SRC_VACCUM (DBL_EPSILON)
#else
#define SRC_X      (0.5f)
#define SRC_Y      (0.5f)
#define SRC_Z      (0.5f)
#define SRC_VACCUM (FLT_EPSILON)
#endif

static inline void m1_src_map(const real_t t, const real_t x[DIM],
                                           real_t w[M])
{
    const real_t t0 = SRC_VACCUM;

#ifdef USE_DOUBLE
    const double t1 = 0.1;
    const double t2 = 0.;
    const double t3 = 1.;
    const double t4 = 0.5;
#else
    const float t1 = 0.1f;
    const float t2 = 0.f;
    const float t3 = 1.f;
    const float t4 = 0.5f;
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
    const real_t t8 = t4 * DZ;

    const long id = get_global_id(0);

//SOURCE 1
    if (id==(69 + 87*MESH_NX + 88*MESH_NY*MESH_NY)){
        w[0] = 0.646477039572334;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }

//SOURCE 2
    if (id==(68 + 120*MESH_NX + 103*MESH_NY*MESH_NY)){
        w[0] = 0.687331910809231;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 3
    if (id==(61 + 79*MESH_NX + 65*MESH_NY*MESH_NY)){
        w[0] = 0.720977691827869;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 4
    if (id==(78 + 98*MESH_NX + 119*MESH_NY*MESH_NY)){
        w[0] = 0.745010302555466;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 5
    if (id==(74 + 97*MESH_NX + 123*MESH_NY*MESH_NY)){
        w[0] = 0.783462353719616;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 6
    if (id==(100 + 45*MESH_NX + 60*MESH_NY*MESH_NY)){
        w[0] = 0.869979626338959;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }

    
//SOURCE 7
    if (id==(86 + 10*MESH_NX + 27*MESH_NY*MESH_NY)){
        w[0] = 0.915642027721405;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 8
    if (id==(31 + 77*MESH_NX + 48*MESH_NY*MESH_NY)){
        w[0] = 0.939674638449001;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 9
    if (id==(104 + 55*MESH_NX + 62*MESH_NY*MESH_NY)){
        w[0] = 1.21845279688911;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 10
    if (id==(41 + 73*MESH_NX + 47*MESH_NY*MESH_NY)){
        w[0] = 1.63902316962204;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 11
    if (id==(73 + 89*MESH_NX + 96*MESH_NY*MESH_NY)){
        w[0] = 1.99710825046320;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 12
    if (id==(65 + 110*MESH_NX + 91*MESH_NY*MESH_NY)){
        w[0] = 2.27348358883057;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 13
    if (id==(77 + 91*MESH_NX + 106*MESH_NY*MESH_NY)){
        w[0] = 2.38643629225025;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 14
    if (id==(113 + 61*MESH_NX + 64*MESH_NY*MESH_NY)){
        w[0] = 3.25881936866198;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 15
    if (id==(124 + 62*MESH_NX + 61*MESH_NY*MESH_NY)){
        w[0] = 5.81348456600542;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


//SOURCE 16
    if (id==(81 + 97*MESH_NX + 114*MESH_NY*MESH_NY)){
        w[0] = 7.96921044127083;
        w[1] = t2;
        w[2] = t2;
#ifndef IS_2D
        w[3] = t2;
#endif
    }


}
#endif
