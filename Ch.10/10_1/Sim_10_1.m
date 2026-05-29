%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 10-1:              %
%           Entropy of Biosignals comparing to noise           %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 10-Section                       %
%                                                              %
%                                                              %
%   Version.1:             04/03/03---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------
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
%%---------------------------------------------------------------
n=60*512;
t0=60;
% Initialize empty data and labels
values = [];
labels = {};
% Entropy Calculation and Visualization
m=randn(1,n);
symbols = unique(m);
counts = histcounts(m, [symbols]);
p = counts / length(m);

% 
entropy = -sum(p .* log2(p)); 
disp(['Entropy of Gaussian noise: ', num2str(entropy)]);

values(end+1) = entropy;
labels{end+1} = 'Gaussian noise';

% Load IPG Signal
load('IP.mat'); 
m=IP;
fs = 450;         % Sampling frequency
% Limit to first 3 seconds
N = min(length(m), t0 * fs);
t = (0:N-1) /fs;
m = m(1:N);
% 
symbols = unique(m);
counts = histcounts(m, [symbols]);
p = counts / length(m);
% 
entropy = -sum(p .* log2(p)); 
disp(['Entropy of IPG signal: ', num2str(entropy)]);

values(end+1) = entropy;
labels{end+1} = 'IPG signal';

% Load IPG Signal
load('PPG.mat');  % Contains 'IPG' (time-domain signal)
m=PPG;
fs = 150;         % Sampling frequency
% Limit to first 3 seconds
N = min(length(m), t0 * fs);
t = (0:N-1) /fs;
m = m(1:N);
% 
symbols = unique(m);
counts = histcounts(m, [symbols]);
p = counts / length(m);
% 
entropy = -sum(p .* log2(p)); %
disp(['Entropy of PPG signal: ', num2str(entropy)]);

values(end+1) = entropy;
labels{end+1} = 'PPG signal';

% Load EOG Signal
load('EOG.mat');  
m=EOG;
fs = 256;         % Sampling frequency
% Limit to first 3 seconds
N = min(length(m), t0 * fs);
t = (0:N-1) /fs;
m = m(1:N);
% 
symbols = unique(m);
counts = histcounts(m, [symbols]);
p = counts / length(m);
% 
entropy = -sum(p .* log2(p)); 
disp(['Entropy of EOG signal: ', num2str(entropy)]);

values(end+1) = entropy;
labels{end+1} = 'EOG signal';

% Load ECG Signal
load('ECG.mat');  
m=ECG;
fs = 150;         % Sampling frequency
% Limit to first 3 seconds
N = min(length(m), t0 * fs);
t = (0:N-1) /fs;
m = m(1:N);
% 
symbols = unique(m);
counts = histcounts(m, [symbols]);
p = counts / length(m);
% 
entropy = -sum(p .* log2(p)); 
disp(['Entropy of ECG signal: ', num2str(entropy)]);

values(end+1) = entropy;
labels{end+1} = 'ECG signal';

% Load EMG Signal
load('EMD_Data.mat');  
m=EMG;
fs = 1000;         % Sampling frequency
% Limit to first 3 seconds
N = min(length(m), t0 * fs);
t = (0:N-1) /fs;
m = m(1:N);
% 
symbols = unique(m);
counts = histcounts(m, [symbols]);
p = counts / length(m);
% 
entropy = -sum(p .* log2(p)); 
disp(['Entropy of EMG signal: ', num2str(entropy)]);

values(end+1) = entropy;
labels{end+1} = 'EMG signal';

%values(end+1) = entropy;
%labels{end+1} = 'EEG signal';

% Load EEG_CLean Signal
load('EEGSig_Clean_Fs100.mat'); 
mT=EEGSignal;
fs = 100;         % Sampling frequency
% Limit to first 3 seconds
N = min(length(mT), t0 * fs);
t = (0:N-1) /fs;
mT = mT(1:32,1:N);
% 
for i=1
    m=mT(i,:);
    symbols = unique(m);
    counts = histcounts(m, [symbols]);
    p = counts / length(m);
    % 
    entropy = -sum(p .* log2(p));
    disp(['Entropy of Clean EEG signal: ', num2str(entropy)]);

    values(end+1) = entropy;
    labels{end+1} = 'Clean EEG signal';
end

% Load EEG_CLean with alpha Signal
load('EEGSig_CleanwithAlpha_Fs512.mat'); 
mT=EEGSignal;
fs = 512;         % Sampling frequency
% Limit to first 3 seconds
N = min(length(mT), t0 * fs);
t = (0:N-1) /fs;
mT = mT(1:32,1:N);
% 
for i=1
    m=mT(i,:);
    symbols = unique(m);
    counts = histcounts(m, [symbols]);
    p = counts / length(m);
    % 
    entropy = -sum(p .* log2(p));
    %disp(['Entropy of Clean With Alpha EEG signal: ', num2str(entropy)]);

    %values(end+1) = entropy;
    %labels{end+1} = 'Clean With Alpha EEG signal';
    % figure
    % plot(m)
end

% Load noisy EEG Signal
load('EEGSig_Noisy_Fs200.mat'); 
mT=EEGSignal;
fs = 200;        % Sampling frequency
% Limit to first 3 seconds
N = min(length(mT), t0 * fs);
t = (0:N-1) /fs;
mT = mT(1:21,1:N);
% 
for i=1
    m=mT(i,:);
    symbols = unique(m);
    counts = histcounts(m, [symbols]);
    p = counts / length(m);
    % 
    entropy = -sum(p .* log2(p)); 
    %disp(['Entropy of Noisy EEG signal: ', num2str(entropy)]);

    %values(end+1) = entropy;
    %labels{end+1} = 'Noisy EEG signal';
end

% Visualization
figure;
hold on;
bar(values, 'FaceColor', [0.8 0.2 0.6]);
title('Entropy of Biosignals Comparing to Noise');
ylabel('Entropy');
xticks(1:length(labels));
xticklabels(labels);
grid on;