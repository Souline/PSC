function [SNR_table,H_estime, power] = process_SNR_Unique(l, n, d, snr)

    table (1:256) = 2; %table d'allocation des bits provisoire
    
    %Generation du signal pilote
    trame_test = zeros(1,512);
    trame_test(1:9) = 1;
    for i = 10:512
        trame_test(i) = bitxor(trame_test(i-4), trame_test(i-9));
    end
    
    %modulation de la trame test
    trame_init_module=repartitor(trame_test, table);
    trame_after_channel = [];
    
    %creation des trames totales
    %Trame module et trame deformee par le canal
    for i = 1 : 29
        superframe_init_module = [trame_init_module trame_init_module];
        trame_after_channel = [trame_after_channel canal(trame_init_module, l, n, d, snr, 1, 1)];
    end
    
    %Calcul de la table de SNR qui permet de definir la table d'allocation
    %des bits
    %La table est constituee de la moyenne des SNR des 30 iterations
    %d'envoi
    SNR_table = zeros(1,256);
    
    %on passe en frequentiel pour estimer le filtre en frequence
    trame_after_channel = fft(trame_after_channel);
        
    H_estime=zeros(1,256);
    
    for i=1:29
        trame = trame_after_channel((i-1)*544+33:544*i);
        trame = trame(1:256);
        H_estime = H_estime + trame./superframe_init_module(33:288);
    end
    
    %H_estime = H_estime./30;
    h_estime = ifft(H_estime);
    
    figure(817)
    plot(real(h_estime));hold on;plot(imag(h_estime), 'g');
    title('Réponse impulsionnelle du canal estimée');
    
    Noise = zeros(1,256);
    
    %estimation du bruit sur chaque sous canal
    for i=1 : 29
        trame = trame_after_channel((i-1)*544+33:544*i);
        trame = trame(1:256);
        Noise = Noise + abs(trame - H_estime*trame')./abs(superframe_init_module(33:288));
    end
    
    noise_dim = size(Noise);
    
    figure(734)
    plot(real(Noise));
    title('Bruit estimé');
    
    for i=1 : 29
        trame = trame_after_channel((i-1)*544+33:544*i);
        trame = trame(1:256);
        SNR_table = SNR_table + abs(trame)./abs(Noise);
    end
    
    SNR_table = real(SNR_table);
    figure(38);
    plot(SNR_table)
    title('SNR_table')
    
end
    
     
    
    
    
   
