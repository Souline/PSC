function [SNR_table,canal_behavior] = process_SNR()

    table (1:256) = 2;
    canal_behavior_final=zeros(1,256);
    SNR_table_final=zeros(1,256);
    H_in_freq=modelisation_canal();
    h=ifft(H_in_freq,'symmetric');
    H_in_freq=H_in_freq(1:256);
    
    for i=1:200
        trame_test=randi([0,1],[1,10000]);
        %modulation
        trame_init_module =modulationDMT(trame_test,256,table);
        % convolution symbolisant la transmission dans le canal
        trame_after_channel=conv(trame_init_module,h,'same');
        freq=(0:4.3125e3:1.104e6);
        trame_after_channel_infreq=fft(trame_after_channel);
        trame_after_channel_infreq=trame_after_channel_infreq(1:256);
        %figure
        %subplot(3,1,1);
        %plot(trame_init_module);
        %subplot(3,1,2);
        %plot(h(1:50));
        %subplot(3,1,3);
        %plot(trame_after_channel);
        [trame_after_channel_and_noise_infreq,noisePower]=BruitLigne(trame_after_channel_infreq,24.71);

        %Je calcule le SNR P.SIGNAL - P.BRUIT
        SNR_table=(10*log10(abs(trame_after_channel_and_noise_infreq).^2)) - noisePower(1:256);
        trame_init_in_freq=fft(trame_init_module(33:544));
        trame_init_in_freq=trame_init_in_freq(1:256);

        canal_behavior=trame_init_in_freq./trame_after_channel_and_noise_infreq;
        canal_behavior_final=canal_behavior_final+ canal_behavior;
        SNR_table_final=SNR_table_final + SNR_table;
    end
    
    % Moyennage du SNR
    SNR_table_final=SNR_table_final/200;
    % Moyennage de l'?tude du canal
    canal_behavior_final=canal_behavior_final/200;
    SNR_table_final
    disp(canal_behavior_final)
    figure
    title('H')
    plot(freq(1:256),H_in_freq);
    figure
    title('1/H')
    plot(freq(1:256),1./canal_behavior_final);
    
    
    
    
    
    
   