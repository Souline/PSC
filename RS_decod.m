function [  codeword ] = RS_decod( trame, N, n, m, k )
    %decodeur RS
    msg = bitStream_to_gf(trame, n); % conversion from binary to decimal
    msg = gf(msg,m); % gallois field creation

    codeword = rsdec(msg,n,k); % RS coding
    codeword=gf_to_bin(codeword,m);  %conversion from decimal to binary
    codeword=codeword(1:N);
    
end

