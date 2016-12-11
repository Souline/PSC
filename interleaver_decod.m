function [desinterleaved_data_stream] = interleaver_decod(data_stream)

    index_tab = [];
    matrix = [];
    desinterleaved_data_stream = [];
    
    for i=1:length(data_stream)/8
        index_tab = [ index_tab i];
        for j=1:8
            matrix(i,j) = data_stream((i-1)*8 + j);
        end
    end
    
    random_index = randintrlv(index_tab, 0);
    
    for i=1:length(data_stream)/8
        desinterleaved_data_stream = [ desinterleaved_data_stream matrix(find(random_index==i),:) ];
    end
    
end

