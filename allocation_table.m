%This function aims to initialize ADSL modem by evaluating the channel
%In : l, n , d, snr parameters of the channel. Please see in main.m what do
%each value correspond to
%Out : bits_allocation_table wich contains the number of bits to send on
%each sub-channel, data_size_min is the size of a superframe without the
%encoding bits, H_estime is the estimation of channel's frequency response

function [bits_allocation_table, data_size_min, H_estime] = allocation_table(l, n, d, snr)
    
    % catching the SNR values table and the estimation of the channel
    [SNR_table, H_estime] = process_SNR_Unique(l, n, d, snr);
    
    %for each sub-channel, compute the number of bits associated
   
    bits_allocation_table=zeros(1,256);
    
    up_SNR = max(SNR_table);
    down_SNR = min(SNR_table);
    
    distribution = linspace(down_SNR, up_SNR, 16);
    
    bits_allocation_table(1)=0;
    for k=2:256
        j=1;
        while SNR_table(k) > distribution(j)
            j = j + 1;
        end
        bits_allocation_table(k) = j - 1;
    end
    
    figure(10);
    plot(bits_allocation_table);
    title('Table d allocation des bits');
    
    %Catching the size of a superframe
    sum_bits = sum(bits_allocation_table);
    data_size_min = computing_size_data(sum_bits);
    
end
