function signal_recu=canal(signal_module,h)

% La fonction canal permet de simuler un canal r�el, int�grant du bruit et de la diaphonie.
% Tous les �chantillons sortant du modulateur DMT traverseront
% ce canal pour finalement �tre envoy�es au d�modulateur.

% x_mod est le vecteur sorti du modulateur DMT.
% h est la r�ponse impulsionnelle en temps du canal.


signal_recu=signal_module; 