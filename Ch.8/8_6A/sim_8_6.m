close all
clear all
clc
%% Sim 8_6
fs = 1000;              % Sampling frequency
t = -0.4:1/fs:0.6;      % Time vector

% Generate ECG waveform
p_wave = 0.20 * exp(-((t + 0.22) / 0.06).^2); % P wave 
r_wave = 1.00 * exp(-((t - 0.00) / 0.02).^2); % R peak 
t_wave = 0.30 * exp(-((t - 0.25) / 0.08).^2); % T wave 
base_ecg = p_wave + r_wave + t_wave;        

num_cycles = 50; % Number of cycles in one window

%colors, I avoid the random colors
colors = [
    0.12, 0.47, 0.71; 
    1.00, 0.50, 0.05; 
    0.17, 0.63, 0.17; 
    0.84, 0.15, 0.16; 
    0.58, 0.40, 0.74; 
    0.55, 0.34, 0.29; 
    0.89, 0.47, 0.76; 
    0.50, 0.50, 0.50; 
    0.74, 0.74, 0.13;
    0.09, 0.75, 0.81; 
    0.20, 0.20, 0.60; 
    0.85, 0.65, 0.13  
];

figure('Position', [100, 100, 1000, 400], 'Color', 'w');

% First plot, Low interference
subplot(1, 2, 1); 
hold on;          

for i = 1:num_cycles
    % Generate a low level white noise
    noise_low = 0.013 * randn(size(t)); 
    amp_jitter = 0.95 + 0.1 * rand(); 

    color_idx = mod(i - 1, 12) + 1;
    plot(t, (base_ecg * amp_jitter) + noise_low, 'LineWidth', 0.4, 'Color', colors(color_idx, :));
end
hold off; 
title('ECG eye diagram – low interference');
xlabel('Time around R-peak (s)'); ylabel('Amplitude (a.u.)');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.4; 
xlim([-0.45 0.65]); ylim([-0.1 1.15]); 

% Second plot, Strong interference
subplot(1, 2, 2); 
hold on;
for i = 1:num_cycles
    % Generate high level white noise
    noise_strong = 0.14 * randn(size(t)); 
    amp_jitter = 0.85 + 0.3 * rand(); 
    color_idx = mod(i - 1, 12) + 1;
    plot(t, (base_ecg * amp_jitter) + noise_strong, 'LineWidth', 0.5, 'Color', colors(color_idx, :));
end
hold off;
title('ECG eye diagram – strong interference');
xlabel('Time around R-peak (s)'); ylabel('Amplitude (a.u.)');
grid on; ax = gca; ax.GridLineStyle = '--'; ax.GridAlpha = 0.4;
xlim([-0.45 0.65]); ylim([-0.4 1.4]);
% save
saveas(gcf, 'ECG_Eye_Diagram.png'); % Save as PNG
saveas(gcf, 'ECG_Eye_Diagram.fig'); % Save as FIG