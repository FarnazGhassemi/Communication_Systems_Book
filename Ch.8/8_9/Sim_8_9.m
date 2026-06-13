%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 8-9:               %
%                PCM Modulation for Biomedical Signal          %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 8-Section                        %
%                                                              %
%   Version.1:          04/03/10---Dr.Ghassemi, ZTabanfar      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------

% close all;10
% clear;
% clc;
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
%%--------------------------------------------------------------
%% Load biomedical signal
load('IP.mat'); 
fs = 125;       % Sampling frequency
t0=10;           % Signal Selected Time in Seconds
IP=IP(1:t0*fs);
t = (0:length(IP)-1)/fs;
%% PCM Parameters
pcm_rate = input('Enter the PCM sampling rate (Hz, e.g., 10): ');
Ts = 1/pcm_rate;
samples_per_symbol = round(fs * Ts);
n_symbols = floor(length(IP) / samples_per_symbol);

% Sampling
sample_indices = 1:samples_per_symbol:(n_symbols * samples_per_symbol);
IP_sampled = IP(sample_indices);
t_sampled = t(sample_indices);

% Quantization
n_bits = input('Enter number of quantization bits (e.g., 4): ');
L = 2^n_bits;
xmin = min(IP);
xmax = max(IP);
q_step = (xmax - xmin) / L;
partition = xmin + q_step * (1:L-1);
codebook = xmin + q_step/2 + q_step * (0:L-1);

[index, q_signal] = quantiz(IP_sampled, partition, codebook);
index(index == 0) = 1;  % Adjust for MATLAB 1-based indexing
encoded_bin = dec2bin(index - 1, n_bits);  % Encoding step (binary)

%% Channel noise (optional)
add_noise = input('Do you want to add channel noise? (y/n): ', 's');
add_noise = lower(add_noise);
if or((add_noise=='y') ,(add_noise=='Y'))
    add_noise=true;
else
    add_noise=false;
end
if add_noise 
    noise_power_dB = input('Enter noise power in dB (e.g., -20): ');
    noise_power = 10^(noise_power_dB / 10);
    noise = sqrt(noise_power) * randn(size(q_signal));
    q_received = q_signal + noise;
else
    q_received = q_signal;
end

%% Reconstruction using Zero-Order Hold (ZOH)
t_interp = t;
reconstructed = interp1(t_sampled, q_received, t_interp, 'previous', 'extrap');

%% Plotting
figure('Color','w','Position',[100 100 900 700]);
tlim = [0 t(end)];
plot(t, IP, 'Color', colors(2,:), 'LineWidth', 2);
title('Original Signal');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
xlim(tlim);
figure
if add_noise
    subplot(3,1,1);
    stem(t_sampled, IP_sampled, 'filled', 'Color', colors(3,:));
    title('Sampled Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,2);
    stairs(t_sampled, q_signal, 'Color', colors(6,:), 'LineWidth', 2); 
    hold on;
    plot(t_sampled, q_received, 'Color', colors(5,:), 'LineWidth', 1.5);
    title(['Quantized and Received Signal (Noise: ' num2str(noise_power_dB) ' dB)']);
    legend('Quantized', 'Noisy');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,3);
    plot(t, reconstructed, 'Color', colors(4,:), 'LineWidth', 2); hold on;
    plot(t, IP, 'Color', colors(2,:), 'LineWidth', 1);
    legend('Reconstructed (ZOH)', 'Original');
    title('Reconstructed Signal using ZOH');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
else
    subplot(3,1,1);
    stem(t_sampled, IP_sampled, 'filled', 'Color', colors(3,:));
    title('Sampled Signal');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,2);
    stairs(t_sampled, q_signal, 'Color', colors(6,:), 'LineWidth', 2); 
    title('Quantized Signal (No Noise)');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,3);
    plot(t, reconstructed, 'Color', colors(4,:), 'LineWidth', 2); hold on;
    plot(t, IP, 'Color', colors(2,:), 'LineWidth', 1);
    legend('Reconstructed (ZOH)', 'Original');
    title('Reconstructed Signal using ZOH');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
end
