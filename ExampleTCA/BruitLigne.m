function [signal_with_noise,noisePower] = BruitLigne(signal_without_noise,signalPower)

noisePower=-173+10*log10(1.104e6);                     % puissance du bruits blanc N0 en dB
SNR=signalPower-noisePower;
SNR=SNR-40-20;                                         % Average power of Far end and near end crosstalk 40 for Neaxt and 20 for Fext
signal_with_noise=awgn(signal_without_noise,SNR,-5,52);% Fonction introduisant un bruit blanc gaussien
noisePower=10*log10(abs(signal_with_noise-signal_without_noise).^2);      



