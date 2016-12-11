function [HT] = modulationDMT(suite_bits,nb_canaux,table, total_bit, prefix_cyclic)
% La fonction suivante permet de moduler notre suite binaire en OFDM puis DMT
% suite_bits : tableau de bits
% nb_canaux : bn de canaux en int
% table : tableau de int ( table d'allocation des bits )

    index = 1;
    suite_symboles=zeros(1,nb_canaux);
    coefficients=zeros(1,nb_canaux);
    %total_bit = sum(table);
    %disp(total_bit);
    puissance_par_bit = 0.28/total_bit;
    
    
    for i=1:(nb_canaux)                                                                         % parcours des canaux
        if(table(i) ~= 0)      
            suite_symboles(i) = bin2dec(num2str(suite_bits(index:index+table(i)-1), '%1d'));    % cr??ation de nos symboles
            coefficients(i) = qammod(suite_symboles(i),2^(table(i)));                           % Modulation QAM
            qref = qammod([0:2^(table(i))-1],2^(table(i)));
            correction_qam = modnorm(qref,'avpow',table(i)*puissance_par_bit);
            coefficients(i)=coefficients(i)*correction_qam;                                                                                    %adaptation de puissance
            index=index+table(i);
        else
            coefficients(i) = 0;
        end
    end

    
    
    %scatterplot(coefficients);

    HF = [coefficients(1:256) 0 conj(fliplr(coefficients(2:256))) ];        % Sym??trie hermitienne
    HT = ifft(HF);                                                          % Modulation DMT
    HT = [ HT(length(HT)-prefix_cyclic+1:length(HT)) HT(1:512) ];                                         % ajout du CP 

end
