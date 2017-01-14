function [noise_therm] = add_awgn_noise(sig, snr)
%In : signal
%Out : signal with noise

scale_time = linspace(0,13e-3, 512);
%Initialisation
k = 1.38*10^(-23); %Boltzmann
T = 293.15; %Temperature in Kelvin
B = 1.1*10^6; %Bandwidth in Hz 
No = 10*log10(k*T*B); %Noise power

%Create AWGN
noise_therm=awgn(sig,snr, 'measured', 'linear');

%Test
%figure(34)
%plot(scale_time,[sig,noise_therm])

end




