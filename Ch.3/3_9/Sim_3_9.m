%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Illustrating Non-linear Distortion on Biosignals        %
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
clear all;
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
ECG_signal = data(:);  % Convert to column vector
N = length(ECG_signal);  % Number of samples
t = linspace(0, 5, N);  % Assume a 5-second duration
% Limit to 3 seconds for plotting
t_plot = t(t <= 3);
N_plot = length(t_plot);

%% 🔴 Apply Nonlinear Distortion (Sigmoid Function)
sigmoid = @(x) 1 ./ (1 + exp(-3*x)) ;  % Sigmoid function
ECG_nonlinear_distorted = sigmoid(ECG_signal); % Apply nonlinear transformation

%% 📊 Plot Original and Distorted ECG Signals
figure;

subplot(3,1,1);
plot(t_plot, ECG_signal(1:N_plot), 'Color', colors(2,:), 'LineWidth', 2, 'LineStyle', marks{1}); 
title('Original ECG Signal', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
ylim([-3, 9])

subplot(3,1,2);
plot(t_plot, ECG_nonlinear_distorted(1:N_plot), 'Color', colors(3,:), 'LineWidth', 2, 'LineStyle', marks{1}); 
title('ECG with Nonlinear Distortion - (Sigmoid Function)', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
ylim([-0.2, 1.2])

%% 🔴 Apply Nonlinear Distortion (Sigmoid Function)
sigmoid = @(x) 1./ exp(2*x);  % Exponential function
ECG_nonlinear_distorted = sigmoid(ECG_signal); % Apply nonlinear transformation


subplot(3,1,3);
plot(t_plot, ECG_nonlinear_distorted(1:N_plot), 'Color', colors(4,:), 'LineWidth', 2, 'LineStyle', marks{1}); 
title('ECG with Nonlinear Distortion - (1/exp(2x) Function)', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
ylim([-3, 40])

%% 💾 Save ECG Time-Domain Figure
saveas(gcf, 'ECG_Nonlinear_Time.fig');  % Save as MATLAB figure
print(gcf, 'ECG_Nonlinear_Time.png', '-dpng', '-r300');  % Save as high-resolution PNG


