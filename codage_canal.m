% channel coding for generated bits and decides if we need interleaving according to the type_buffer
% inputs:
%  suite_bits£ºincoming bit string(fast channel interleaving channel)
% generateur_crc£ºCRC generator
% type_buffer£ºindicates the type of channel

% output£º
% suite_bits_codee£ºbit string after coding

function suite_bits_codee = codage_canal( suite_bits, generateur_crc, type_buffer )

% CRC coding
trame_crc = codage_crc( suite_bits', generateur_crc );
trame_crc = trame_crc';    

taille_trame = length( trame_crc );

% RS coding
% every 8 bits generate a decimal number
% in the RS word, there is 224 for information and 240 in total
N_rs = floor( taille_trame / ( 8 * 224 ) );    
 
% those bits which are not enough to create a new RS word in the end
trame_rs_end = trame_crc( ( N_rs*8*224+1 ):taille_trame ); 
trame_rs = [];


if N_rs > 0
  for i = 1:N_rs
     % coding every 8*224 bits(a RS word)
    encoded_trame = rs_encoding( trame_crc((i-1)*8*224+1:i*8*224), 240, 224 );
    % add the bits which has been RS coded to the end of the output
    trame_rs = [ trame_rs encoded_trame' ];
  end
  % add the rest part of RCR coding to the end of output
  trame_rs_total = [ trame_rs trame_rs_end ];
else
  % if not enough to do RS just do CRC
  trame_rs_total = trame_crc;
end
trame_finale = trame_rs_total;

% see if it is interleaving channel
if type_buffer == 1
  trame_finale = interleaver( trame_finale, 3, 2 );
end

suite_bits_codee = trame_finale;

end