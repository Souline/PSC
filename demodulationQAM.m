function suite_symb=demodulationQAM(Xi,Xq,M)

% Associe aux symboles complexes, leur ecriture decimale en fonction 
% de symbole complexe de partie reelle Xi et imaginaire Xq 
% dans la cas d'une demodulation M-QAM.

% Xi est la partie reelle du symbole complexe.
% Xq est la partie imaginaire du symbole complexe.
% M est le nombre de points de la constellation.


suite_symb=qamdemod(complex(Xi,Xq),M); % D�module les symboles sur une constellation de M points