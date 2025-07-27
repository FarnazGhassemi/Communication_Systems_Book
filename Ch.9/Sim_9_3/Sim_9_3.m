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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ax = gca;
%ax.XTick = -5:1:5; % Adjust the x-axis grid spacing
%ax.YTick = -1:0.2:2; % Adjust the y-axis grid spacing

close all;
clc;
clear;

% Parameters
A = 1;
T = 1;
t = linspace(-0.5, 1.5, 1000); % Time vector for plotting

% Define signals as function handles and names
signals = {
    @(t) A*t/T .* (t > 0 & t < T), 'Ramp';
    @(t) A*(1 - abs(t - T/2)/(T/2)).*(t >= 0 & t <= T), 'Triangular';
    @(t) A*(t >= 0 & t <= T), 'Pulse';
    @(t) (-A)*(t >= 0 & t <= T/2) + 2*A*(t > T/2 & t <= T), 'Pulse';
    @(t) A*sin(8*pi*t/T).*(t >= 0 & t <= T), 'Sine'
};

figure;
for i = 1:size(signals,1)
    f = signals{i,1};
    name = signals{i,2};

    % Original signal
    y = f(t);
    
    % Signal squared
    y2 = y.^2;
    
    % Integral (cumulative using trapezoidal rule)
    y_int = cumtrapz(t, y2);
    
    % Plot original signal
    subplot(size(signals,1), 3, (i-1)*3 + 1);
    plot(t, y, 'b', 'LineWidth', 2.25);
    title([name ' Signal']);
    xlabel('t');
    ylabel('Amplitude');
    grid on;
    
    % Plot squared signal
    subplot(size(signals,1), 3, (i-1)*3 + 2);
    plot(t, y2, 'b', 'LineWidth', 2.25);
    title([name ' Squared']);
    xlabel('t');
    ylabel('Amplitude^2');
    grid on;
    
    % Plot integral of squared signal
    subplot(size(signals,1), 3, (i-1)*3 + 3);
    plot(t, y_int, 'b', 'LineWidth', 2.25);
    title(['Integral of ' name '^2']);
    xlabel('t');
    ylabel('Energy');
    grid on;
end

sgtitle('Correlator Simulation');
