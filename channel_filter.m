%this function has to calculate filter's coefficient

function [H]= channel_filter(l,desadaptation)
%In: Wire lenght, desadaptation
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
%Insulating permettivity
EpsilonR=1.5;
%copper diameter between 0.4 and 0.8 mm 
d= 0.6604;
%distance beetween the pair (for a no shielded wire)
D= 3.4036;
%frequency: 255 intervals of  4,3125 kHz (0 to 1.1 MHz) 
f=(0:4.3125e3:1.104e6); %frequency vector
%Wire Resistivity: frequency ?
R(1:256)=sqrt((Mu0*Mur*rho)/(pi))*(sqrt(f(1:256))/d);
%Wire capacity
C=(pi*Epsilon0*EpsilonR)/(log(sqrt((D/d)^2-1)+(D/d)));
%Wire inductivity
L=((Mu0*Mur)/pi)*(log(sqrt((D/d)^2-1)+(D/d)));
%Wire conductivity
G=10^-6;
%Wire impedance
Ze=sqrt(L/C);
%end of line impedance
Zc=Ze+desadaptation;
%end of line reflection coefficient
ToR=(Zc-Ze)/(Ze+Zc);
%beginning of line reflection coefficient
ToG=(Ze-Zc)/(Ze+Zc);
%Gamma
Gamma(1:256)=0;
egamma(1:256)=0;
e2gamma(1:256)=0;
for i=1:256
    Gamma(i)=sqrt((R(i)+(j*L*2*pi*f(i)))*(G+(j*C*2*pi*f(i))));  
    egamma(i)=exp(-Gamma(i)*l);
    e2gamma(i)=exp(-2*Gamma(i)*l);
end;
%tension divider bridge
bridge=Zc/(Ze+Zc);
%-----------------------------------%
%Canal modelisation%
H(1:256)=0;
for i=1:256
    H(i)=bridge*(egamma(i)/(1+(ToR*ToG*e2gamma(i))))
end;
H = [H(1:256) 0 conj(fliplr(H(2:256))) ];

figure(2)
subplot(211);
plot(10*log10(abs(H))) 
subplot(212);
plot(ifft(H, 'symmetric')) 


end





