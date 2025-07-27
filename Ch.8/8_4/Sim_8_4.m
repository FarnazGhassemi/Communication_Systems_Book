%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 9-4:               %
%     Types of Adverse Effects of Channel On Message Signal    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 9-Section                        %
%                                                              %
%   Version.3:             22/02/04---Dr.Ghassemi                                                          %
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
t0=10;           % Signal Selected Time in Seconds
IP=IP(1:t0*fs);
t = (0:length(IP)-1)/fs;

%% Ask user for PAM rate
pam_rate = input('Enter the PAM rate (in samples/sec, e.g., 5): ');
Ts = 1/pam_rate; 
t_pam = 0:Ts:t(end); 

%% Ask user for modulation method
fprintf('\nChoose PAM modulation method:\n');
fprintf('1: Sample-and-Hold\n');
fprintf('2: Sinc-Based PAM\n');
method = input('Enter the number corresponding to your choice: ');

%% Ask user whether to add channel noise
add_noise = input('Do you want to add channel noise? (y/n): ', 's');
add_noise = lower(add_noise); % make case-insensitive

if add_noise == 'y'
    snr_dB = input('Enter SNR for the channel (in dB, e.g., 20): ');
    noise_enabled = true;
else
    noise_enabled = false;
end

%% Sample the signal at PAM instants
IP_sampled = interp1(t, IP, t_pam, 'linear');

switch method
    case 1 % Sample-and-Hold
        modulated = zeros(size(t));
        for i = 1:length(t_pam)-1
            idx = t >= t_pam(i) & t < t_pam(i+1);
            modulated(idx) = IP_sampled(i);
        end
        modulated(t >= t_pam(end)) = IP_sampled(end);
        
    case 2 % Sinc-Based PAM
        modulated = zeros(size(t));
        for n = 1:length(IP_sampled)
            modulated = modulated + IP_sampled(n) * sinc(pam_rate*(t - t_pam(n)));
        end
        
    otherwise
        error('Invalid method selected. Please enter 1 or 2.');
end

%% Add noise if enabled
if noise_enabled
    signal_power = mean(modulated.^2);
    snr_linear = 10^(snr_dB/10);
    noise_power = signal_power / snr_linear;
    noise = sqrt(noise_power) * randn(size(modulated));
    modulated_noisy = modulated + noise;
else
    modulated_noisy = modulated;
end

%% Reconstruct using low-pass filter
fc = pam_rate / 2;  % Cutoff frequency
[b, a] = butter(6, fc / (fs / 2));  % Normalized
reconstructed = filtfilt(b, a, modulated_noisy);

%% Plotting
figure;
tlim = [0 t(end)];
plot(t, IP, 'Color', colors(2,:), 'LineWidth', 2);
title('Original Signal');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
xlim(tlim);
figure
if noise_enabled   
    subplot(3,1,1);
    plot(t, modulated, 'Color', colors(3,:), 'LineWidth', 2);
    if method == 1
        title('PAM Modulated Signal (Before Noise) - Sample and Hold');
    else
        title('PAM Modulated Signal (Before Noise) - Sinc Based');
    end
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,2);
    if noise_enabled
        plot(t, modulated_noisy, 'Color', colors(5,:), 'LineWidth', 2);
        title(['Noisy PAM Signal (SNR = ' num2str(snr_dB) ' dB)']);
    else
        plot(t, modulated_noisy, 'Color', colors(3,:), 'LineWidth', 2);
        title('PAM Signal (No Noise)');
    end
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(3,1,3);
    plot(t, reconstructed, 'Color', colors(4,:), 'LineWidth', 2);
    hold on
    plot(t, IP, 'Color', colors(2,:), 'LineWidth', 1);
    legend ('Reconstructed Signal','Original Signal');
    title('Reconstructed Signal (Low-pass Filter)');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
else  
    subplot(2,1,1);
    plot(t, modulated, 'Color', colors(3,:), 'LineWidth', 2);
    if method == 1
        title('PAM Modulated Signal (No Noise) - Sample and Hold');
    else
        title('PAM Modulated Signal (No Noise) - Sinc Based');
    end
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
    
    subplot(2,1,2);
    plot(t, reconstructed, 'Color', colors(4,:), 'LineWidth', 2);
    hold on
    plot(t, IP, 'Color', colors(2,:), 'LineWidth', 1);
    legend ('Reconstructed Signal','Original Signal');
    title('Reconstructed Signal (Low-pass Filter)');
    xlabel('Time (s)'); ylabel('Amplitude'); grid on;
    xlim(tlim);
end