%This function equalizes and demodulate a signal passed in parameters
%In : signal_recu is the signal coming from the channel, h_eval_mod is the
%estimated channel's frequency response and tab is the allocation table
%Out : supertrame_bin is the binary flow (i.e.:demodulated signal)

function [ supertrame_bin] = demodulationDMT( signal_recu, h_eval_mod, tab )

supertrame_bin = [];
nb_bit_per_frame = sum(tab);
iteration = numel(signal_recu)/544;
x_fin = [];
x_freq = [];

%Calculation of channel's inversed response in time 
h_inverse = 1./h_eval_mod;
h_inverse_time = ifft([ 0 h_inverse(34:288) 0 conj(fliplr(34:288))]);%[0 h_inverse(2:288) 0 h_inverse(2:288)]);


for k=1:iteration
    n = 1;
    
    %Frame catching
    trame = signal_recu(544*(k-1)+1:k*544);
    
    %Equalization
    x_egal = filter(h_inverse_time,1, trame);
    
    % Suppression du préfixe cyclique
    x_egal = x_egal(33:544) ;
    
    % Switching to frequency domain

    x_fft = fft( x_egal );
    x = x_egal(1:256);
    
    x_fin=[x_fin x_fft];%Equalized signal
    
    %QAM demodulation

    suite_bits = [];
    for j = 1:256
        nb_bits = tab(j);
        if nb_bits ~= 0 
            symb = MQAMDemod(2^nb_bits, x(n));
            suite_bits = [suite_bits symb'];
            n = n + 1;
        else
            % please read repartitor.m, you can find that when a channel is allocated with 0 bit,
            % the ofdm_symbol vector will have a zero at its corresponding position, therefore 
            % after you do ifft and fft, there will be an entry in x vector which does not match 
            % the original information bit. You need to set the pointer'n' + 1 in this situation as well
            % to make the pointer has a correct position.
            n = n + 1;
            continue;
        end
      
    end
    
    supertrame_bin = [supertrame_bin suite_bits];
end

figure(60)
plot(real(x_fin));hold on; plot(imag(x_fin), 'g');
title('Signal égalisé');


end