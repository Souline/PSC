fs=10000;
dt=1/fs;
t=[0:dt:1-dt];
x=sin(t);
y=fft(x,10000);
plot(y);

