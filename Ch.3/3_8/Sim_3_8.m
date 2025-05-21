%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Simulation 3_8: Non-linear distortion on Biosignals      %
%     Types of Adverse Effects of Channel On Message Signal    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 3-Section 5                      %
%                                                              %
%                                                              %
%   Version.2:             03/09/03---Dr.Ghassemi              %
%   Version.1:             02/08/14                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A1=A(:,1);
%A1=Data;
fs = 256;
t = (0:length(A1)-1) / fs; 

a1 = 1;
a2 = 0.5;
a3 = 0.2;

y = a1 * A1 + a2 * A1.^2 + a3 * A1.^3;

figure;
subplot(2, 1, 1);
plot(t, A1, 'b', 'LineWidth', 1.5);
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
title('Original EEG Signal', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

subplot(2, 1, 2);
plot(t, y, 'r', 'LineWidth', 1.5);
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
title('Signal After Nonlinear Element', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

% Analyze the signals in the frequency domain
n = length(A1); % Number of samples
f = (0:n-1) * (fs / n); % Frequency vector

% Compute Fourier transforms
fft_A1 = abs(fft(A1)); % Magnitude of FFT of the original signal
fft_y = abs(fft(y));   % Magnitude of FFT of the nonlinear signal

% Plot the frequency spectra
figure;
subplot(2, 1, 1);
plot(f(1:n/2), fft_A1(1:n/2), 'b', 'LineWidth', 1.5);
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Magnitude', 'FontSize', 12, 'FontWeight', 'bold');
title('Frequency Spectrum of Original Signal', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

subplot(2, 1, 2);
plot(f(1:n/2), fft_y(1:n/2), 'r', 'LineWidth', 1.5);
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Magnitude', 'FontSize', 12, 'FontWeight', 'bold');
title('Frequency Spectrum After Nonlinear Element', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
