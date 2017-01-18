%This function estimates channel's behaviour
%In : Channel's characteristics (please see main.m for further informations
%about l, n, d and snr)
%Out : SNR_table contains the SNR of each sub-channel, H_estime is the
%estimation of channel's behaviour

function [SNR_table,H_estime] = process_SNR_Unique(l, n, d, snr)

    table (1:256) = 2; %Temporary allocation table 
    
    %Pilot signal generation
    trame_test = zeros(1,512);
    trame_test(1:10) = 1;
    for k = 10:512
       trame_test(k) = bitxor(trame_test(k-4), trame_test(k-9));
    end
    
    
    
    %Pilot signal modulation
    trame_init_module=repartitor(trame_test, table);
    
    trame_after_channel = zeros(1,544);
    superframe_init_module = [];
    
    %We send 30 times the same frame through the channel in order to create an average
    for k = 1 : 30
        superframe_init_module = [superframe_init_module trame_init_module];
        trame_int = canal(trame_init_module, l, n, d, snr, 1);
        trame_after_channel = trame_after_channel + trame_int;
    end
    
    %Noise deletion
    trame_after_channel = trame_after_channel./30;
    
    %Switching to frequency domain
    trame_after_channel = fft(trame_after_channel);
    trame_init_module = fft(trame_init_module);
    
    %Computing of channel's behaviour
    H_estime = trame_after_channel./trame_init_module;
    
    %Noise estimation on each sub-channel and asssociated SNR
    Noise = (trame_after_channel - H_estime*trame_after_channel')./trame_init_module;
    SNR_table = trame_after_channel./Noise;
    Noise=Noise(33:288);
    SNR_table = SNR_table(33:288);
    
    figure(11)
    plot(real(Noise));
    title('Bruit estimé');
    
    figure(12)
    plot((1:256),20*log10(H_estime(33:288)));
    title('Réponse fréquentielle estimée en échelle log');
    
    h_estime = ifft(H_estime);
    
    figure(13)
    plot(real(h_estime));hold on;plot(imag(h_estime), 'g');
    title('Réponse impulsionnelle estimée');
    
    SNR_table = real(SNR_table);
    
    figure(14);
    plot(SNR_table)
    title('SNR sur chaque sous canal')
    
end
    
     
    
    
    
   
