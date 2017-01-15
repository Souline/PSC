
function[dataMod] = MQAM(M,signal_binaire)

%M: M_QAM
%k=log2(M); % Nombre de bits par symbole
%n=length(signal_binaire); % Nombre de bits à traiter

%<<<<<<<<<<flux de donnees pour tester>>>>>>>>>>>%
%rng default %utilise générateur de nombres aléatoires
%dataIn=randi([0 1],n,1); %génére un vecteur du flx binaire
%x=length(signal_binaire)/k;

%if size ~= n
    
%Il faut trouver un moyen de dimensionner notre flux de données
%dataInMatrix= reshape(signal_binaire,x,k); %On met les bits par symboles
%dataSymbolsIn=bi2de(dataInMatrix); %On les convertit en décimal



%--------------------------------------------%
% Here the original version use bi2de to convert binaries to decimals.
% However this function treats the binary sequence the opposite way.
% For example, if the signal_binaire = [1 0 1 1], dataSymbolsIn should be 11 = 8 + 2 + 1
% However, if you use 'bi2de', it will return 13 = 8 + 4 + 1
% Therefore I change 'bi2de' into 'bin2dec' which can finish the task properly.

str = num2str(signal_binaire);
dataSymbolsIn = bin2dec(str);

%<<<<<<<<<Modulation M-QAM>>>>>>>>>>%
dataMod=qammod(dataSymbolsIn,M,0,'gray');%Codage de gray avec un offset de phase de 0
%scatterplot(dataMod,1,0,'k*')
end
