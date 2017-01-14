function [gene_init, received_data] = main(l, n, d, snr)

    N = 1;
    [allocation_table_bits, SRN_table, data_size, estimated_channel] = allocation_table(l, n, d, snr);
    poly = [8 4 3 2 0];
    received_data = [];
    
    gene_init = gene_bits(N*data_size,0.5);
    
    generated = numel(gene_init)
    
    for i=1 : N
        
        encoded_data=[];
        
        encoded_fast_data = codage_canal(gene_init(1:floor(data_size/2)+6), poly, 0);
        encoded_interleaved_data = codage_canal(gene_init(floor(data_size/2)+7:data_size), poly, 1);
    
        sizeFA = numel(encoded_fast_data);
        sizeINT = numel(encoded_interleaved_data);
    
        encoded_data = [encoded_fast_data encoded_interleaved_data];
        
        size_encoded = numel(encoded_data)
    
        modulated_data = repartitor(encoded_data, allocation_table_bits);
        %figure(73)
        %plot(real(modulated_data));hold on;plot(imag(modulated_data), 'g');
        %title('Signal module')
    
        size_modulated = numel(modulated_data)

        perturbated_data = canal(modulated_data, l, n, d, snr, 1, 1);
        %figure(83)
        %plot(real(perturbated_data));hold on;plot(imag(perturbated_data), 'g');
        %title('Signal reçu')
    
        size_perturbated = numel(perturbated_data)
    
        %demodulation
        demodulated_signal = demodulationDMT(perturbated_data, estimated_channel, allocation_table_bits);
        %figure(807)
        %plot(real(demodulated_signal));hold on;plot(imag(demodulated_signal), 'g');
        %title('Signal démodulé');
        size_demod = numel(demodulated_signal)
    
        
    
      %decodage
        received_data = [ received_data decodage_canal(demodulated_signal(1:sizeFA), poly, 0)' decodage_canal(demodulated_signal(sizeFA+1:sizeFA+sizeINT), poly, 1)'];
    
        %received_data = (received_data)';
        gene_rcv = numel(received_data)
        %figure(817)
        %plot(real(received_data));hold on;plot(imag(received_data), 'g');
        %title('Signal décodé');
    
    end
    error = received_data - gene_init;

    figure(911)
    plot(error);
    title('Erreur');
    
    %calcul du BER
    BER = 0;
    for i=1:numel(error)
        if error(i) ~= 0
            BER = BER + 1;
        end
    end
    BER = BER/numel(error)
    
    %figure(42)
    %plot(demodulated_data)

end