function [ trame_decode, err ] = decodage_crc( trame, generateur )
% CRC decoding
%
% inputs :
% - bit string waiting for CRC decoding
% - CRC generator
%
% output is transpose of the result of CRC decoding

% n=taille(trame); m=taille(generateur-1);
% reste= reste de division euclidienne de trame par generateur
% if reste=suite de 0 pas de erreur else avec erreur

d = comm.CRCDetector( generateur );
[ trame_decode, err ] = step( d, trame' );
