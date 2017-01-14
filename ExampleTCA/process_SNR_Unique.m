function [SNR_table,H_estime, power] = process_SNR_Unique()

    table (1:256) = 2; %table d'allocation des bits provisoire
    
    %Generation du signal pilote
    trame_test = zeros(1,512);
    trame_test(1:9) = 1;
    for i = 10:512
        trame_test(i) = bitxor(trame_test(i-4), trame_test(i-9));
    end
    trame_test
    trame_init_module=repartitor(trame_test, table);
    trame_after_channel = [];
    
    for i = 1 : 29
        %modulation
        superframe_init_module = [trame_init_module trame_init_module];
        trame_after_channel = [trame_after_channel canal(trame_init_module, 1000, 64, 0)];
    end
    %envoi a travers le canal
    %trame_after_channel=canal(trame_init_module, 1000, 1, 0);
    
    %estimation du niveau de bruit
    SNR_table = zeros(1,256);
    abs(trame_after_channel(10))
    abs(trame_init_module(10))
    for i=1:256
        for j=0:28
            SNR_table(i)= SNR_table(i) + 10*log10(abs(trame_after_channel(j*512+i).^2 - (trame_init_module(i)).^2-trame_after_channel(j*512+i).^2));
        end
        SNR_table(i)=SNR_table(i)/30;
        %if SNR_table(i) <= 10
        %    power(i) = power(i).^2;
        %elseif SNR_table(i) <= 5
        %    power(i) = power(i).^4;
        %else
        %   'Power is ok'
        %end
    end
    
    trame_after_channel = fft(trame_after_channel);
    
    H_estime=zeros(1,256);
    %estimation du filtre équivalent au canal
    for i=1 : 256
        for j=0:28
            H_estime(i)=H_estime(i)+(trame_after_channel(j*512+i)/superframe_init_module(i));
        end
    end
    
    %H_in_freq=channel_filter(1000, 0);                                        % le fonction H du canal
    %h=ifft(H_in_freq,'symmetric');                                         % transformation en domaine de temps
    %H_in_freq=H_in_freq(1:256);
    
    %trame_after_channel=conv(trame_init_module,h,'same');                  % convolution symbolisant la transmission dans le canal

    %freq=(0:4.3125e3:1.104e6);
    %trame_after_channel_infreq=fft(trame_after_channel);                   
    %trame_after_channel_infreq=trame_after_channel_infreq(1:256)*2;
    %figure
    %subplot(3,1,1);
    %plot(trame_init_module);
    %subplot(3,1,2);
    %plot(h(1:50));
    %subplot(3,1,3);
    %plot(trame_after_channel);
    %[trame_after_channel_and_noise_infreq,noisePower]=BruitLigne(trame_after_channel_infreq,24.71);
    
    
    %Je prend la moiti??? des symboles car le vecteur est sym???trique
   
    
    %figure
    %title('trame_after_channel_infreq')
    %plot(freq(1:256),abs(trame_after_channel_infreq))
    %j'applique la fonction de bruitage du canal
    
    %Je calcule le SNR P.SIGNAL - P.BRUIT
    %SNR_table=10*log10((abs(trame_after_channel_and_noise_infreq)).^2) - noisePower(1:256);
   
    %FFT de la trame initiale qui est en temps 
    %trame_init_in_freq=fft(trame_init_module(1+prefix_cyclic:512+prefix_cyclic));
    %trame_init_in_freq=trame_init_in_freq(1:256);
    %lolo= 10*log10(abs(trame_init_in_freq).^2);
    %%%%Calcul du comportement du canal ? travers le signal pilote re?u
    %canal_behavior=trame_init_in_freq./trame_after_channel_and_noise_infreq;
    figure
    plot(SNR_table)
    title('SNR table')
    %%%%%%%%%%%%%%%DEMO de H et de 1/H
     %figure
     %plot(freq(1:256),abs(H_in_freq));
     %title('H')
     %figure
     %plot(freq(1:256),abs(1./canal_behavior));
     %title('1/H')
    
    
     
    
    
    
   
