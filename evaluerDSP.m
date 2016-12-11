%function [ DSP_noise ] = evaluerDSP(nb_trames_init)
    nb_trames_init=5;
    alloc = randi([4 4],256);
    for j= 1:nb_trames_init
        trame = randi([0 1], 256*4); 
        % Conversion des symboles en signal temporel
        signal = modulationDMT(trame,256,alloc);
        h = modelisation_canal();   
        % Traversee de la ligne (convolution + ajout du bruit)
        signal_canal = conv(signal,ifft(h));
        [signal_canal_noise,noisePower]=BruitLigne(fft(signal_canal),24.71);
        % Conversion du signal temporel en spectre frequentiel
        %yFreq = DemodOFDM(y);

        % Pour eliminer la contribution du bruit, on fait la moyenne des trames
        % en temporel (le bruit blanc s'annulera en moyenne sur l'ensemble des trames)
        %yMoy = yMoy + y;

        % On calcule la DSP du signal
        %modYFreq = abs(yFreq);
        %DSPSignal = modYFreq .* modYFreq;
        %DSPMoy = DSPMoy + DSPSignal;

%    end


end

