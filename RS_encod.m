% param
% @trame bit stream to be coded
% @n size of the RS_codeword (k+redundancy) in nb of RS Symbol
% @m dimension of the RS symbol
% @k size of information in nb of RS Symbol
function [ code ] = RS_encod( trame, n, m, k )
    %encodeur RS
    msg = bitStream_to_gf(trame, k); % conversion from binary to decimal

    msg_gf = gf(msg,m); % gallois field creation
    code = rsenc(msg_gf,n,k); % RS coding
    code=gf_to_bin(code,m);  %conversion from decimal to binary
    
end

