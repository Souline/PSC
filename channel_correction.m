%function [ transfert_fct ] = channel_correction(estimation_number)

    allocation_table(1:256) = 4;
    Summ = zeros(1,256);
    trame_test =randi([0,1], [1,8*256]);
    
    trame_init_module = modulationDMT(trame_test, 256, allocation_table);
    
    HF=modelisation_canal();
    
    h=ifft(HF,'symmetric');
    
    trame_after_channel=conv(trame_init_module,h);
        
    trame_after_channel_infreq=fft(trame_after_channel);
    
    trame_after_channel_infreq=trame_after_channel_infreq(1:256)/2;

    % Average of 3 frames
    for frame = 1:estimation_number
        [trame_after_channel_and_noise,noisePower]=BruitLigne(trame_after_channel_infreq,24.71);   
        Summ = Summ + trame_after_channel_and_noise;
    end
    SigInputFr = Summ / estimation_number;
        
    trame_init_freq = fft(trame_init_module(33:544));
    
    transfert_fct = (trame_init_freq(1:256)/2)./SigInputFr;
    
    Estimation_canal = SigInputFr ./ (trame_init_freq(1:256)/2);
    
    Comp = transfert_fct .* HF(1:256);
    
    figure
    subplot(211);
    plot(10*log10(abs(Comp))) ;
    subplot(212);
    plot(ifft(Comp, 'symmetric')) ;
    figure
    subplot(211);
    plot(10*log10(abs(Estimation_canal))) ;
    subplot(212);
    plot(ifft(Estimation_canal, 'symmetric'));
    
%end

