%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Simulating the Effect of an Impulse Response on a Sine Wave %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 3 - Section 3-3                    %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntirely by               %
%   Alireza Saadati as an activity for the related course.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code simulates the effect of channel (an impulse response filter) 
%    on a signal (a sine wave), analyzing the results in both time and 
%    frequency domains. It plots the impulse response, original signal, 
%    and convolved signal in the time domain, along with their Fourier 
%    Transform magnitudes in the frequency domain.
%
%%---------------------------------------------------------------
%%

% Time vector for impulse response
fs = 44100; % Assuming a sampling frequency of 44100 Hz
tvec = linspace(0, 0.01, 0.5 * fs);
h = exp(-2*pi*100*tvec);

% Original signal (example: sine wave for visualization)
t = linspace(0, 1, fs);
orig_signal = sin(2 * pi * 100 * t); % 100 Hz sine wave

% Convolution with impulse response
conv_signal = conv(orig_signal, h, 'same');

% Compute Fourier Transforms
orig_signal_f = abs(fftshift(fft(orig_signal)));
conv_signal_f = abs(fftshift(fft(conv_signal)));

% Frequency vector for plotting
fvec = linspace(-fs / 2, fs / 2, length(orig_signal_f));

% Plot impulse response
figure;
subplot(4,1,1);
plot(tvec, h);
title('Impulse Response h(t)');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot original signal in time domain
subplot(4,1,2);
plot(t, orig_signal);
title('Original Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot convoluted signal in time domain
subplot(4,1,3);
plot(t, conv_signal);
title('Convoluted Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot original signal in frequency domain
subplot(4,1,4);
plot(fvec, orig_signal_f);
title('Original Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

figure;
% Plot convoluted signal in frequency domain
plot(fvec, conv_signal_f);
title('Convoluted Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% noisepower = 0.01;
% noise = sqrt(noisepower)*randn(size(orig_signal));
% %Adding noise to the signal
% sig_noise = orig_signal + noise;
% plot(t, sig_noise);