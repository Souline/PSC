%this function has to calculate filter's coefficient

function [H]= channel_filter()
%In: no argument
%Out: vector with 256 values
%wire: UTP (no shielded)
%copper resistivity
rho=1.7 * 10^8;
%Constants
%Pi
pi=3.1415926535;
%Vacuum permeability
Mu0=4.7*pi*10^-7;
%Magnetic material permeability
Mur=1;
%Vacuum permettivity
Epsilon0=8.84*10^-12;
%


%copper diameter between 0.4 and 0.8 mm 
d= 0.8;

%distance beetween the pair (for a no shielded wire)
D= 2*d;


