function [bits_allocation_table, sum_bits, canal_behavior, SNR_table] = allocation_table(prefix_cyclic)
    sums_bit = 0;
    limit = 8*256;
    % catching the SNR values table
    [SNR_table, canal_behavior] = process_SNR_Unique(prefix_cyclic);
    
    %for each sub-channel, compute the number of bits accroding to Shannon 
    for i=1:256
        SNR_watt(i) = power(10,SNR_table(i)/10);
        bits_number = floor(log2(1+SNR_watt(i)));
        % We don't want to go over 8 bits of average
        if sums_bit+bits_number < limit
            % We limit it to 15 (Check doc)
            if   bits_number > 15
              bits_allocation_table(i) = 15;
              sums_bit = sums_bit + 15;
            elseif bits_number < 0
              bits_allocation_table(i) = 0;             
            else 
              bits_allocation_table(i) = bits_number;
              sums_bit = sums_bit + bits_number;
            end
        else
            bits_allocation_table(i) = 0;
        end
    end
    
    sum_bits = sum(bits_allocation_table);
    
    % if the sum is a multiple of 8 (need for RS code)
    % we decrement 1 to the last non null sub channel 
    j=256;
    while mod(sum_bits/2,8) ~= 0
        if (bits_allocation_table(j)) ~= 0 
            bits_allocation_table(j) = bits_allocation_table(j)-1;
            sum_bits = sum_bits - 1;
        end
        j = j - 1;
    end
    

end