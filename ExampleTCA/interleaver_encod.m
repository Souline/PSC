function [Interleaved_data_stream] = interleaver_encod(data_stream)
    
    index_tab = [];
    matrix = [];
    Interleaved_data_stream = [];
    
    for i=1:length(data_stream)/8
        index_tab = [ index_tab i];
        for j=1:8
            matrix(i,j) = data_stream((i-1)*8 + j);
        end
    end
    
    random_index = randintrlv(index_tab, 0);
    
    for i=1:length(data_stream)/8
        Interleaved_data_stream = [ Interleaved_data_stream matrix(random_index(i),:) ];
    end
end
