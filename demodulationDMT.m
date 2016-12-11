function [suite_bits]=demodulationDMT(signal_recu,nombre_canaux, table, prefixe_cyclique, total_bit) %pr?fixe ciclique ? ajouter
    % signal_recu : signal re?u apr?s passage dans le canal
    % h_eval_mod module de la r??ponse impulsionnelle du canal, identifi??e
    % nombre_canaux nombre de canaux utilis??s
    % prefixe_cyclique longueur du CP
    % tab vecteur table allocation des bits
    
    %% Init
    N=nombre_canaux;                        % Nombre de canaux utilis??s
    v=prefixe_cyclique;                     % Longueur du CP 
    %total_bit = sum(table);
    puissance_par_bit = 0.28/total_bit;
   
    %% Suppression CP
    signal_recu = signal_recu(v+1:512+v);
    %% Egalisation
    
    %% FFT
    x_fft = fft(signal_recu); 
    x=x_fft(1:N);                                               % suppression des coordonn?es conjugu?es introduites avant IFFT    
    %scatterplot(x);
    
    %% d?modulation
    symb=[];                                                    % Contiendra les symboles sous forme d?cimale
    for i=1:N
       if table(i) ~= 0 
        qref = qammod([0:2^(table(i))-1],2^(table(i)));
        correction_qam = modnorm(qref,'avpow',table(i)*puissance_par_bit);
        x(i)= x(i) / correction_qam;
        symb(i)=qamdemod(x(i),2^(table(i)));
        x(i)= x(i)*correction_qam;
       else 
        symb(i)=100000;
       end

    end
    %% Reconstruction symb/
    suite_bits=[]; 
    for j=1:N
        if symb(j) ~= 100000
            symbol = decodage_symboles(symb(j),2^(table(j)));
            %fprintf('i: %d symb: %d %d %d %d\n',j,symbol(1),symbol(2),symbol(3),symbol(4));
            suite_bits=[suite_bits symbol]; 
        end
    end
    
    
end


