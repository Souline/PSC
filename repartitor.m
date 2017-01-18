%This function implements DMT modulation for a superframe
%In : data_input which is an encoded binary flow, allocation_table which
%contains the number of bits to send on each sub-channel
%Out : superframe_module which contains the modulation of data_input

function [superframe_module] = repartitor(data_input, allocation_table)

ofdm_symbol_length = sum(allocation_table);
ofdm_symbol = zeros(1,256);
size_input = size(data_input, 2);
iteration = size_input/ofdm_symbol_length;
superframe_module = [];

%Frame by frame modulation
for k = 1 : iteration
    sous_trame = data_input( (k-1)*ofdm_symbol_length+1:k*ofdm_symbol_length );
    compteur_bits = 0;
    for j=1:256 
        nb_bits = allocation_table(j);
        if nb_bits ~= 0
            ofdm_symbol(j) = MQAM(2^nb_bits, sous_trame(compteur_bits+1:(compteur_bits+nb_bits)));
            compteur_bits = compteur_bits+nb_bits;
        else
            continue;
        end
    end
    %ending of modulation with ifft%
    
    frame = [ofdm_symbol(1:256) fliplr(conj(ofdm_symbol(1:256)))];
    frame = ifft(frame);
    
    %adding cyclic prefix
    frame = [ frame(length(frame)-31:length(frame)) frame(1:512) ];
    superframe_module = [superframe_module frame];
end
end
