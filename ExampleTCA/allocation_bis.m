function [ table, sum_bits, canal_behavior, SNR_table ] = allocation_bis( prefix_cyclic)
%ALLOCATION_BIS Summary of this function goes here
%   Detailed explanation goes here
    % catching the SNR values table
    [SNR_table, canal_behavior] = process_SNR_Unique(prefix_cyclic);
    table = zeros(1,256);
    
    for i= 1:256 
        snr = SNR_table(i);
        if snr < 15.8
            table(i) = 0;
        elseif snr < 18.8 
            table(i)=2;
        elseif snr < 21.8
            table(i)=3;
        elseif snr < 24.8
            table(i)=4;
        elseif snr < 27.8
            table(i)=5;
        elseif snr <30.8
            table(i)=6;
        elseif snr< 33.8
            table(i)=7;
        elseif snr<36.8
            table(i)=8;
        elseif snr < 39.8
            table(i)=9;
        elseif snr < 42.8
            table(i)=10;
        elseif snr < 45.8
            table(i)=11;
        elseif snr<48.8
            table(i)=12;
        elseif snr < 51.8
            table(i)=13;
        elseif snr< 54.8
            table(i)=14;
        else
            table(i)=15; 
        end
    end
    
    sum_bits = sum(table);
    
    % if the sum is a multiple of 8 (need for RS code)
    % we decrement 1 to the last non null sub channel 
    j=256;
    while mod(sum_bits/2,8) ~= 0
        if table(j) ~= 0 
            table(j) = table(j)-1;
            sum_bits = sum_bits - 1;
        end
        j = j - 1;
    end
    

end

