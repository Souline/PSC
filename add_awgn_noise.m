function [noise_therm] = add_awgn_noise(sig)
%In : signal
%Out : signal with noise

%Initialisation
k = 1.38*10^(-23); %Boltzmann
T = 293.15; %Temperature in Kelvin
B = 1.1*10^6; %Bandwidth in Hz 
No = 10*log10(k*T*B); %Noise power
Psig = 10*log10(bandpower(sig)); %Signal power
n = 256; %Number of information bits per symbol OFDM
snr = Psig/No + 10*log10(n);

%Create AWGN
noise_therm=awgn(sig,snr);

%Test
plot([sig,noise_therm])

end




