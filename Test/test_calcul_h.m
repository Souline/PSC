close all;
clear all;
[snr, h_estime] = process_SNR_Unique(1000, 1, 0, 1000);

h_est_freq = fft(h_estime);
h_est_inv = 1./h_est_freq;
h_inv_time = ifft([ 0 h_est_inv(34:288) 0 conj(fliplr(h_est_inv(34:288)))]);
size(h_inv_time)

h_theo = channel_filter(1000, 0);

h_theo_inv = 1./h_theo;
h_theo_time = ifft(h_theo_inv(33:288));

figure(23)
plot(real(h_inv_time));hold on;plot(imag(h_inv_time), 'g');

figure(24)
plot((1:256),10*log10(real(h_est_inv(33:288))));

figure(25)
plot(real(h_theo_inv));hold on;plot(imag(h_theo_inv), 'g');
