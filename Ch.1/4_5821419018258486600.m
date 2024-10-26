clear all
close
clc

td = 1;

[x,Fs] = audioread('numbers.mp3');
x = x';



lx = length(x);
t = 0:1/Fs:lx/Fs-1/Fs;
f = (-lx/2:lx/2-1)/lx*Fs;


X = fftshift(fft(x));

H = 0.5*exp(-1i*2*pi*f*td);

Y = H .* X;

x2 = real(ifft(ifftshift(Y)));


audiowrite('shifted_numbers.ogg',x2,Fs);
% sound(x,Fs);
% pause(4);
% sound(x2,Fs);


figure('Name','|x(f)| and |y(f)|');
subplot(211)
plot(f, abs(X));
xlabel 'Frequency (Hz)'
ylabel '|x(f)|'
ylim([0, 1200])
grid
subplot(212)
plot(f, abs(Y));
xlabel 'Frequency (Hz)'
ylabel '|y(f)|'
ylim([0, 1200])
grid

% figure('Name','phase(X(f))');
% plot(f, angle(X)/pi * 180, '.');
% xlabel 'Frequency (Hz)'
% ylabel 'Phase x(f)'
% ylim([-180, 180]);
% yticks(-180:30:180);

figure('Name','|h(f)|');
plot(f, abs(H), '.');
xlabel 'Frequency (Hz)'
ylabel '|h(f)|'
grid

figure('Name','phase(h(f))');
plot(f, angle(H)/pi * 180);
xlabel 'Frequency (Hz)'
ylabel 'Phase h(f)'
ylim([-180, 180]);
yticks(-180:30:180);
xlim([-50, 50])
% pause(3);
% xlim([-0.4, 0.4])