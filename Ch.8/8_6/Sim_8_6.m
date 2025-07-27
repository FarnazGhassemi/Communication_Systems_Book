%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 9-6:               %
%                PWM Modulation for Biomedical Signal          %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 9-Section                        %
%                                                              %
%   Version.3:             04/02/27---Dr.Ghassemi              %
%   Version.2:             03/09/03---Dr.Ghassemi              %
%   Version.1:             96/06/30---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------
close all;
clear;
clc;
colors=[0,0,0;                       %1-Black
        0,0,0.75;                    %2-Blue
        214/255,39/255,40/255;       %3-Red
        15/255,133/255,84/255;       %4-Green
        118/255,78/255,159/255;      %5-Purple
        225/255,124/255,5/255;       %6-Orange
        56/255,166/255,165/255;      %7-Light Blue
        204/255,80/255,62/255;       %8-Light Red
        115/255,175/255,72/255;      %9-Light Green
        237/255,173/255,8/255;       %10-Light Orange
        148/255,52/255,110/255;      %11-Light Purple
        70/255,0,114/255;            %12-Dark Blue
        0,0.5,0.25                   %13-Green
        ];
grayColor = [0.5, 0.5, 0.5];
marks={'-';'--';':';'-.'};

% Set Text Font
set(0, 'DefaultTextFontName', 'Helvetica', 'DefaultTextFontSize', 18, 'DefaultTextFontWeight', 'bold', 'DefaultTextColor', 'black');

% Set default properties for titles, labels, and axes
set(groot, 'DefaultAxesFontName', 'Helvetica'); % Default font for axes
set(groot, 'DefaultAxesFontSize', 12); % Default font size for axes
set(groot, 'DefaultAxesTitleFontWeight', 'bold'); % Default title weight (optional)

% Set default properties for title font specifically
set(groot, 'DefaultAxesTitleFontSizeMultiplier', 1.2); % Adjust title font size relative to axes font size
set(groot, 'DefaultTextFontName', 'Helvetica'); % Default font for text objects

% Set default properties for all axes
set(groot, 'DefaultAxesFontSize', 14); % Set font size for all axes' tick labels
set(groot, 'DefaultAxesFontName', 'Helvetica'); % Set font for all axes' tick labels
%set(groot, 'DefaultAxesFontWeight', 'bold'); % Set font weight for all axes' tick labels
set(groot, 'DefaultAxesXColor', 'black'); % Set X-axis color
set(groot, 'DefaultAxesYColor', 'black'); % Set Y-axis color

% Set default properties for axes
set(groot, 'DefaultAxesGridLineStyle', '-'); % Default grid line style
set(groot, 'DefaultAxesGridColor', [0 0 0]); % Default grid color (black)
set(groot, 'DefaultAxesGridAlpha', 0.5); % Default grid opacity (fully opaque)
set(groot, 'DefaultAxesLineWidth', 0.5); % Default axes line width (affects grid lines too)

% Box Style for Axe
set(groot, 'DefaultAxesBox', 'on'); % Default: 'on' means axes have a box
%%---------------------------------------------------------------
%% Load signal
load('IP.mat'); 
fs = 125;       % Sampling frequency
IP=IP(1:10*fs);
t = (0:length(IP)-1)/fs;
t1=t;
%% Ask user for PWM rate (sampling of input signal for modulation)
pwm_rate = input('Enter the PWM rate (in samples/sec, e.g., 10): ');
Ts = 1/pwm_rate;
samples_per_symbol = round(fs * Ts);  % Samples per PWM pulse
n_symbols = floor(length(IP) / samples_per_symbol);
IP_sampled = IP(1:n_symbols * samples_per_symbol); % Trim
t = t(1:length(IP_sampled));
% Normalize signal to [0, 1]
IP_norm = (IP - min(IP)) / (max(IP) - min(IP));
%% Ask user whether to add channel noise
add_noise = input('Do you want to add channel noise? (y/n): ', 's');
add_noise = lower(add_noise); % Case insensitive

if add_noise == 'y'
    snr_dB = input('Enter SNR for the channel (in dB, e.g., 20): ');
    noise_enabled = true;
else
    noise_enabled = false;
end

%% Generate PWM signal
pwm_signal = zeros(1, length(IP));
for k = 1:n_symbols
    idx_start = (k-1)*samples_per_symbol + 1;
    idx_end = idx_start + samples_per_symbol - 1;
    pulse_width = round(IP_norm(idx_start) * samples_per_symbol);
    pwm_signal(idx_start : idx_start + pulse_width - 1) = 1;
    pwm_signal(idx_start + pulse_width : idx_end) = 0;
end

%% Optional: Add noise
if noise_enabled
    signal_power = mean(pwm_signal.^2);
    snr_linear = 10^(snr_dB/10);
    noise_power = signal_power / snr_linear;
    noise = sqrt(noise_power) * randn(size(pwm_signal));
    pwm_noisy = pwm_signal + noise;
else
    pwm_noisy = pwm_signal;
end

%% PWM reconstruction
threshold = 0.5;
pwm_bin = pwm_signal > threshold;
% Detect rising and falling edges
edges = diff([0 pwm_bin 0]);
start_indices = find(edges == 1);
end_indices = find(edges == -1);

n_pulses = min(length(start_indices), length(end_indices));
amplitudes = zeros(1, n_pulses);
pulse_times = zeros(1, n_pulses);
max_width = samples_per_symbol;

for i = 1:n_pulses
    width = end_indices(i) - start_indices(i);
    amplitudes(i) = min(width / max_width, 1); % Ensure max=1
    pulse_times(i) = (start_indices(i) + end_indices(i)) / 2 / fs;
end

% Interpolate to match original time
reconstructed = interp1(pulse_times, amplitudes, t, 'linear', 'extrap');
reconstructed = reconstructed * (max(IP) - min(IP)) + min(IP); % Denormalize

%% Plotting
figure;
tlim = [0 t(end)];
plot(t1, IP, 'Color', colors(2,:), 'LineWidth', 2);
title('Original Signal');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
xlim(tlim);
figure
if noise_enabled
    subplot(3,1,1);
    plot(t1, pwm_signal, 'Color', colors(3,:), 'LineWidth', 2);
    title('PWM Modulated Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,2);
    plot(t1, pwm_noisy, 'Color', colors(5,:), 'LineWidth', 2);
    if noise_enabled
        title(['Noisy PWM Signal (SNR = ' num2str(snr_dB) ' dB)']);
    else
        title('PWM Signal (No Noise)');
    end
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,3);
    plot(t, reconstructed, 'Color', colors(4,:), 'LineWidth', 2);
    hold on
    plot(t1, IP, 'Color', colors(2,:), 'LineWidth', 1.5);
    legend ('Reconstructed Signal','Original Signal');
    title('Reconstructed Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
else
    subplot(2,1,1);
    plot(t1, pwm_signal, 'Color', colors(3,:), 'LineWidth', 2);
    title('PWM Modulated Signal (No Noise)');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
      
    subplot(2,1,2);
    plot(t, reconstructed, 'Color', colors(4,:), 'LineWidth', 2);
    hold on
    plot(t1, IP, 'Color', colors(2,:), 'LineWidth', 1);
    legend ('Reconstructed Signal','Original Signal');
    title('Reconstructed Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
end
