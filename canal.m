function signal_recu=canal(signal_module,l,n,d)

% La fonction canal permet de simuler un canal réel, intégrant du bruit et de la diaphonie.
% Tous les échantillons sortant du modulateur DMT traverseront
% ce canal pour finalement être envoyées au démodulateur.

% signal_module est le vecteur sorti du modulateur DMT.
% h est la réponse impulsionnelle en temps du canal.

h = ifft(channel_filter(l,d));

scale_freq = linspace(0,1.1e6,256);
scale_time = linspace(0,13e-3, 256);

signal_recu = (0:0:256);

%signal_freq = fft(signal_module, 256);
%figure(1)
%plot(scale_freq, signal_freq);
%title('FFT du signal module');

signal_recu = conv(signal_module, h);

%for i=1:256
%    signal_recu(i)=ifft(H(i)*signal_freq(i));
%end

figure(2)
subplot(211)
plot(signal_recu);
title('Signal filtré sans le bruit');

%We add noises
signal_recu = add_awgn_noise(signal_recu);
signal_recu = add_crosstalk(signal_recu, l, n);

figure(2)
subplot(212)
plot(scale_time, signal_recu);
title('Signal filtré avec le bruit');
end

 