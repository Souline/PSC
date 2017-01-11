%This function adds crosstalk perturbations to the signal

function [out_signal] = pertubations_signal(sig, l,d, crosstalk,awgn_channel,snr)
    
    f=0;
    n=1;
    %Out
    crossed_signal = zeros(1,256);
    channel = abs(channel_filter(l,d));

    %Initialisation of the vectors which will contain FEXT PSD and NEXT PSD
    dspFEXT = linspace(f,1.1e6,256);
    dspNEXT = linspace(f,1.1e6,256);

    %Will be used for ploting
    scale = linspace(f,1.1e6,256);
    test=1
    %Creation of an AWGN signal which will excite FEXT and NEXT PSDs
    noise = fft(awgn(zeros(1,256),0));
    test2=1
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

    for j=1:256
        dspFEXT(j) = abs(noise(j))^2*dspFEXT(j);
        dspNEXT(j) = abs(noise(j))^2*dspNEXT(j);
    end

    NEXT = dspNEXT;

    for j=1:256
        crossed_signal(j) = sig(j)+dspFEXT(j)+dspNEXT(j);
    end
    
k = 1.38*10^(-23); %Boltzmann
T = 293.15; %Temperature in Kelvin
B = 1.1*10^6; %Bandwidth in Hz 
PNo =10*log10( k*T*B); %Noise power
%Psig = 10*log10(abs(mean(sig)).^2) %Signal power
%Psig=600; %puissance émise =1 W
%n = 544; %Number of information bits per symbol OFDM
%snr = Psig-PNo + 10*log10(n)
%Psig=
%snr=Psig/PNo
%snrDb=10*log10(snr);

%Create AWGN


if (crosstalk ==1)&&(awgn_channel==1)
    calculate_signal=awgn(crossed_signal,snr);
    out_signal = [calculate_signal(1:256) 0 conj(fliplr(calculate_signal(2:256))) ];
    
elseif (crosstalk==1) && (awgn_channel==0)
    out_signal=[crossed_signal(1:256) 0 conj(fliplr(crossed_signal(2:256)))];
    
elseif (crosstalk==0) && (awgn_channel==1)
    noised_signal=awgn(sig,snr);
    out_signal=[noised_signal(1:256) 0 conj(fliplr(noised_signal(2:256)))];
    
else
    out_signal=[sig(1:256) 0 conj(fliplr(sig(2:256)))];
end
    

    
