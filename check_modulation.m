%Ce script vérifie la modulation M-QAM%

M=128;
k=log2(M);
s=generateur(k*100);
s_module=MQAM(M,s);
s_demodule=MQAMDemod(M,s_module);

figure('Name','Erreur de modulation','NumberTitle','off') 
plot(linspace(0,0.1, k*100),s-s_demodule);
scatterplot(s_module)
title('signal modulé');