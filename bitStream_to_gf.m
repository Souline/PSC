% convert a table of bit to a gf array ( k column, 8-bits symbols)
function [d, data] = bitStream_to_gf( bit_stream, k )
    % bit stream flow of bit
    % k length of RS information word
    
    N = length(bit_stream);
    d=[];
    line=1;
    for byte = 0:N/8-1
        dec = 0;
        for i = 1:8 % creating 8-bits symbol
            dec = dec + bit_stream(byte*8+i)*2^(8-i);
        end            
        
        if (mod(byte,k) == 0) && (byte ~= 0)
            line = line+1;
        end
        d(line, mod(byte,k)+1)= dec;

    end
    data=gf(d,8);
end

