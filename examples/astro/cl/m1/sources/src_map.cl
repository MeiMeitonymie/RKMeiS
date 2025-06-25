#ifndef SRC_STROMGREN_SPHERE_CL
#define SRC_STROMGREN_SPHERE_CL

#ifdef USE_DOUBLE
#define SRC_X      (0.5)
#define SRC_Y      (0.5)
#define SRC_Z      (0.5)
#define SRC_VACCUM (DBL_EPSILON)
#define SHIFT       (123)
#else
#define SRC_X      (0.5f)
#define SRC_Y      (0.5f)
#define SRC_Z      (0.5f)
#define SRC_VACCUM (FLT_EPSILON)
#define SHIFTX       (0)
#define SHIFTY       (0)
#define SHIFTZ       (123)
#define DIM         (0.3f) 
#endif

static inline void m1_src_stromgren_sphere(const real_t t, const real_t x[DIM],
                                           real_t w[M])
{
    const real_t t0 = SRC_VACCUM;

#ifdef USE_DOUBLE
    const double t1 = 1.e-4;
    const double t2 = 0.;
    const double t3 = 1.;
    const double t4 = 0.5;
#else
    const float t1 = 1.e-4f;
    const float t2 = 0.f;
    const float t3 = 1.f;
    const float t4 = 0.5f;
#endif
    const real_t t5 = t0 * t1;
    int sx, sy, sz;

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
    sx = (69-1+SHIFTX)%MESH_NX;
    sy = (87-1+SHIFTY)%MESH_NY;
    sz = (88-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.646477039572334*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 2
    sx = (68-1+SHIFTX)%MESH_NX;
    sy = (120-1+SHIFTY)%MESH_NY;
    sz = (103-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.687331910809231*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 3
    sx = (61-1+SHIFTX)%MESH_NX;
    sy = (79-1+SHIFTY)%MESH_NY;
    sz = (65-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.720977691827869*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 4
    sx = (78-1+SHIFTX)%MESH_NX;
    sy = (98-1+SHIFTY)%MESH_NY;
    sz = (119-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.745010302555466*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 5
    sx = (74-1+SHIFTX)%MESH_NX;
    sy = (97-1+SHIFTY)%MESH_NY;
    sz = (123-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.783462353719616*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 6
    sx = (100-1+SHIFTX)%MESH_NX;
    sy = (45-1+SHIFTY)%MESH_NY;
    sz = (60-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.869979626338959*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }

    
//SOURCE 7
    sx = (86-1+SHIFTX)%MESH_NX;
    sy = (10-1+SHIFTY)%MESH_NY;
    sz = (27-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.915642027721405*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 8
    sx = (31-1+SHIFTX)%MESH_NX;
    sy = (77-1+SHIFTY)%MESH_NY;
    sz = (48-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 0.939674638449001*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 9
    sx = (104-1+SHIFTX)%MESH_NX;
    sy = (55-1+SHIFTY)%MESH_NY;
    sz = (62-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 1.21845279688911*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 10
    sx = (41-1+SHIFTX)%MESH_NX;
    sy = (73-1+SHIFTY)%MESH_NY;
    sz = (47-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 1.63902316962204*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 11
    sx = (73-1+SHIFTX)%MESH_NX;
    sy = (89-1+SHIFTY)%MESH_NY;
    sz = (96-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 1.99710825046320*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 12
    sx = (65-1+SHIFTX)%MESH_NX;
    sy = (110-1+SHIFTY)%MESH_NY;
    sz = (91-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 2.27348358883057*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 13
    sx = (77-1+SHIFTX)%MESH_NX;
    sy = (91-1+SHIFTY)%MESH_NY;
    sz = (106-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 2.38643629225025*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 14
    sx = (113-1+SHIFTX)%MESH_NX;
    sy = (61-1+SHIFTY)%MESH_NY;
    sz = (64-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 3.25881936866198*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 15
    sx = (124-1+SHIFTX)%MESH_NX;
    sy = (62-1+SHIFTY)%MESH_NY;
    sz = (61-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 5.81348456600542*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


//SOURCE 16
    sx = (81-1+SHIFTX)%MESH_NX;
    sy = (97-1+SHIFTY)%MESH_NY;
    sz = (114-1+SHIFTZ)%MESH_NZ;
    if (id==(sx + sy*MESH_NX + sz*MESH_NY*MESH_NY)){
        w[0] = 7.96921044127083*DIM;
        w[1] = t1;
        w[2] = t1;
#ifndef IS_2D
        w[3] = t1;
#endif
    }


}
#endif

