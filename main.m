%This function simulate the functionning of an ADSL modem
%In : l length of the line, n number of copper-pair lines, d desadaptation
%(ohm) from 1 to 100, snr is the global snr of the system
%Out : gene_init is the binary flow generated at the emitter, received_data
%is the flow of bits received at the reciever, error is the difference
%between the two binary flows 

function [gene_init, received_data, error] = main(l, n, d, snr)

    N = 1; %N is the number of superframe to generate
    poly = [8 4 3 2 0]; %Generator polynome for encoding
    
    [allocation_table_bits, data_size, estimated_channel] = allocation_table(l, n, d, snr);
    
    received_data = [];
    
    %Data generation
    gene_init = gene_bits(N*data_size,0.5);
    
    generated = numel(gene_init)
    
    for k=1 : N
        
        encoded_data=[];
        
        %Encoding of Fast Data and Interleaved Data
        encoded_fast_data = codage_canal(gene_init(1:floor(data_size/2)+6), poly, 0);
        encoded_interleaved_data = codage_canal(gene_init(floor(data_size/2)+7:data_size), poly, 1);
    
        sizeFA = numel(encoded_fast_data);
        sizeINT = numel(encoded_interleaved_data);
    
        encoded_data = [encoded_fast_data encoded_interleaved_data];
        
        size_encoded = numel(encoded_data)
        
        %Modulation
        modulated_data = repartitor(encoded_data, allocation_table_bits);
        
        figure(20)
        plot(real(modulated_data));hold on;plot(imag(modulated_data), 'g');
        title('Signal modulé en temps')
    
        size_modulated = numel(modulated_data)

        %Sending signal through the channel
        perturbated_data = canal(modulated_data, l, n, d, snr, 0);
        
        figure(21)
        plot(real(perturbated_data));hold on;plot(imag(perturbated_data), 'g');
        title('Signal perturbé')
    
        size_perturbated = numel(perturbated_data)
            
        %demodulation
        demodulated_signal = demodulationDMT(perturbated_data, estimated_channel, allocation_table_bits);
        
        figure(22)
        plot(real(demodulated_signal));hold on;plot(imag(demodulated_signal), 'g');
        title('Signal démodulé');
        
        size_demod = numel(demodulated_signal)
    
        %decoding
        received_data = [ received_data decodage_canal(demodulated_signal(1:sizeFA), poly, 0)' decodage_canal(demodulated_signal(sizeFA+1:sizeFA+sizeINT), poly, 1)'];
    
        gene_rcv = numel(received_data)
    
    end
    
    error = received_data - gene_init;

    figure(23)
    plot(error);
    title('Erreur');
    
    %BER computing
    BER = 0;
    for k=1:numel(error)
        if error(k) ~= 0
            BER = BER + 1;
        end
    end
    BER = BER/numel(error)

end