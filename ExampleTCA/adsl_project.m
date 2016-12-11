% ADSL project
disp('debut de le simulation...');
warning('off','comm:obsolete:qaskdeco');
close all;

%%%%%%%%%%%%%%%%%%
% Initialisation %
%%%%%%%%%%%%%%%%%%
nombre_canaux=256; % Nombre de canaux pour la simulation
prefix_cyclic=0; % Taille du prefixe cyclique
h=[1 1]; % reponse impulsionnelle du canal
coding_rate = 200/255; % ratio between information and redundancy in RS codeword

%%%%%%%%%%%%%%%%%%
% Calcul du SNR  %
%%%%%%%%%%%%%%%%%%

%H_canal = modelisation_canal();

[bits_allocation_tables, sum_bits_allocated, canal_egalisation, SNR_table ] = allocation_bis(prefix_cyclic);
%bits_allocation_tables =  [ randi([4 4],1, 100) randi([0 0],1, 100) randi([0 0],1 ,56) ];
%sum_bits_allocated = sum(bits_allocation_tables); 

size_trame = sum_bits_allocated; % remove Cyclic prefixe's length
size_supertrame = size_trame*68; % remove 16 to allow CRC to fit in frame 0 
size_RS_word = size_trame / 2; % fast / interleaving

% define information length and redundancy length in RS word
% difference must be even positive integer
k = floor(size_RS_word/8*coding_rate);
if mod(size_RS_word/8-k,2) ~= 0 % test if difference even
    k = k-1;
end

usefull_size_supertrame = k*8*2*68-16; % remove 16 to allow CRC to fit in frame 0 // taille utile
N = usefull_size_supertrame/2*1; % number total of bit

disp('Initialisation et allocation des bits faites...');

%%%%%%%%%%%%%%%%%%
%    Data Init   %
%%%%%%%%%%%%%%%%%%
fast_data_stream = randi([ 0 1 ], 1, N); % generate random fast data bit stream 
inter_data_stream = randi([ 0 1 ], 1, N); % generate random interleaved data bit stream
fast_previous_CRC = zeros(1,8); % CRC for fast data
inter_previous_CRC = zeros(1,8); % CRC for interleaved data
fast_received_previous_CRC = zeros(1,8); % CRC for fast data
inter_received_previous_CRC = zeros(1,8); % CRC for interleaved data

fast_received_data_stream = [];
inter_received_data_stream = [];

sync_symbole = zeros(1,512);

for i = 1:9
    sync_symbole(i) = 1;
end

for i = 10:512
    sync_symbole(i) = xor(sync_symbole(i-4),sync_symbole(i-9));
end

disp('Initialisation de la data...');

%%%%%%%%%%%%%%%%%%
%   Traitement   %
%%%%%%%%%%%%%%%%%%
for half_supertrame = 0:(2*N/usefull_size_supertrame)-1
    fprintf('\n###############################################\n');
    fprintf('Debut du traitement de la supertrame %d...\n',half_supertrame);

    superframe = []; %reseting the superframe array
    
    %%%%%%% Coding and modulating %%%%%%%
    
    % Current part of bit_stream
    fast_data =  [ fast_previous_CRC fast_data_stream(half_supertrame*usefull_size_supertrame/2+1 : (half_supertrame+1)*usefull_size_supertrame/2) ];
    inter_data = [ inter_previous_CRC inter_data_stream(half_supertrame*usefull_size_supertrame/2+1 : (half_supertrame+1)*usefull_size_supertrame/2) ];
    
    % CRC
    fast_previous_CRC = CRC_encod(fast_data);
    inter_previous_CRC = CRC_encod(inter_data);
    disp('Calcul du CRC... fait');

    % Scrambler
    scrambling_sequence = randi([0 1],1,23);
    fast_data_scrambled = scrambler(fast_data,scrambling_sequence);
    inter_data_scrambled= scrambler(inter_data,scrambling_sequence);
    disp('Scrambling... fait');

    % RS
    fast_data_scrambled_coded = RS_encod(fast_data_scrambled, size_RS_word/8, 8, k);
    inter_data_scrambled_coded = RS_encod(inter_data_scrambled, size_RS_word/8, 8, k);
    disp('Codage RS... fait');   
    
    % Interleaving
    inter_data_scrambled_coded_interleaved = interleaver_encod(inter_data_scrambled_coded);
    disp('Entrelacement... fait'); 
    
    % Making Superframe and adding cyclic prefix
    for i = 0:67
        superframe = [superframe fast_data_scrambled_coded(i*size_RS_word+1:(i+1)*size_RS_word) inter_data_scrambled_coded_interleaved(i*size_RS_word+1:(i+1)*size_RS_word)];
    end
    superframe = [ superframe sync_symbole ]; % adding sync symbole
    disp('Creation de la supertrame... fait');
    signal = [];
    
    % Modulation
    % modulate the first 68 frame
    for i= 0:67
        fprintf('Envoie de la trame %d\n',i);
        signal = [ signal modulationDMT(superframe(i*size_trame+1:(i+1)*size_trame),nombre_canaux, bits_allocation_tables, sum_bits_allocated,prefix_cyclic) ];
    end
    % modulate the synchronisation symbole
    qam_sync = zeros(1,256)+2;
    signal = [ signal modulationDMT(superframe(68*size_trame+1:68*size_trame+512),nombre_canaux, qam_sync, 4*256, prefix_cyclic) ];
    disp('Modulation... fait');
    
    %%%%%%% Transmission %%%%%%%
    hf = modelisation_canal();
    %ht = ifft(hf);
    %%% Egalisation en Frequence %%%
    %canal_egalisation_sym = [ canal_egalisation 0 conj(fliplr(canal_egalisation(2:256))) ]; 
    signal_equalized_t = [];
    for i=0:68
        signal_f = fft(signal(i*(512+prefix_cyclic)+1:(i+1)*(512+prefix_cyclic)));
        signal_canal_f = hf.*signal_f;
        [signal_canal_noise_f,noisePower]=BruitLigne(signal_canal_f,24.71);
        signal_equalized= signal_canal_noise_f./hf;
        signal_equalized_t = [ signal_equalized_t ifft( [ signal_equalized(1:256) 0 conj(fliplr(signal_equalized(2:256))) ])];      
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%% Decoding and demodulating %%%%%%%
    rcv_superframe = [];
    rcv_fast_data_scrambled_coded = [];
    rcv_inter_data_scrambled_coded_interleaved = [];
    
    % Demodulation
    for i= 0:67
        fprintf('Demodulation de la trame %d\n',i);
        rcv_superframe = [ rcv_superframe demodulationDMT(signal_equalized_t(i*(512+prefix_cyclic)+1:(i+1)*(512+prefix_cyclic)), nombre_canaux, bits_allocation_tables, prefix_cyclic, sum_bits_allocated) ];
    end
    % Decoding the synchronisation symbole
    rcv_superframe = [ rcv_superframe demodulationDMT(signal_equalized_t(68*(512+prefix_cyclic)+1:69*(512+prefix_cyclic)),nombre_canaux, qam_sync, prefix_cyclic, 4*256)];
   
    disp('Demodulation... fait');
    
    % Decomposing superframe into 2 data stream
    for i = 0:+2:134
        rcv_fast_data_scrambled_coded = [ rcv_fast_data_scrambled_coded rcv_superframe(i*size_RS_word+1:(i+1)*size_RS_word) ];
        rcv_inter_data_scrambled_coded_interleaved = [ rcv_inter_data_scrambled_coded_interleaved rcv_superframe((i+1)*size_RS_word+1:(i+2)*size_RS_word) ];
    end
    
    
    % Desinterleaving
    rcv_inter_data_scrambled_coded = interleaver_decod(rcv_inter_data_scrambled_coded_interleaved);
    disp('Desentrelacement... fait');
    
    % RS Decoding
    rcv_fast_data_scrambled = RS_decod(rcv_fast_data_scrambled_coded, 68*k*8, size_RS_word/8, 8, k);
    rcv_inter_data_scrambled = RS_decod(rcv_inter_data_scrambled_coded, 68*k*8, size_RS_word/8, 8, k);
    disp('Decodage RS... fait');
    
    % De-Scrambling
    rcv_fast_data = descrambler(rcv_fast_data_scrambled,scrambling_sequence);
    rcv_inter_data = descrambler(rcv_inter_data_scrambled,scrambling_sequence);
    disp('Descrambling... fait');
    
    % Check CRC
    if half_supertrame ~= 0
        if fast_received_previous_CRC == fast_data(1:8)
            fprintf('Supertrame (fast) %d recue sans erreurs\n',half_supertrame-1);
        else
            fprintf('Supertrame (fast) %d recue avec erreurs\n',half_supertrame-1);
        end
        
        if inter_received_previous_CRC == inter_data(1:8)
            fprintf('Supertrame (inter) %d recue sans erreurs\n',half_supertrame-1);
        else
            fprintf('Supertrame (inter) %d recue sans erreurs\n',half_supertrame-1);
        end
       
        
    end
    fast_received_previous_CRC = CRC_encod(rcv_fast_data);
    inter_received_previous_CRC = CRC_encod(rcv_inter_data);
    
    fast_received_data_stream = [ fast_received_data_stream rcv_fast_data(9:length(fast_data)) ];
    inter_received_data_stream = [ inter_received_data_stream rcv_inter_data(9:length(inter_data)) ];
    
    
    
end

testfastOK = isequal(fast_received_data_stream, fast_data_stream);
testinterOK = isequal(inter_received_data_stream, inter_data_stream);
fprintf('test transmission fast OK %d\n', testfastOK);
fprintf('test transmission inter OK %d\n', testinterOK);

Nb_error_fast = numel(find(fast_data_stream~=fast_received_data_stream));
Nb_error_inter = numel(find(inter_data_stream~=inter_received_data_stream));

fprintf('Nb de bits/trame = %d\n', sum_bits_allocated);
fprintf('Nb erreurs fast = %d, Nb erreur inter = %d\n',Nb_error_fast, Nb_error_inter);
fprintf('Tx erreur fast = %d\n',Nb_error_fast/N);
fprintf('Tx erreur inter = %d\n',Nb_error_inter/N);
fprintf('Tx erreur = %d\n',(Nb_error_inter+Nb_error_fast)/(2*N));

