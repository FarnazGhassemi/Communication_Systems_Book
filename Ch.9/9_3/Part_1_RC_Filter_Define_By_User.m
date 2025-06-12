%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Code for Illustrating RC Filter                 %
%        Book : Analog & Digital Communication Systems         %
%                   Chapter 9 - Section                        %
%                     By: Dr.Farnaz Ghassemi                   %
%                                                              %
%                                                              %
%   Version1:             03/03/30                             %
%   The first version Contributed voluntarily by               %
%   Mahsa Khodayari as an activity for the related course.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code illustrates the time domain and frequency domain representation
%    of Raised Cosine Filter (RC) with defined paramters by user in two subplots.
%   freqDomainView : Function to compute frequency domain view
%   raisedCosineFunction : Function to generate Raised-Cosine (RC) Pulse
%   alpha : Roll-Off Factor
%   Tsym : Symbol Duration
%%---------------------------------------------------------------
%%

clear all
clc

% Get fs and alpha values from user
alpha = input('Enter the value of alpha (0 to 1): ');
Tsym = input('Enter the value of Tsym (for example 1 or 0.1): ');

L = 50;  % Oversampling rate   
Nsym = 150;  % Filter span in symbol durations
Fs = L / Tsym;  % Sampling frequency

% Define colors for plots
GreenColor =  [0.4660 0.6740 0.1880];
OrangeColor = [0.8500 0.3250 0.0980];


% Generate Raised Cosine Pulse
[rcPulse, t] = raisedCosineFunction(alpha, L, Nsym); 
t = Tsym * t;  % Translate time base for given duration

% Time domain plot
subplot(1, 2, 1);
plot(t, rcPulse, 'Color', OrangeColor, 'LineWidth', 1.75);
title('Raised Cosine (RC) Pulse');
xlabel('Time (s)');
ylabel('Amplitude');
legend([' alpha=', num2str(alpha),  ' ,  Tsym=', num2str(Tsym),  ' ,  fs=', num2str(Fs/50)]);
xlim([(-500/Fs) (500/Fs)]);  % limit x-axis for better observation
grid on;

% Frequency domain view
[vals, f] = freqDomainView(rcPulse, Fs, 'double');
subplot(1, 2, 2);
plot(f, abs(vals) / abs(vals(length(vals) / 2 + 1)), 'Color', GreenColor, 'LineWidth', 1.75);
title('Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend([' alpha=', num2str(alpha),  ' ,  Tsym=', num2str(Tsym),  ' ,  fs=', num2str(Fs/50)]);
xlim([-(0.04*Fs) (0.04*Fs)]);  % limit x-axis for better observation
grid on;


% Calculate the bandwidth of the RC Filter
BW = 0.5*(1+alpha)*(Fs/50);
disp(['The Bandwidth of this filter is equal to: ' num2str(BW)]);



% Function to compute frequency domain view
function [SIGNAL, fVals] = freqDomainView(signal, Fs, type)

    % Returns raw FFT values & frequency bins for the time domain signal
    % Signal - discrete-time domain representation of a signal
    % Fs - sampling frequency of the discrete-time representation
    % Type - 'single' or 'double' - returns the single/double sided FFT

    NFFT = 2^nextpow2(length(signal)); % FFT length

    if nargin < 3
        type = 'double'; 
    end

    if strcmpi(type, 'single') % Single sided FFT
        SIGNAL = fft(signal, NFFT);
        SIGNAL = SIGNAL(1:NFFT / 2); % Throw away half the number of values
        fVals = Fs * (0:NFFT / 2 - 1) / NFFT;
        
    else % Double sided FFT
        SIGNAL = fftshift(fft(signal, NFFT));
        fVals = Fs * (-NFFT / 2 : NFFT / 2 - 1) / NFFT;
    end
    
end


% Function to generate Raised-Cosine (RC) Pulse
function [p, t, filtDelay] = raisedCosineFunction(alpha, L, Nsym)

    % alpha - roll-off factor
    % L - oversampling factor
    % Nsym - filter span in symbols
    % Returns the output pulse p(t) that spans the discrete-time base
    % -Nsym:1/L:Nsym. Also returns the filter delay when the function is viewed as an FIR filter
    

    Tsym = 1; 
    t = -(Nsym / 2) : 1 / L : (Nsym / 2); % Unit symbol duration time-base
    
    % Calculate the raised cosine pulse
    A = sin(pi * t / Tsym) ./ (pi * t / Tsym); 
    B = cos(pi * alpha * t / Tsym);
    p = A .* B ./ (1 - (2 * alpha * t / Tsym) .^ 2);
    
    % Special cases
    p(ceil(length(p) / 2)) = 1; % p(0)=1 & p(0) occurs exactly at the center
    temp = (alpha / 2) * sin(pi / (2 * alpha)); % p(t=+-1/(2a)) = (a/2)sin(pi/(2a))
    p(t == Tsym / (2 * alpha)) = temp; 
    p(t == -Tsym / (2 * alpha)) = temp;
    
    % FIR filter delay = (N - 1) / 2, N = length of the filter
    filtDelay = (length(p) - 1) / 2; % FIR filter delay
end

