function [nb_bits, sum_bits] = bit_allocation(rep_freq, noise_tab)

    sum_G = 0;
    nb_sub_channel = 256; %useful channels
    old_nb_sub_channel = 0;
    sum_bits = 0;
    gamma = 9.44; %QAM transmission and error rate = 10e-7
    channel_power = zeros(1,nb_sub_channel);
    
    % loop to calculate the new constant and the total power
    %while old_nb_sub_channel ~= nb_sub_channel
        
        % we calculate the total power to send
        total_power = 0.28; 
        
        % for each channel
        for i = 1:nb_sub_channel
            var(noise_tab(i));
            gn(i) = power(abs(rep_freq(i)),2)/noise_tab(i);
            sum_G = sum_G + (1/gn(i));
        end
                
        % we calculate the constant
        constant = (total_power + gamma * sum_G) / nb_sub_channel;
        
        for i = 1:nb_sub_channel
            channel_power(i) = constant - gamma/gn(i); 
            % if the power to give is negative
            if(constant - channel_power(i)) < 0
                old_nb_sub_channel = nb_sub_channel;
                nb_sub_channel = i-1;
                break;
            end
        end
    %end
    
    nb_bits = zeros(1, nb_sub_channel);
    
    % we calculate the number of bits
    for i = 1:nb_sub_channel
        SNR = channel_power(i) * power(abs(rep_freq(i)),2) / power(noise_tab(i),2);
        nb_bits(i) = floor(4.3125e3*log2(1 + SNR / gamma)/4000);
        sum_bits = sum_bits + nb_bits(i);
    end
    
    if mod(sum_bits, 2) == 1
        sum_bits = sum_bits - 1;
        nb_bits(nb_sub_channel) = nb_bits(nb_sub_channel) - 1;
    end
end
