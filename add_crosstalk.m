%This function adds crosstalk perturbations to the signal

function [crossed_signal] = add_crosstalk(sig, l, n, d)
%In : a vector which contains the initial signal, wire length, number of perturbating signal
%Out : a vector which contains the perturbated signal

%scale = linspace(0, 1.1e6, 256);
%Initialisation
%First frenquency of the bandwidth
f=0;
in =sig;

%Out
crossed_signal = zeros(1,512);

%Initialisation of the vectors which will contain FEXT PSD and NEXT PSD
dspFEXT = linspace(f,1.1e6,256);
dspNEXT = linspace(f,1.1e6,256);

%Computing of channel equivalent filter's module
channel = abs(channel_filter(l,d));

%Creation of an AWGN signal which will excite FEXT and NEXT PSDs
noise = fft(awgn(ones(1,256),1, 'measured', 'linear'));

i=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Computing of NEXT&FEXT PSD%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while f < 1.1e6
    
    %Caution : Hlpf and Hhpf variables are actually |Hlpf(f)|^2 and
    %|Hhpf(f)|^2
    Hlpf = ((1.104e6)^11.96)/(f^11.96+(1.104e6)^11.96);
    Hhpf = (f^7.09+4000^7.09)/(f^7.09+25875^7.09);
    
    DSPperturb = 0.1104*(2/2.208e6)*pow2(sinc(pi*f/2.208e6))*Hlpf*Hhpf;
    
    %Caution : Hfext is actually |Hfext(f)|^2
    Hfext = channel(i)^2*8e-20*(n/49)^0.6*l*f^2*3.28;
    
    dspFEXT(i) = DSPperturb*Hfext;
    dspNEXT(i) = DSPperturb*0.8536e-14*n^0.6*f^(3/2);
    
    f = f + 4.3125e3;
    i=i+1;
end

%Creation of equivalent filter

for j=1:256
    dspFEXT(j) = abs(noise(j))^2*dspFEXT(j);
    dspNEXT(j) = abs(noise(j))^2*dspNEXT(j);
end

%Shifting to log scale for plotting
NEXTdB = 10*log10(dspNEXT/1e-3);
FEXTdB = 10*log10(dspFEXT/1e-3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Addition of crosstalk effects on the initial signal %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Shifting to time domain

FEXT = ifft([dspFEXT 0 conj(fliplr(dspFEXT(2:255)))]);
NEXT = ifft([dspNEXT 0 conj(fliplr(dspNEXT(2:255)))]);

FEXT = interpft(FEXT, numel(sig));
NEXT = interpft(NEXT, numel(sig));
numel(FEXT);

%figure(103)
%subplot(211)
%plot(real(FEXT));hold on;plot(imag(FEXT), 'g');
%subplot(212)
%plot(real(NEXT));hold on;plot(imag(NEXT),'g');
%title('FEXT et NEXT en temps')

for j=1:numel(sig)
    crossed_signal(j) = (sig(j))+(FEXT(j))+(NEXT(j));
end


%figure(226)
%subplot(2,1,1)
%plot(real(FEXTdB));hold on;plot(imag(FEXTdB), 'g');
%title('FEXT en log')
%subplot(2,1,2)
%plot(real(NEXTdB));hold on;plot(imag(NEXTdB), 'g');
%title('NEXT en log')

end
    
