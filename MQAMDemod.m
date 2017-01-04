function[train_binaire] = MQAMDemod(M,signal_module)

k=log2(M) % Nombre de bits par symbole
signal_demodule = qamdemod(signal_module,M,0,'gray');
signal_binaire_matrice = de2bi(signal_demodule,k);
train_binaire = signal_binaire_matrice(:); 
end