%Ce script vérifie la modulation M-QAM%

M=128;
k=log2(M);
s=generateur(k*100000);
s_module=MQAM(M,s);
s_demodule=MQAMDemod(M,s_module);
figure('Name','Erreur de modulation','NumberTitle','off') 
plot(s-s_demodule);