%This function simulates a signal passing through an ADSL line
%(copper-pairs). It is composed of the model of copper-pair line, AWGN and
%crosstalk phenomenon
%In : line's characteristics, please see main.m for further informations
%and signal_module which is the modulated signal

function signal_recu=canal(signal_module,l,n,d,snr, init)


if init ~= 1
    figure(50)
    plot(real(signal_module));hold on;plot(imag(signal_module), 'g');
    title('Signal avant filtrage');
end

H = channel_filter(l,d);
h = ifft(H);

signal_conv = filter( h, 1, signal_module);

if init ~= 1
    figure(51)
    plot(real(signal_conv));hold on;plot(imag(signal_conv), 'g');
    title('Signal après filtrage');
end

%Adding noises
crosstalk_added = add_crosstalk(signal_conv, l, n, d);
therm_added = add_awgn_noise(crosstalk_added, snr);

signal_recu = therm_added;

end

 