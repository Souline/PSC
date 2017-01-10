%<<<<<<<<<<<Modulation DMT >>>>>>>>>>>>>%

function [sigx]= modulationDMT(flux_bit,table_allocation)

nb_canaux=256; %adsl download
nb_bits=flux_bit.length;
Pe=1; %puissance totale du modem en W
Pcanal = Pe/nb_canaux; % puissance par canal (on utilise par le water-filling
compteur_bits = 1; %on initialise un compteur pour savoir les bits déja répartis
signal_transmis=zeros(1:nb_canaux);%initialisation du signal transmis
%<<<<<<Allocation des bits>>>>>>>%
% function [table_bits] = allocation
%chaque canal associé à un nombre de bits

for i=1:nb_canaux
    table_bits(i)=nb_bits;
    signal_transmis(i)=MQAM(nb_bits,flux_bit(compteur_bits:(compteur_bits+nb_bits-1)));
    compteur_bits= compteur_bits + nb_bits;
    
    

    
    