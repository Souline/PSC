function [noise_therm] = add_awgn_noise(sig)
%In : signal
%Out : signal with noise
scale_time = linspace(0,13e-3, 512);
%Initialisation
k = 1.38*10^(-23); %Boltzmann
T = 293.15; %Temperature in Kelvin
B = 1.1*10^6; %Bandwidth in Hz 
PNo = k*T*B; %Noise power
%Psig = 10*log10(bandpower(sig)); %Signal power
Psig=1; %puissance émise =1 W
n = 4; %Number of information bits per symbol OFDM
%snr = Psig/No + 10*log10(n);
snr=Psig/PNo
snrDb=10*log10(snr);

%Create AWGN
noise_therm=awgn(sig,snrDb);

%Test
%figure(34)
%plot(scale_time,[sig,noise_therm])

end




