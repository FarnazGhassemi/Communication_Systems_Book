close all;
clear all;
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
%% Parameters
fs = 1000;       % Sampling frequency
T = 1;           % Duration in seconds
t = 0:1/fs:T;    % Time vector
fm = 10;         % Message frequency
fc = 100;        % Carrier frequency
Ac = 1;          % Carrier amplitude
Am = 0.5;        % Message amplitude

%% Message Signal
m = Am * cos(2 * pi * fm * t);

%% AM Modulation
s = (1 + m) .* (Ac * cos(2 * pi * fc * t));

%% Demodulation (Standard)
% Multiply by the same carrier
s_demod = s .* (2 * cos(2 * pi * fc * t));
s_demod=s_demod-mean(s_demod);
% Ideal Low-pass filter (Brick-wall filter)
f = (-fs/2:fs/length(t):fs/2-fs/length(t));
S_demod = fftshift(fft(s_demod));
H = (abs(f) <= 12); % Ideal LPF with 12 Hz cutoff
M_recovered = ifft(ifftshift(S_demod .* H));

%% Demodulation with Frequency Mismatch
fc_mismatch = fc + 2;  % Slightly different frequency
s_demod_fm = s .* (2 * cos(2 * pi * fc_mismatch * t));
s_demod_fm=s_demod_fm-mean(s_demod_fm);
S_demod_fm = fftshift(fft(s_demod_fm));
M_recovered_fm = ifft(ifftshift(S_demod_fm .* H));

%% Demodulation with Phase Mismatch
phase_mismatch = pi/3;  % Phase error
s_demod_pm = s .* (2 * cos(2 * pi * fc * t + phase_mismatch));
s_demod_pm=s_demod_pm-mean(s_demod_pm);
S_demod_pm = fftshift(fft(s_demod_pm));
M_recovered_pm = ifft(ifftshift(S_demod_pm .* H));
time_shift = phase_mismatch / (2 * pi * fm);
% fprintf('Expected Time Shift: %f seconds\n', time_shift);
M_recovered_pm_shifted = interp1(t, real(M_recovered_pm), t - time_shift, 'linear', 'extrap');
%% Plot Results
figure;
set(gcf, 'Position', [100, 100, 900, 700]); % Adjust figure size
subplot(4,1,1);
plot(t, s ,'Color', colors(7,:),'LineWidth', 2);
title('AM Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,2);
plot(t, m, 'Color', colors(2,:),'LineWidth', 2);
hold on;
plot(t, real(M_recovered), 'Color', colors(3,:),'LineStyle','--','LineWidth', 2);
title('Standard Demodulation');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
hold off;
legend({'Original Message', 'Demodulated Message'}, 'Location', 'northeast');

subplot(4,1,3);
plot(t, m, 'Color', colors(2,:),'LineWidth', 2);
hold on;
plot(t, real(M_recovered_fm), 'Color', colors(3,:),'LineStyle','--','LineWidth', 2);
title('Demodulation with Frequency Mismatch');
xlabel('Time (s)');
ylabel('Amplitude');
legend({'Original Message', 'Demodulated Message'}, 'Location', 'northeast');
grid on;
hold off;

subplot(4,1,4);
plot(t, m, 'Color', colors(2,:),'LineWidth', 2);
hold on;
plot(t, M_recovered_pm_shifted, 'Color', colors(3,:),'LineStyle','--','LineWidth', 2);
title('Demodulation with Phase Mismatch');
xlabel('Time (s)');
ylabel('Amplitude');
legend({'Original Message', 'Demodulated Message'}, 'Location', 'northeast');
grid on;
hold off;

%% Save the figure
saveas(gcf, 'demodulation_results.png'); % Save as PNG
saveas(gcf, 'demodulation_results.fig'); % Save as FIG