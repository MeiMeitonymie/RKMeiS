from scipy import special
from scipy import integrate
import numpy as np


#computes the content of the integrals to project approximated beam on spherical harmonics (3D)
def Pn3D_spherharmonic(theta, phi, l, m, theta0, phi0, sigma, S0):
    source = S0*np.exp(-((theta-theta0)**2 + (phi-phi0)**2)/(sigma**2))
    Yml = special.sph_harm(m, l, theta, phi)
    #print(Yml, theta, phi, -((theta-theta0)**2 + (phi-phi0)**2)/(sigma**2))
    return(np.conj(Yml)*source)

#computes the content of the integrals to project approximated beam on spherical harmonics (2D)
def Pn2D_spherharmonic(theta, l, m, theta0, sigma, S0):
    source = S0*np.exp(-((theta-theta0)**2)/(sigma**2))
    #defined harmonics in 2D as having phi fixed at pi/2
    #fixed phi
    Yml = special.sph_harm(m, l, theta, np.pi/2)
    return(np.matrix.conj(Yml)*source)


#returns source coef for the approximated gaussian beam (3D)
def Pn3D_get_coefs(L, S0, sigma, theta0, phi0):
    
    vec_size = (L+1)**2
    coefs = np.zeros(vec_size, dtype=complex)
    errors = np.zeros(vec_size, dtype=complex)


    def real_func(theta, phi, l, m, theta0, phi0, sigma, S0):
        return(np.real(Pn3D_spherharmonic(theta, phi, l, m, theta0, phi0, sigma, S0)))

    def imag_func(theta, phi, l, m, theta0, phi0, sigma, S0):
        return(np.imag(Pn3D_spherharmonic(theta, phi, l, m, theta0, phi0, sigma, S0)))

    for l in range(0,L+1):
        for m in range(-l,l+1):
            i = l**2+l+m
            real_coef, real_error = integrate.dblquad(real_func, 0, np.pi, 0, 2*np.pi, args=(l,m, theta0, phi0, sigma, S0))
            imag_coef, imag_error = integrate.dblquad(imag_func, 0, np.pi, 0, 2*np.pi, args=(l,m, theta0, phi0, sigma, S0))

            coefs[i] = complex(real_coef, imag_coef)
            errors[i] = complex(real_error, imag_error)
            #print("l:",l," m:",m," i:",i," coef:",coefs[i])

    return(coefs, errors)


def normcoef(coefs,S0):
    norm_coef = S0/np.real(coefs[0])
    new_coefs = np.real(coefs)*norm_coef
    return(new_coefs)

L= 11
S0 = 1.0
sigma = 0.05
theta0 = np.pi/2
phi0 = 0

coefs,errors = Pn3D_get_coefs(L, S0, sigma, theta0, phi0)
print(coefs)
new_coefs = normcoef(coefs,S0)
for i in range(len(new_coefs)):
    print("w["+str(i)+"] = "+"{:.17f}".format(new_coefs[i])+"/DT;")

print("\n\n")
for i in range(len(new_coefs)):
    print("w["+str(i)+"] = "+"{:.8f}".format(new_coefs[i])+"F/(float)DT;")

"""
#returns source coef for the approximated gaussian beam (2D)
function Pn2D_get_coefs(L, S0, sigma, theta0)
    
    vec_size = (L+1)^2
    coefs = zeros(Complex{Float64}, vec_size)
    errors = zeros(Complex{Float64}, vec_size)


    function real_func(theta, l, m, theta0, sigma, S0)
        return(real(Pn2D_spherharmonic(theta, l, m, theta0, sigma, S0)))
    end

    function imag_func(theta, l, m, theta0, sigma, S0)
        return(imag(Pn2D_spherharmonic(theta, l, m, theta0, sigma, S0)))
    end

    for l=0:1:L
        for m=-l:1:l
            i = l^2+l+m +1
            real_coef, real_error = SciPy.integrate.quad(real_func, 0, 2*pi, args=(l,m, theta0, sigma, S0))
            imag_coef, imag_error = SciPy.integrate.quad(imag_func, 0, 2*pi, args=(l,m, theta0, sigma, S0))

            coefs[i] = complex(real_coef, imag_coef)
            errors[i] = complex(real_error, imag_error)
            print("l:",l," m:",m," i:",i," coef:",coefs[i],"\n")

        end
    end
    return(coefs, errors)
end
"""