%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Code for Illustrating SRRC Filter                %
%        Book : Analog & Digital Communication Systems         %
%                  Chapter 9 - Section                         %
%                     By: Dr.Farnaz Ghassemi                   %
%                                                              %
%                                                              %
%   Version1:             03/03/30                             %
%   The first version Contributed voluntarily by               %
%   Mahsa Khodayari as an activity for the related course.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%% This code illustrates the time domain and frequency domain representation
%   of Square Root Raised Cosine Filter (SRRC) for different betas &
%   Tsym = 0.1 in two subplots.
%  freqDomainView : Function to compute frequency domain view
%  srrcFunction : Function to generate Square-Root Raised-Cosine (SRRC) Pulse
%  beta : Roll-Off Factor of SRRC pulse
%  Tsym : Symbol Duration

%%---------------------------------------------------------------
%%

clear all
clc

% Define Tsym and beta values
Tsym = 0.1; % Example value
beta_values = [0 0.3 0.5 0.8 1]; % Array of beta values

L = 50;  % Oversampling rate   
Nsym = 150;  % Filter span in symbol durations
Fs = L / Tsym;  % Sampling frequency

% Define colors for plots
colors = [
    0.3010 0.7450 0.9330; % Light Blue
    0.4940 0.1840 0.5560; % Purple
    0.4660 0.6740 0.1880; % Green
    0.8500 0.3250 0.0980; % Orange
    0.9290 0.6940 0.1250; % Yellow
    
    
];

% Time domain plot
subplot(1, 2, 1);
hold on;

for i = 1:length(beta_values)
    beta = beta_values(i);
    
    % Generate SRRC Pulse
    [srrcPulseAtTx, t] = srrcFunction(beta, L, Nsym); 
    srrcPulseAtRx = srrcPulseAtTx; % Using the same filter at Rx
    combinedResponse = conv(srrcPulseAtTx, srrcPulseAtRx, 'same');
    t = Tsym * t; % Translate time base for given duration
    
    % Plot SRRC Pulse for current beta
    plot(t, combinedResponse / max(combinedResponse), 'LineWidth', 1.75, 'Color', colors(i, :), 'DisplayName', ['\beta = ', num2str(beta)]);
end

title('SRRC Pulse');
xlabel('Time (s)');
ylabel('Amplitude');
legend('show');
xlim([-0.4 0.4]);  % limit x-axis for better observation
grid on;
hold off;

% Frequency domain plot
subplot(1, 2, 2);
hold on;

for i = 1:length(beta_values)
    beta = beta_values(i);
    
    % Generate SRRC Pulse
    [srrcPulseAtTx, ~] = srrcFunction(beta, L, Nsym);
    
    % Frequency domain view
    [vals, f] = freqDomainView(srrcPulseAtTx, Fs, 'double');
    
    % Plot frequency response for current beta
    plot(f, abs(vals) / abs(vals(length(vals) / 2 + 1)), 'LineWidth', 1.75, 'Color', colors(i, :), 'DisplayName', ['\beta = ', num2str(beta)]);
end

title('Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('show');
xlim([-10.5 10.5]);  % limit x-axis for better observation
grid on;
hold off;

% Calculate the bandwidth of the SRRC Filter for the last beta value
BW = 0.5*(1+beta)*(Fs/50);
disp(['The Bandwidth of this filter is equal to: ' num2str(BW)]);


% Function to compute frequency domain view
function [SIGNAL, fVals] = freqDomainView(signal, Fs, type)

    % Returns raw FFT values & frequency bins for the time domain signal
    % signal - discrete-time domain representation of a signal
    % Fs - sampling frequency of the discrete-time representation
    % type - 'single' or 'double' - returns the single/double sided FFT

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


% Function to generate Square-Root Raised-Cosine (SRRC) Pulse
function [p, t, filtDelay] = srrcFunction(beta, L, Nsym)

    % beta - roll-off factor of SRRC pulse
    % L - oversampling factor (number of samples per symbol)
    % Nsym - filter span in symbol durations
    % Returns the output pulse p(t) that spans the discrete-time base
    % -Nsym:1/L:Nsym. Also returns the filter delay when the function
    % is viewed as an FIR filter

    Tsym = 1; 
    t = -(Nsym / 2) : 1 / L : (Nsym / 2); % Unit symbol duration time-base
    
    % Calculate the SRRC pulse
    num = sin(pi * t * (1 - beta) / Tsym) + ((4 * beta * t / Tsym) .* cos(pi * t * (1 + beta) / Tsym));
    den = pi * t .* (1 - (4 * beta * t / Tsym) .^ 2) / Tsym;
    p = 1 / sqrt(Tsym) * num ./ den; % SRRC pulse definition
    
    % Special cases
    p(ceil(length(p) / 2)) = 1 / sqrt(Tsym) * ((1 - beta) + 4 * beta / pi);
    temp = (beta / sqrt(2 * Tsym)) * ((1 + 2 / pi) * sin(pi / (4 * beta)) + (1 - 2 / pi) * cos(pi / (4 * beta)));
    p(t == Tsym / (4 * beta)) = temp; 
    p(t == -Tsym / (4 * beta)) = temp;
    
    % FIR filter delay = (N - 1) / 2, N = length of the filter
    filtDelay = (length(p) - 1) / 2; % FIR filter delay
end
