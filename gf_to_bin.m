% convert gf array into binary stream
function [ data ] = gf_to_bin( gf, m )
    % gf array fo convert
    % m length of gf symbol
    data=[];
    data_dec=gf.x;
    [lin, col]= size(data_dec);
    
    for l = 1:lin 
        for c = 1:col
           bin=dec2bin(data_dec(l,c),m);
           data=horzcat(data,bin);
        end
    end   
    data=data-'0';

end

