function [ supertrame_bin, x ] = demodulationDMT( signal_recu, h_eval_mod, tab )
% inputs :
% - signal_recu : signal reçu après passage dans le canal
% - h_eval_mod : module de la réponse impulsionnelle du canal, identifiée
% - nb_canaux : nombre de canaux utilisés
% - lgre_pref_cyclique : longueur du CP
% - tab : vecteur table allocation des bits
%
% outputs : suite_bits et x
%
signal_recu = signal_recu/100;
figure(70)
plot(real(signal_recu));hold on;plot(imag(signal_recu), 'g');
title('Entrée démodulateur');

figure(700)
plot(real(h_eval_mod));hold on;plot(imag(h_eval_mod), 'g');
supertrame_bin = [];
nb_bit_per_frame = sum(tab);
iteration = numel(signal_recu)/544;
x_fin = [];
x_freq = [];
%P=50;

%signal_recu = signal_recu/P;

for i=1:iteration
    %% Suppression du préfixe cyclique

    trame = signal_recu(544*(i-1) + 33:i*544);
    n = 1;

    %% FFT et égalisation du signal

    x_fft = fft( trame );
    x = x_fft( 1:256 );% suppression des coordonnées conjuguées introduites avant IFFT
    x = round(x);
    x = x./h_eval_mod; % égalisation

    %% Reconstruction des symboles et démodulation

    suite_bits = [];
    for j = 1:256
        nb_bits = tab(j);
        if nb_bits ~= 0 
            symb = (MQAMDemod(2^nb_bits, x(n)));
            suite_bits = [suite_bits symb];
            n = n + 1;
        else
            % please read repartitor.m, you can find that when a channel is allocated with 0 bit,
            % the ofdm_symbol vector will have a zero at its corresponding position, therefore 
            % after you do ifft and fft, there will be an entry in x vector which does not match 
            % the original information bit. You need to set the pointer'n' + 1 in this situation as well
            % to make the pointer has a correct position.
            n = n + 1;
            continue;
        end
    end
    supertrame_bin = [supertrame_bin suite_bits];
    numel(supertrame_bin);
end

figure(212)
subplot(211)
plot(real(x_fin));hold on; plot(imag(x_fin), 'g');
title('signal égalisé');
subplot(212)
plot(real(x_freq));hold on;plot(imag(x_freq), 'g');
title('Signal à la réception en fréquence');


end
