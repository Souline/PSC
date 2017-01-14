function [ supertrame_bin, x ] = demodulationDMT( signal_recu, h_eval_mod, tab )
% inputs :
% - signal_recu : signal re�u apr�s passage dans le canal
% - h_eval_mod : module de la r�ponse impulsionnelle du canal, identifi�e
% - nb_canaux : nombre de canaux utilis�s
% - lgre_pref_cyclique : longueur du CP
% - tab : vecteur table allocation des bits
%
% outputs : suite_bits et x
%
signal_recu = signal_recu/100;
figure(70)
plot(real(signal_recu));hold on;plot(imag(signal_recu), 'g');
title('Entr�e d�modulateur');

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
    %% Suppression du pr�fixe cyclique

    trame = signal_recu(544*(i-1) + 33:i*544);
    n = 1;

    %% FFT et �galisation du signal

    x_fft = fft( trame );
    x = x_fft( 1:256 );% suppression des coordonn�es conjugu�es introduites avant IFFT
    x_freq = [x_freq x];
    x = x./h_eval_mod; % �galisation
    x_fin = [x_fin x];

    %% Reconstruction des symboles et d�modulation

    suite_bits = [];
    for j = 1:256
        nb_bits = tab(j);
        if nb_bits ~= 0 
            symb = (MQAMDemod(2^nb_bits, x(n)));
            suite_bits = [suite_bits symb];
            n = n + 1;
        else
            continue;
        end
    end
    supertrame_bin = [supertrame_bin suite_bits];
    numel(supertrame_bin);
end

figure(212)
subplot(211)
plot(real(x_fin));hold on; plot(imag(x_fin), 'g');
title('signal �galis�');
subplot(212)
plot(real(x_freq));hold on;plot(imag(x_freq), 'g');
title('Signal � la r�ception en fr�quence');


end