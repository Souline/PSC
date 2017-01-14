function [superframe] = repartitor(data_input, allocation_table)

ofdm_symbol_length = sum(allocation_table)
ofdm_symbol = zeros(1,256);
size_input = size(data_input, 2);
iteration = size_input/ofdm_symbol_length %we assume that size_input is a multiple of ofdm_symbol_length
compteur_bits = 1;
superframe = [];

Power = 100;

for i = 1 : iteration
    for j=1:256
        nb_bits = allocation_table(j);
        if nb_bits ~= 0
            ofdm_symbol(j) = MQAM(2^nb_bits, data_input(compteur_bits:(compteur_bits+nb_bits-1)));
            compteur_bits = compteur_bits+nb_bits;
        else
            continue;
        end
    end
    %ending of modulation with ifft%
    
    frame = [ 0 ofdm_symbol(1:256) 0 fliplr(conj(ofdm_symbol(1:256)))];
    frame = ifft(frame);
    %figure(534)
    %plot(real(frame));hold on;plot(imag(frame), 'g');
    frame = Power*frame;
    %figure(112)
    %plot(real(frame));hold on;plot(imag(frame), 'g');
    
    %adding cyclic prefix
    frame = [ frame(length(frame)-31:length(frame)) frame(1:512) ];
    superframe = [superframe frame];
end
    numel(superframe)
end