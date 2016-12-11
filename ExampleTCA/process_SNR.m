%function [SNR_table] = process_SNR()

    table (1:256) = 8;
    trame_test=randi([0,1],[1,10000]);
    %modulation
    trame_init_module =modulationDMT(trame_test,256,table);
    trame_init_module_freq = fft(trame_init_module(33:544));
    p_trame_init_module_freq = 10*log10(abs(trame_init_module_freq(1:256)));
    figure(1);
    plot(p_trame_init_module_freq);
    
    HF=modelisation_canal();
    h=ifft(HF,'symmetric');
    % convolution symbolisant la transmission dans le canal
    trame_after_channel=conv(trame_init_module,h);
    freq=(0:4.3125e3:1.104e6);
    %figure
    %subplot(3,1,1);
    %plot(trame_init_module);
    %subplot(3,1,2);
    %plot(h(1:50));
    %subplot(3,1,3);
    %plot(trame_after_channel);
    
    trame_after_channel_infreq=fft(trame_after_channel);
    %Je prend la moiti??? des symboles car le vecteur est sym???trique
    trame_after_channel_infreq=trame_after_channel_infreq(1:256)/2;
    %figure
    %title('trame_after_channel_infreq')
    %plot(freq(1:256),abs(trame_after_channel_infreq))
    %j'applique la fonction de bruitage du canal
    [trame_after_channel_and_noise,noisePower]=BruitLigne(trame_after_channel_infreq,24.71);
    %Je calcule le SNR P.SIGNAL - P.BRUIT
    SNR_table=10*log10(abs(trame_after_channel_and_noise).^2) - noisePower;

    freq=(0:4.3125e3:1.104e6); 
    %figure
    %plot(freq(1:256),SNR_table)
    
    
    
   
