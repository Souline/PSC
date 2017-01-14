function signal_recu=canal(signal_module,l,n,d,snr, crosstalk, awgn)

% La fonction canal permet de simuler un canal réel, intégrant du bruit et de la diaphonie.
% Tous les échantillons sortant du modulateur DMT traverseront
% ce canal pour finalement être envoyées au démodulateur.

% signal_module est le vecteur sorti du modulateur DMT.
% h est la réponse impulsionnelle en temps du canal.

H = channel_filter(l,d);
h = ifft(H);
h = h(1:256);
%figure(372)
%subplot(211)
%plot(real(h));hold on;plot(imag(h), 'g');
%title('Réponse impulsionnelle');
%subplot(212)
%plot(real(H));hold on;plot(imag(H), 'g');
%title('Réponse fréquentielle');
%H = channel_filter(l,d);

scale_freq = linspace(0,1.1e6,256);
scale_time = linspace(0,13e-3, 512);

%signal_recu = (0:0:512);

%signal_freq = fft(signal_module, 256);
figure(456)
plot(real(signal_module));hold on;plot(imag(signal_module), 'g');
title('Signal avant convolution');
%figure
%plot(signal_freq);
signal_conv = conv(signal_module, h, 'same');
figure(843)
plot(real(signal_conv));hold on;plot(imag(signal_conv), 'g');
title('Signal après convolution');
%signal_recu = H*signal_freq
%signal_recu = ifft(signal_recu, 256)
%for i=1:256
%    signal_recu(i)=ifft(H(i)*signal_freq(i),256);
%end

%figure(18)
%plot(scale_time, signal_recu);

%size(signal_recu)

%figure(2)
%subplot(211)
%plot(scale_time,signal_recu);
%title('Signal filtré sans le bruit');

%We add noises
%if (crosstalk == 1) && (awgn == 1)
crosstalk_added = add_crosstalk(signal_conv, l, n, d);
therm_added = add_awgn_noise(crosstalk_added, snr);
figure(995)
plot(real(therm_added));hold on;plot(imag(therm_added), 'g');
title('Signal après ajout des perturbations');


figure(666)
plot(real(therm_added) - real(signal_conv));hold on;plot(imag(therm_added) - imag(signal_conv), 'g');   
title('Vérification canal');
signal_recu = therm_added;
%end
%figure(2)
%subplot(212)
%plot(scale_time, signal_recu);
%title('Signal filtré avec le bruit');
end

 