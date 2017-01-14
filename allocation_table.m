function [bits_allocation_table, SNR_table, data_size_min, H_estime] = allocation_table(l, n, d, snr)
    
    %Cette fonction renvoi la table d'allocation des bits (en nombre de
    %bits par QAM)
    sums_bit = 0;
    limit = 8*256;
    
    % catching the SNR values table
    [SNR_table, H_estime] = process_SNR_Unique(l, n, d, snr);
    
    %for each sub-channel, compute the number of bits accroding to Shannon
    bits_allocation_table=zeros(1,256);
    
    up_SNR = max(SNR_table);
    down_SNR = min(SNR_table);
    
    distribution = linspace(down_SNR, up_SNR, 16);
    
    for i=1:256
        j=1;
        while SNR_table(i) > distribution(j)
            j = j + 1;
        end
        bits_allocation_table(i) = j - 1;
    end
    
    figure(254);
    plot(bits_allocation_table);
    title('Table d allocation des bits');
    
    sum_bits = sum(bits_allocation_table)
    data_size_min = computing_size_data(sum_bits);
    
end
