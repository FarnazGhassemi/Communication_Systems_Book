%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Modeling of an analog baseband transmission system      %
%                   in the presence of noise                   %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 3 - Section 3-3                    %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Alireza Saadati as an activity for the related course.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code simulates the processing of an audio signal through several 
%    stages of communication, such as gain adjustment, channel effects, 
%    noise addition, and filtering.
%   
%   User inputs:
%       Transmitter gain in dB.
%       Channel impulse response choice (select from options with a -10 dB loss).
%       Noise power level to be added to the signal.
%
%   Output:
%       The script plots the signal in both time and frequency domains at 
%        each processing step:
%          - Original signal.
%          - Signal after applying transmitter gain and convolution with 
%           the chosen channel impulse response.
%          - Signal with added Gaussian noise.
%          - Filtered signal after applying a low-pass Butterworth filter.
%        The sound of the filtered signal is played.
%%---------------------------------------------------------------
%%

[sig_t,fs] = audioread('obama1.wav');
% sound(sig_t,fs);
% s = sig_t + 0.1*randn(size(sig_t));
% sound(s,fs);

%plot in time domain 
tvec = linspace(0,length(sig_t)/fs,length(sig_t));
figure; subplot(2,1,1);
plot(tvec,sig_t); title('Original Signal in Time');xlabel('Time(S)');ylabel('Magnitute');

%plot in frequency domain
sig_f = abs(fftshift(fft(sig_t)));
fvec = linspace(-fs/2,fs/2,length(sig_f));
subplot(2,1,2); plot(fvec,sig_f); title('Original Signal in Frequency');xlabel('Frequency(Hz)');ylabel('Magnitute');

%Transmitter Gain
gain_dB = input('Please input the transmitter gain in dB: ');
gain_linear = 10^(gain_dB / 10);
sig_t = gain_linear * sig_t;

%channel
nh = input('\n\nChoose impluse response of the channel all with -10dB loss\n 1.sinc(2*pi*100t)\n 2. exp(-2pi*5000t)\n 3. exp(-2pi*1000t)\n 4. 2*delta(t)+0.5*delta(t-1)\n');
tvec = linspace(0,0.5,0.5*fs);
switch nh
    case 1
        h = sinc(2*pi*100*tvec) / 10;
    case 2
        h = exp(-2*pi*5000*tvec) / 10;
    case 3
        h = exp(-2*pi*1000*tvec) / 10;
    case 4
        h = [2 zeros(1,0.5*fs) 0.5] / 10;
%         h = [2 zeros(1,fs-1) 0.5];
%         h = [h zeros(1, (L/2)-length(h))];
end

s1 = sig_t(:,1).';
s1 = conv(s1,h,"same");

s2 = sig_t(:,1).';
s2 = conv(s2,h,"same");

sig_t = [s1; s2].';

tvec = linspace(0,length(sig_t)/fs,length(sig_t));
figure; subplot(2,1,1);
plot(tvec,sig_t); title('Convoluted Signal in Time');xlabel('Time(S)');ylabel('Magnitute');
sig_f = abs(fftshift(fft(sig_t)));
fvec = linspace(-fs/2,fs/2,length(sig_f));
subplot(2,1,2); plot(fvec,sig_f); title('Convoluted Signal in Frequency');xlabel('Frequency(Hz)');ylabel('Magnitute');

%sound(sig_t,fs);

%Noise
noisepower = input('Please input the power of the noise:');

%Generaing the noise
noise = sqrt(noisepower)*randn(size(sig_t));

%Adding noise to the signal
sig_noise = sig_t + noise;

%Signal representation
tvec = linspace(0,length(sig_noise)/fs,length(sig_noise));
figure; subplot(2,1,1);
plot(tvec,sig_noise); title('Signal with Noise in Time');xlabel('Time(S)');ylabel('Magnitute');
sig_ff = abs(fftshift(fft(sig_noise)));
fvec = linspace(-fs/2,fs/2,length(sig_ff));
subplot(2,1,2); plot(fvec,sig_ff); title('Signal with Noise in Frequency');xlabel('Frequency(Hz)');ylabel('Magnitute');

%sound(sig_noise,fs);

% LPF construction cut-off 3.4kHz
%n = length(sig_f);
%sampPerFreq = int64(n/fs);
%limit = sampPerFreq * (fs/2 - 3400);
%sig_f([1:limit n-limit+1:end]) = 0;
%figure;
%subplot(2,1,2);
%plot(fvec, sig_f);
%title('Filtered signal in f-domain');
%sig_t = real(ifft(ifftshift(sig_f)));
%subplot(2,1,1);
%plot(tvec, sig_t);
%title('Filtered signal in t-domain');

fc = 3000;
n_order = 3;
[b a] = butter(n_order, fc/(fs/2));
sig_filtered = filtfilt(b,a,sig_noise);
figure; subplot(2,1,1);
plot(tvec,sig_filtered); title('Filtered Signal in Time');xlabel('Time(S)');ylabel('Magnitute');
sig_filtered_f = abs(fftshift(fft(sig_filtered)));
subplot(2,1,2); plot(fvec,sig_filtered_f); title('Filtered Signal in Frequency');xlabel('Frequency(Hz)');ylabel('Magnitute');

sound(sig_filtered,fs);