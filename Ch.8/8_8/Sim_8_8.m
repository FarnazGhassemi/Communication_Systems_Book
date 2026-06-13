%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 8-8:               %
%                PPM Modulation for Biomedical Signal          %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 8-Section                        %
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
%% Load biomedical signal
load('IP.mat');
fs = 125;       % Sampling frequency
t0=10;           % Signal Selected Time in Seconds
IP=IP(1:t0*fs);
t = (0:length(IP)-1)/fs;

%% User Input
ppm_rate = input('Enter PPM rate (Hz, e.g., 10): ');
Ts = 1/ppm_rate;
samples_per_slot = round(fs * Ts);
n_slots = floor(length(IP) / samples_per_slot);
IP_sampled = IP(1:n_slots * samples_per_slot); % Trim to full slots
t = t(1:length(IP));

add_noise = input('Do you want to add channel noise? (y/n): ', 's');
if lower(add_noise) == 'y'
    snr_dB = input('Enter SNR (in dB, e.g., 20): ');
    noise_enabled = true;
else
    noise_enabled = false;
end

%% Normalize sampled signal to range [0, 1] for delay mapping
IP_norm = (IP_sampled - min(IP_sampled)) / (max(IP_sampled) - min(IP_sampled));

% Time for full simulation
ppm_signal = zeros(1, length(IP));
delay_range = samples_per_slot - 1; % Maximum pulse delay per slot

%% Generate PPM Signal
for k = 1:n_slots
    idx = (k-1)*samples_per_slot + 1;
    sample_value = IP_norm(idx); % Use first sample in slot
    delay = round(sample_value * delay_range); % Map to delay
    pulse_index = idx + delay;
    ppm_signal(pulse_index) = 1;
end

%% Add Channel Noise (optional)
if noise_enabled
    signal_power = mean(ppm_signal.^2);
    snr_linear = 10^(snr_dB/10);
    noise_power = signal_power / snr_linear;
    noise = sqrt(noise_power) * randn(size(ppm_signal));
    ppm_noisy = ppm_signal + noise;
else
    ppm_noisy = ppm_signal;
end

%% PPM Reconstruction
recon = zeros(1, n_slots);

for k = 1:n_slots
    idx = (k-1)*samples_per_slot + 1;
    [~, pulse_pos] = max(ppm_noisy(idx:idx+delay_range));
    delay = pulse_pos - 1; % zero-based delay
    amplitude = delay / delay_range;
    recon(k) = amplitude;
end

% Interpolate to original time scale
recon_time = (0:n_slots-1) * Ts;
recon_full = interp1(recon_time, recon, t, 'linear');

% Denormalize
recon_full = recon_full * (max(IP) - min(IP)) + min(IP);

%% Plotting
figure;
tlim = [0 t(end)];
plot(t, IP, 'Color', colors(2,:), 'LineWidth', 2);
title('Original Biomedical Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on; xlim(tlim);
figure
if noise_enabled
    subplot(3,1,1);
    plot(t, ppm_signal, 'Color', colors(3,:), 'LineWidth', 2);
    title('PPM Modulated Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,2);
    plot(t, ppm_noisy, 'Color', colors(5,:), 'LineWidth', 2);
    if noise_enabled
        title(['Noisy PPM Signal (SNR = ' num2str(snr_dB) ' dB)']);
    else
        title('PPM Signal (No Noise)');
    end
    xlabel('Time (s)'); ylabel('Amplitude'); grid on; xlim(tlim);
    
    subplot(3,1,3);
    plot(t, recon_full, 'Color', colors(4,:), 'LineWidth', 2);
    hold on
    plot(t, IP, 'Color', colors(2,:), 'LineWidth', 1);
    legend ('Reconstructed Signal','Original Signal');
    title('Reconstructed Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on; xlim(tlim);
else
    subplot(2,1,1);
    plot(t, ppm_signal, 'Color', colors(3,:), 'LineWidth', 2);
    title('PPM Modulated Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
      
    subplot(2,1,2);
    plot(t, recon_full, 'Color', colors(4,:), 'LineWidth', 2);
    hold on
    plot(t, IP, 'Color', colors(2,:), 'LineWidth', 1);
    legend ('Reconstructed Signal','Original Signal');
    title('Reconstructed Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on; xlim(tlim);
end
