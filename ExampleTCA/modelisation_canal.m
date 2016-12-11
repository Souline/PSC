%%%%%%%%%%%%%%%%%%%%%% Mod???lisation du canal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IN : NADA || OUT : Tableau de 256 valeur
function [HF] = modelisation_canal()

% Calcul des diff??rentes variables et constantes

% Param??tre physique des fils de cuivre : 
d=0.8;                            % en mm Schant que 0.5<d<2. Diam??tre d'un fils
D=d/2;                          % Distance entre deux fils
muR = 1.5;                          % Permeabilit?? du cuivre
teta=58*10^6;                     % Conductivit?? du cuivre

% Constantes relative de l'air et de l'isolant:
mu0=4*pi*10^-7;                   % Permeabilit?? du vide
epsilon0=(1/(36*pi))*10^-9;       % permitivit?? de l'air
epsilonR=2;                       % permitivit?? de l'isolant 


% Longeur de la ligne:
l=1000;                           %en m

% Fr??quence sous forme de tableau : 
freq=(0:4.3125e3:1.104e6);        % Vecteur de 256 fr??quences allant de 0hz ?? 1.104Mhz 
                                  % avec des sous porteur de delta = 4.3125e3

% Param??tres primaires :
C(1:256) = (pi*epsilon0*epsilonR)/(log(D/d)+sqrt((D/d)^2-1));          % en F/m
R(1:256) = (sqrt((mu0*muR)/(pi*teta))*sqrt(freq(1:256))/d);            % en ohm/m
L(1:256) = ((mu0*muR/pi)*log((D/d)+sqrt((D/d)^2-1)));                  % en H/m
G = 2*10^-6;                                                             % en S/m

gamma(1:256)=0;
expo(1:256)=0;

for i=1:256
    gamma(i)=sqrt((R(i)+(j*L(i)*2*pi*freq(i)))*(G+(j*C(i)*2*pi*freq(i))));  
    expo(i)=exp(-gamma(i)*l);
end;

%Fonction de transfert du canal :
HF=0.5*expo;                                % 0.5 : Pont diviseur de tension

HF = [HF(1:256) 0 conj(fliplr(HF(2:256))) ];

figure(2)
subplot(211);
plot(10*log10(abs(HF))) 
subplot(212);
plot(ifft(HF, 'symmetric')) 

grid on

end
