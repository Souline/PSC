function [signal] = modulationDMTK(suite_bits,nb_canaux,table)
    index = 1;
    suite_symboles=zeros(1,nb_canaux);
    coefficients=zeros(1,nb_canaux);
    for i=1:(nb_canaux)
        if(table(i) ~= 0)      
            suite_symboles(i) = bin2dec(num2str(suite_bits(index:index+table(i)-1), '%1d'));
            coefficients(i) = qammod(suite_symboles(i),2^(table(i)));
            coefficients(i) = modnorm(coefficients(i),'avpow',0.28);%adaptation de puissance
            index=index+table(i);
        else
            coefficients(i) = 0;
        end
    end
    
    coefficients=[coefficients(1:256) 0 conj(fliplr(coefficients(2:256)))];
     signal = ifft(coefficients,'symmetric');
        
end
