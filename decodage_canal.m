function [ suite_bits_decodee, err ] = decodage_canal( trame, generateur_crc, type_buffer )
% realise the decoding of the channel
%
% the bit string will be decoded first RS and than CRC

% inputs :
% - suite_bits refers to a bit string
% - generateur_crc correspond to CRC generator
%
% output : the decoded bit string
%

if type_buffer == 1
    trame = deinterleaver( trame, 3, 2 );
end

taille_trame = length( trame );

% RS
N_check = floor( taille_trame / ( 8 * 224 ) );
N_rs = floor( taille_trame / ( 8 * 240 ) );
trame_rs_end = trame( ( N_rs*8*240+1 ):taille_trame );


trame_rs = [];
trame=trame';

if N_check > 0
  for i = 1:N_rs
    encoded = rs_decoding( trame((i-1)*8*240+1:i*8*240), 240, 224 );
    trame_rs = [ trame_rs encoded' ];
  end
  trame_rs=[trame_rs trame_rs_end];
else
  trame_rs = trame';
end
%CRC
[ trame_decode, err ] = decodage_crc( trame_rs, generateur_crc );

suite_bits_decodee=trame_decode;