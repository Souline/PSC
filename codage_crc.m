
% realize CRC coding
% trame: the bits flux waiting for coding
% generateur: generateur of CRC

function trame_code = codage_crc( trame, generateur )

% generate an objet waiting for coding
g = comm.CRCGenerator( generateur );

% use function step to finish the coding
trame_code = step( g, trame );
