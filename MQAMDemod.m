function[train_binaire] = MQAMDemod(M,signal_module)

%k=log2(M); % Nombre de bits par symbole
%signal_demodule = qamdemod(signal_module,M,0,'gray');
%train_binaire = de2bi(signal_demodule,k);

%<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>%

k=log2(M); % Nombre de bits par symbole

signal_demodule = qamdemod(signal_module,M,0,'gray');
signal_binaire_matrice = de2bi(signal_demodule,k);
train_binaire = signal_binaire_matrice(:); 



%------------------------------------%
% Please read MQAM.m first.
% The same problem of using 'de2bi'
% You may refer to the following code.

%k=log2(M); % Nombre de bits par symbole
%signal_demodule = qamdemod(signal_module,M,0,'gray');
%string_bits = []; 

%b = dec2bin( signal_demodule, k ); 
%string_bits = [ string_bits b ];

%train_binaire = []; 
%for j = 1:length( string_bits )
%  train_binaire(j) = str2num( string_bits(j) ); 
%end

end