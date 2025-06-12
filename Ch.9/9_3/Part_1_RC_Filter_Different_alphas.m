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
%    of Raised Cosine Filter (RC) for different alphas & Tsym = 0.1 in two subplots.
%   freqDomainView : Function to compute frequency domain view
%   raisedCosineFunction : Function to generate Raised-Cosine (RC) Pulse
%   alpha : Roll-Off Factor
%   Tsym : Symbol Duration
%%---------------------------------------------------------------
%%

clear all
clc

% Define Tsym and alpha values
Tsym = 0.1; % Example value
alpha_values = [0 0.3 0.5 0.8 1]; % Array of alpha values

L = 50;  % Oversampling rate   
Nsym = 150;  % Filter span in symbol durations
Fs = L / Tsym;  % Sampling frequency

% Define colors for plots
colors = [
    0.4660 0.6740 0.1880; % Green
    0.8500 0.3250 0.0980; % Orange
    0.4940 0.1840 0.5560; % Purple
    0.3010 0.7450 0.9330; % Light Blue
    0.9290 0.6940 0.1250; % Yellow
];

% Time domain plot
subplot(1, 2, 1);
hold on;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    
    % Generate Raised Cosine Pulse
    [rcPulse, t] = raisedCosineFunction(alpha, L, Nsym); 
    t = Tsym * t;  % Translate time base for given duration
    
    % Plot Raised Cosine Pulse for current alpha
    plot(t, rcPulse, 'LineWidth', 1.75, 'Color', colors(i, :), 'DisplayName', ['\alpha = ', num2str(alpha)]);
end

title('Raised Cosine (RC) Pulse');
xlabel('Time (s)');
ylabel('Amplitude');
legend('show');
xlim([-0.4 0.4]);  % limit x-axis for better observation
grid on;
hold off;

% Frequency domain plot
subplot(1, 2, 2);
hold on;

for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    
    % Generate Raised Cosine Pulse
    [rcPulse, ~] = raisedCosineFunction(alpha, L, Nsym);
    
    % Frequency domain view
    [vals, f] = freqDomainView(rcPulse, Fs, 'double');
    
    % Plot frequency response for current alpha
    plot(f, abs(vals) / abs(vals(length(vals) / 2 + 1)), 'LineWidth', 1.75, 'Color', colors(i, :), 'DisplayName', ['\alpha = ', num2str(alpha)]);
end

title('Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('show');
xlim([-10.5 10.5]);  % limit x-axis for better observation
grid on;
hold off;



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
