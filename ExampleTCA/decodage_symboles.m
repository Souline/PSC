function [suite_bit] =decodage_symboles(symbole,M)

% La fonction decodage_symboles permet de d??coder une suite de symboles pour
% obtenir la suite binaire associ??e.

% suite_symboles est la suite des symboles sous forme d??cimale.
% M est l'indice de modulation utilis?? pour coder cette suite.

% Init
k=log2(M);                          % k est le nombre de bits par symbole (M=2^k)
longs=length(symbole);       % Nombre de symboles en entr??e
longb=longs*k;                      % Nombre de bits en sortie 
string_bits=[];                     % Initialisation de la 'string' qui contiendra la suite de bits 

% Conversion des symboles 
                           % On parcourt la suite de symboles
    b=dec2bin(symbole,k);     % Conversion des symboles en binaire
   
    l = length(b);
    suite_bit = [ zeros(1,k-l) b-'0']; % La fonction dec2bin renvoie une 'string' qu'on transforme en vecteur
end
