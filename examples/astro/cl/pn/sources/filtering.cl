

//returns the filtering coefficients

#ifdef FILTERING
double filter_func(double);

#ifdef LANCOS
double filter_func(double v)
{
    return(sin(v)/v);
}
#endif
#ifdef SPLINES 
double filter_func(double v)
{
    return(1.0/(pow(v,4.)+1.0));
}
#endif
#ifdef EXPO
double filter_func(double v)
{
    double dv = v*v;
    return(exp(log(0.0000000000001)*dv*dv));
}
#endif

void Pn_filter(const real_t w[M], real_t s[M])
{
    #ifdef USE_SPHERICAL_HARMONICS_P1 
    double L = 1.;
    //int l = (int)pow(1.+1.,2.);
    #endif
    #ifdef USE_SPHERICAL_HARMONICS_P3 
    double L = 3.;
    //int l = (int)pow(3.+1.,2.);
    #endif
    #ifdef USE_SPHERICAL_HARMONICS_P5
    double L = 5.;
    //int l = (int)pow(5.+1.,2.);
    #endif
    #ifdef USE_SPHERICAL_HARMONICS_P7
    double L = 7.;
    //int l = (int)pow(7.+1.,2.);
    #endif
    #ifdef USE_SPHERICAL_HARMONICS_P9 
    double L = 9.;
    //int l = (int)pow(9.+1.,2.);
    #endif
    #ifdef USE_SPHERICAL_HARMONICS_P11
    double L = 11.;
    //int l = (int)pow(11.+1.,2.);
    #endif

    int k=0;
    for (int i=1;i<=(int)L;i++)
    {
        for (int j=-i;j<=i;j++)
        {
            k+=1;
            //printf("%d %d %d\n",k, i, j);
            //printf("pre %lf ",s[i]);
            s[k]= s[k] - SIG * w[k]* log(filter_func((double)i/(L+1.)))/log(filter_func(L/(L+1.)));
            //printf("post %lf \n",log(filter_func((double)i/(L+1.)))/log(filter_func(L/(L+1.))));
            /*
            printf("filter 1 %lf ",log(filter_func((double)i/(L+1.))));
            printf("value %lf ",(double)i/(L+1.));
            printf("i %lf ",(double)i);
            printf("L+1 %lf \n",(L+1.));
            printf("all %lf\n",log(filter_func((double)i/(L+1.)))/log(filter_func(L/(L+1.))));
            */
        }   
    }


}


/*void Pn_filter_coeff(double )
    coeff = zeros((L+1)^2)
    if filter == "None"
        return coeff
    else
        k = 1
        for li=0:1:L
            for mi=-li:1:li 
                coeff[k] = log(Pn_filter(li/(L+1),filter))/log(Pn_filter(L/(L+1),filter))
                k+=1
            end
        end
        return coeff
    end
end*/

#endif //FILTERING