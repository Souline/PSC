%This function adds crosstalk perturbations to the signal

function [crossed_signal] = add_crosstalk(sig, l, n)
%In : a vector which contains the initial signal, wire length, number of perturbating signal
%Out : a vector which contains the perturbated signal

%%%%%%%%%%%%%%%%
%Initialisation%
%%%%%%%%%%%%%%%%

%First frenquency of the bandwidth
f=0;

%Out
crossed_signal = zeros(1,256);

%Initialisation of the vectors which will contain FEXT PSD and NEXT PSD
dspFEXT = linspace(f,1.1e6,256);
dspNEXT = linspace(f,1.1e6,256);

%Will be used for ploting
scale = linspace(f,1.1e6,256);

%Computing of channel equivalent filter's module
channel = abs(channel_filter(l,0));

%Creation of an AWGN signal which will excite FEXT and NEXT PSDs
noise = awgn(zeros(1,256),1);


%figure
%plot(noise);
%title('bruit en temporel')

%Shifting in freqency domain
noise = fft(noise);

%figure
%plot(scale,noise);
%title('TF du bruit')

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creation of equivalent filter %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
FEXT = ifft(dspFEXT);
NEXT = ifft(dspNEXT);

for j=1:256
    crossed_signal(j) = sig(j)+FEXT(j)+NEXT(j);
end

figure
subplot(2,2,1)
plot(scale,FEXTdB)
title('dspFEXT')
subplot(2,2,2)
plot(scale,NEXTdB)
title('dspNEXT')
subplot(2,2,3)
plot(FEXT)
title('effet FExT en temporel')
subplot(2,2,4)
plot(NEXT)
title('effet next en temporel')

figure
subplot(2,1,1)
plot(sig)
title('Signal initial')
subplot(2,1,2)
plot(crossed_signal)
title('signal perturb�')
end
    
