function[train_binaire]=generateur(n)
rng default %utilise générateur de nombres aléatoires
train_binaire=randi([0 1],n,1); %génére un vecteur du flx binaire