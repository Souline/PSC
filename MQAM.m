
function[dataMod] = MQAM(M,signal_binaire)

%M: M_QAM
k=log2(M) % Nombre de bits par symbole
n=length(signal_binaire) % Nombre de bits à traiter

%<<<<<<<<<<flux de donner pour tester>>>>>>>>>>>%
%rng default %utilise générateur de nombres aléatoires
%dataIn=randi([0 1],n,1); %génére un vecteur du flx binaire
x=length(signal_binaire)/k
dataInMatrix= reshape(signal_binaire,length(signal_binaire)/k,k); %On met les bits par symboles
dataSymbolsIn=bi2de(dataInMatrix); %On les convertit en décimal


%<<<<<<<<<Modulation M-QAM>>>>>>>>>>%
dataMod=qammod(dataSymbolsIn,M,0,'gray'); %Codage de gray avec un offset de phase de 0
scatterplot(dataMod,1,0,'k*')

end
