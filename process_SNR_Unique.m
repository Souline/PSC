function [SNR_table,canal_behavior] = process_SNR(prefix_cyclic)

    table (1:256) = 8;
    trame_test=randi([0,1],[1,10000]);
    %modulation
    trame_init_module =modulationDMT(trame_test,256,table,sum(table),prefix_cyclic);
     
    H_in_freq=modelisation_canal();
    h=ifft(H_in_freq,'symmetric');
    H_in_freq=H_in_freq(1:256);
    % convolution symbolisant la transmission dans le canal
    trame_after_channel=conv(trame_init_module,h,'same');

    freq=(0:4.3125e3:1.104e6);
    trame_after_channel_infreq=fft(trame_after_channel);
    trame_after_channel_infreq=trame_after_channel_infreq(1:256)*2;
    %figure
    %subplot(3,1,1);
    %plot(trame_init_module);
    %subplot(3,1,2);
    %plot(h(1:50));
    %subplot(3,1,3);
    %plot(trame_after_channel);
    [trame_after_channel_and_noise_infreq,noisePower]=BruitLigne(trame_after_channel_infreq,24.71);
    
    
    %Je prend la moiti??? des symboles car le vecteur est sym???trique
   
    
    %figure
    %title('trame_after_channel_infreq')
    %plot(freq(1:256),abs(trame_after_channel_infreq))
    %j'applique la fonction de bruitage du canal
    
    %Je calcule le SNR P.SIGNAL - P.BRUIT
    SNR_table=10*log10((abs(trame_after_channel_and_noise_infreq)).^2) - noisePower(1:256);
   
    %FFT de la trame initiale qui est en temps 
    trame_init_in_freq=fft(trame_init_module(1+prefix_cyclic:512+prefix_cyclic));
    trame_init_in_freq=trame_init_in_freq(1:256);
    lolo= 10*log10(abs(trame_init_in_freq).^2);
    %%%%Calcul du comportement du canal ? travers le signal pilote re?u
    canal_behavior=trame_init_in_freq./trame_after_channel_and_noise_infreq;
    figure
    plot(SNR_table)
    %%%%%%%%%%%%%%%DEMO de H et de 1/H
     %figure
     %plot(freq(1:256),abs(H_in_freq));
     %title('H')
     %figure
     %plot(freq(1:256),abs(1./canal_behavior));
     %title('1/H')
    
    
     
    
    
    
   