%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Illustrating Linear Distortion on Biosignals: 3-6      %
%                     Channel Effects                          %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 3-Section 5                      %
%                                                              %
%                                                              %
%   Version.1:             03/10/27---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;
colors=[0,0,0;                       %1-Black
        0,0,0.75;                    %2-Blue
        214/255,39/255,40/255;       %3-Red
        15/255,133/255,84/255;       %4-Green
        118/255,78/255,159/255;     %5-Purple
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

%% 📥 Load ECG Signal
load('ECG_Sample.mat');  % Load ECG data
ECG_signal = data(:);    % Convert to column vector
ECG_signal(2500:2550,1)=ECG_signal(500:550,1)*0.6;
N = length(ECG_signal);  % Number of samples
Fs = N / 5;              % Assume 5 seconds duration (sampling frequency)
t = (0:N-1) / Fs;        % Time vector
freqs = (0:N-1) / N;     % Normalized frequency axis

% Limit to 3 seconds for plotting
% Focus on the middle 3-second segment (e.g., from 1s to 4s)
t_start = 1; % Start at 1s
t_end = 4;   % End at 4s
indices = find(t >= t_start & t <= t_end);
t_plot = t(indices);
N_plot = length(indices);

%% 🔵 0. Apply Linear Distortion (Case 0: Magnitude, Linear Phase)
H0 = 0.5*ones(size(freqs));                % No magnitude change
td =-490;  % Desired time delay
Phase0 = exp(-2j * pi * freqs * td);        % Negative slope for phase
ECG_fft = fft(ECG_signal);
ECG_not_distorted = real(ifft(ECG_fft .* H0'.* Phase0')); 


%% 🔵 1. Apply Linear Distortion (Case 1: Magnitude Varies, Linear Phase)
H1 = 2*exp(-10 * freqs);               % Magnitude attenuation
td = -50;  % Desired time delay
Phase1 = exp(-2j * pi * freqs* td);        % Negative slope for phase
ECG_mag_distorted = real(ifft(ECG_fft .* H1'.* Phase1')); 

%% 🔴 2. Apply Linear Distortion (Case 2: Constant Magnitude, Phase Varies)

%Quadratic phase distortion
H2 = ones(size(freqs));  % Ensure constant magnitude
k = 1.20;  % Quadratic phase distortion factor (adjustable)
% Define quadratic phase shift to create true phase distortion
td =-50;  % Desired time delay
Phase2 = exp(-j * k * pi * freqs.^2);%+-2j * pi * freqs* td);   

ECG_phase_distorted = real(ifft(ECG_fft .* H2' .* Phase2')); 

%% 🟢 3. Apply Linear Distortion (Case 3: Magnitude & Phase Distortion)
H3 = 2*exp(-10 * freqs) .* exp(1j * k * pi * freqs.^2);  % Combined effect_Quadratic phase distortion
% H3 = 2*exp(-10 * freqs) .* exp(-1j * 2 * pi * freqs * td);  % Combined effect_Linear Phase Shift
ECG_combined_distorted = real(ifft(ECG_fft .* H3'));  

%% 📊 4. Plot Original and Distorted ECG Signals
figure;

subplot(5,1,1);
plot(t_plot, ECG_signal(indices), 'Color', colors(2,:), 'LineWidth', 2, 'LineStyle', marks{1});
title('Original ECG Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(5,1,2);
plot(t_plot, ECG_not_distorted(indices), 'Color',colors(3,:), 'LineWidth', 2, 'LineStyle', marks{1});
title('ECG with No Distortion (Case 0)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(5,1,3);
plot(t_plot, ECG_mag_distorted(indices), 'Color',colors(4,:), 'LineWidth', 2, 'LineStyle', marks{1});
title('ECG with Magnitude Distortion (Case 1)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(5,1,4);
plot(t_plot, ECG_phase_distorted(indices), 'Color', colors(5,:), 'LineWidth', 2, 'LineStyle', marks{1});
title('ECG with Phase Distortion (Case 2)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(5,1,5);
plot(t_plot, ECG_combined_distorted(indices), 'Color', colors(6,:), 'LineWidth', 2, 'LineStyle', marks{1});
title('ECG with Magnitude & Phase Distortion (Case 3)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

% Save figure
% Ensure figure visibility before saving
set(gcf, 'Position', [100, 100, 1200, 800]); % Set figure size (width x height)
set(gca, 'FontSize', 14); % Improve font readability
%set(gca, 'LineWidth', 1.5); % Make plot lines thicker

% Save as MATLAB figure (.fig)
savefig(gcf, 'ECG_Distorted.fig'); 

% Save as PNG with high resolution
print(gcf, 'ECG_Distorted.png', '-dpng', '-r300'); % '-r300' ensures high DPI (300+)


%% 📈 5. Plot Transfer Functions (Magnitude & Phase)
figure;
% Case 0: Magnitude and Phase
subplot(4,2,1);
plot(freqs(1:N/2), abs(H0(1:N/2)), 'Color',colors(2,:), 'LineWidth', 2);
title('Magnitude Response (Case 0)'); xlabel('Normalized Frequency'); ylabel('Magnitude'); grid on;

subplot(4,2,2);
plot(freqs(1:N/2), unwrap(-angle(Phase0(1:N/2))), 'Color', colors(3,:), 'LineWidth', 2);
title('Phase Response (Case 0)'); xlabel('Normalized Frequency'); ylabel('Phase (radians)'); grid on;

% Case 1: Magnitude and Phase
subplot(4,2,3);
plot(freqs(1:N/2), abs(H1(1:N/2)), 'Color',colors(2,:), 'LineWidth', 2);
title('Magnitude Response (Case 1)'); xlabel('Normalized Frequency'); ylabel('Magnitude'); grid on;

subplot(4,2,4);
plot(freqs(1:N/2), unwrap(-angle(Phase1(1:N/2))), 'Color', colors(3,:), 'LineWidth', 2);
title('Phase Response (Case 1)'); xlabel('Normalized Frequency'); ylabel('Phase (radians)'); grid on;

% Case 2: Magnitude and Phase
subplot(4,2,5);
plot(freqs(1:N/2), abs(H2(1:N/2)), 'Color', colors(2,:), 'LineWidth', 2);
title('Magnitude Response (Case 2)'); xlabel('Normalized Frequency'); ylabel('Magnitude'); grid on;

subplot(4,2,6);
plot(freqs(1:N/2), unwrap(-angle(Phase2(1:N/2))), 'Color', colors(3,:), 'LineWidth', 2);
title('Phase Response (Case 2)'); xlabel('Normalized Frequency'); ylabel('Phase (radians)'); grid on;

% Case 3: Magnitude and Phase
subplot(4,2,7);
plot(freqs(1:N/2), abs(H3(1:N/2)), 'Color', colors(2,:), 'LineWidth', 2);
title('Magnitude Response (Case 3)'); xlabel('Normalized Frequency'); ylabel('Magnitude'); grid on;

subplot(4,2,8);
plot(freqs(1:N/2), unwrap(-angle(H3(1:N/2))), 'Color', colors(3,:), 'LineWidth', 2);
title('Phase Response (Case 3)'); xlabel('Normalized Frequency'); ylabel('Phase (radians)'); grid on;

% Save figure
% Ensure figure visibility before saving
set(gcf, 'Position', [100, 100, 1200, 800]); % Set size again
savefig(gcf, 'Transfer_Functions.fig'); 
print(gcf, 'Transfer_Functions.png', '-dpng', '-r300');

