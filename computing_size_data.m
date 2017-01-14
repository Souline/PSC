function size_to_generate = computing_size_data(max_amount_bits)
        
    max_amount_bits = max_amount_bits*68;
    taille_fast_buffer=floor(max_amount_bits/2);                                         
    taille_interleaver_buffer=max_amount_bits-taille_fast_buffer;               
    taille_interleaver_buffer = taille_interleaver_buffer -12;               
    taille_fast_buffer = taille_fast_buffer - (8*(240-224))*(floor(taille_fast_buffer/(8*240)))-8;         
    taille_interleaver_buffer = taille_interleaver_buffer - (8*(240-224))*(floor(taille_interleaver_buffer/(8*240)))-8;    
    size_to_generate = taille_fast_buffer + taille_interleaver_buffer;          
end