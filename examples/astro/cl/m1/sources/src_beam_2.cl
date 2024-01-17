#ifndef SRC_BEAM_2_CL
#define SRC_BEAM_2_CL

#ifdef USE_DOUBLE

#ifdef IS_2D

void src_beam_2(const double t, const double x[2], double w[3])
{
    double norm;
    double c0;
    double eps = 1e-8;
    
    // Spatial coefficient for beam_0
    c0 = - 0.5  / (0.00500000000000000 * 0.00500000000000000);
    
    norm = (x[0] - 0.25000000000000000) * (x[0] - 0.25000000000000000) + 
           (x[1] - 0.50000000000000000) * (x[1] - 0.50000000000000000);

    double p0 = eps + exp(c0 * norm);

    // Spatial coefficient for beam_1
    c0 = - 0.5  / (0.00500000000000000 * 0.00500000000000000);
    
    norm = (x[0] - 0.50000000000000000) * (x[0] - 0.50000000000000000) + 
           (x[1] - 0.50000000000000000) * (x[1] - 0.50000000000000000);

    double p1 = eps + exp(c0 * norm);

    
    // Source values
    w[0] =  + 0.01250000000000000 * p0 + 0.01250000000000000 * p1;
    w[1] =  - 0.00000000000000000 * p0 - 0.00000000000000000 * p1;
    w[2] =  - 0.01529974556256406 * p0 - 0.01529974556256406 * p1;

}



#else  // IS_2D

void src_beam_2(const double t, const double x[3], double w[4])
{
    double norm;
    double c0;
    double eps = 1e-8;
    
    // Spatial coefficient for beam_0
    c0 = - 0.5  / (0.00500000000000000 * 0.00500000000000000);
    
    norm = (x[0] - 0.25000000000000000) * (x[0] - 0.25000000000000000) + 
           (x[1] - 0.50000000000000000) * (x[1] - 0.50000000000000000) +
           (x[2] - 0.50000000000000000) * (x[2] - 0.50000000000000000);

    double p0 = eps + exp(c0 * norm);

    // Spatial coefficient for beam_1
    c0 = - 0.5  / (0.00500000000000000 * 0.00500000000000000);
    
    norm = (x[0] - 0.50000000000000000) * (x[0] - 0.50000000000000000) + 
           (x[1] - 0.50000000000000000) * (x[1] - 0.50000000000000000) +
           (x[2] - 0.25000000000000000) * (x[2] - 0.25000000000000000);

    double p1 = eps + exp(c0 * norm);

    
    // Source values
    w[0] =  + 0.00110778365849135 * p0 + 0.00055389182924568 * p1;
    w[1] =  + 0.00135505747226350 * p0 + 0.00001911671589729 * p1;
    w[2] =  - 0.00000000000000000 * p0 + 0.00095876937117086 * p1;
    w[3] =  - 0.00135505747226350 * p0 - 0.00001911671589729 * p1;

}



#endif // IS_2D

#else  // USE_DOUBLE

#ifdef IS_2D

void src_beam_2(const float t, const float x[2], float w[3])
{
    float norm;
    float c0;
    float eps = 1e-8F;
    
    // Spatial coefficient for beam_0
    c0 = - 0.5F  / (0.00500000F * 0.00500000F);
    
    norm = (x[0] - 0.25000000F) * (x[0] - 0.25000000F) + 
           (x[1] - 0.50000000F) * (x[1] - 0.50000000F);

    float p0 = eps + exp(c0 * norm);

    // Spatial coefficient for beam_1
    c0 = - 0.5F  / (0.00500000F * 0.00500000F);
    
    norm = (x[0] - 0.50000000F) * (x[0] - 0.50000000F) + 
           (x[1] - 0.50000000F) * (x[1] - 0.50000000F);

    float p1 = eps + exp(c0 * norm);

    
    // Source values
    w[0] =  + 0.01250000F * p0 + 0.01250000F * p1;
    w[1] =  - 0.00000000F * p0 - 0.00000000F * p1;
    w[2] =  - 0.01529975F * p0 - 0.01529975F * p1;

}



#else  // IS_2D 

void src_beam_2(const float t, const float x[3], float w[4])
{
    float norm;
    float c0;
    float eps = 1e-8F;
    
    // Spatial coefficient for beam_0
    c0 = - 0.5F  / (0.00500000F * 0.00500000F);
    
    norm = (x[0] - 0.25000000F) * (x[0] - 0.25000000F) + 
           (x[1] - 0.50000000F) * (x[1] - 0.50000000F) +
           (x[2] - 0.50000000F) * (x[2] - 0.50000000F);

    float p0 = eps + exp(c0 * norm);

    // Spatial coefficient for beam_1
    c0 = - 0.5F  / (0.00500000F * 0.00500000F);
    
    norm = (x[0] - 0.50000000F) * (x[0] - 0.50000000F) + 
           (x[1] - 0.50000000F) * (x[1] - 0.50000000F) +
           (x[2] - 0.25000000F) * (x[2] - 0.25000000F);

    float p1 = eps + exp(c0 * norm);

    
    // Source values
    w[0] =  + 0.00110778F * p0 + 0.00055389F * p1;
    w[1] =  + 0.00135506F * p0 + 0.00001912F * p1;
    w[2] =  - 0.00000000F * p0 + 0.00095877F * p1;
    w[3] =  - 0.00135506F * p0 - 0.00001912F * p1;

}



#endif // IS_2D

#endif // USE_DOUBLE
#endif // SRC_BEAM_2
