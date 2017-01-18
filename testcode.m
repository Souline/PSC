clear;
data_size = 53712;
poly = [1 0 1 1 1 0 0 0 1];

% coding
suite_bits = gene_bits(data_size,0.5);
fast_buffer_trame = suite_bits( 1:( floor( data_size/2 ) + 6 ) ); 
interleaved_buffer_trame = suite_bits( ( floor( data_size/2 )+7 ):data_size );   

encoded_data_rn = [codage_canal(fast_buffer_trame, poly, 0) codage_canal(interleaved_buffer_trame, poly, 1)];
size_encoded = length(encoded_data_rn);
 

% decoding
fast_buffer_trame_2 = encoded_data_rn( 1:( floor( (size_encoded) / 2 ) ) );
interleaved_buffer_trame_2 = encoded_data_rn( ( floor( (size_encoded) / 2 )+1 ) : size_encoded );
[decoded_fast_buffer, ~] = decodage_canal(fast_buffer_trame_2, poly, 0);
[decoded_interleaved_buffer, ~] = decodage_canal(interleaved_buffer_trame_2, poly, 1);
decoded_data_test = [decoded_fast_buffer' decoded_interleaved_buffer'];
size_decode_test = length(decoded_data_test);

% ber 
ber = sum(abs(suite_bits - decoded_data_test)) / data_size;