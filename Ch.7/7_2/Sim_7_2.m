%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   GUI for Illustrating SNR vs. Gamma in Analog Modulation    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 6 - Section 6-4                    %
%                                                              %
%                                                              %
%   Version1:             04/01/08                             %
%   By: Dr. Farnaz Ghassemi                                    %
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

% Define x range
x = -5:0.01:5;

% Standard deviation
sigma = 1;

% Define Gaussian means
shifts = [0, 1, -1, 2, -2, 3, -3, 4, -4]; % First at 0, second at 1/T, third at -1/T, ...
T = 1; % Scaling factor

% Colors
blue = [0 0 1]; % Blue color
red = [1 0 0];  % Red color

% Create figure
figure; 
set(gcf, 'Position', [5, 100, 775, 800]); % Set size again
hold on
grid on;
xlabel('x');
ylabel('Probability Density');
title('Probability Density Function of Noisy Recieved Pulses');

% Sort shifts for x-ticks
shifts2 = [0, 0.5, 1, -1, 2, -2, 3, -3, 4, -4]; % First at 0, second at 1/T, third at -1/T, ...
xticks(sort(shifts2)); 
xticklabels(arrayfun(@(s) sprintf('%d/T', s), sort(shifts2), 'UniformOutput', false));
xticklabels(strrep(xticklabels, '0/T', '0')); % Change '0/T' to '0'
xticklabels(strrep(xticklabels, '5.000000e-01/T', '1/2T')); % Change '0/T' to '0'

% Plot first Gaussian at zero mean
y1 = exp(-((x - shifts(1)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h1 = plot(x, y1, 'Color', colors(1,:), 'LineWidth', 2);

% Compute key points
midpoint = (shifts(1) + shifts(2)) / 2; % 1/2T
right_limit = shifts(2); % 1/T
right_limit2 = shifts(4); % 2/T


% Draw vertical dashed line at midpoint
vline = plot([midpoint midpoint], [0 max(y1)], 'k--', 'LineWidth', 1.5);

% Draw vertical dashed line at 0
vline1 = plot([0 0], [0 max(y1)], 'k--', 'LineWidth', 1.5);
pause(1); % Pause to visualize the first Gaussian


% Identify the correct border regions for red (first change)
idx_red1 = x >=0  & x <= midpoint;  % First Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y1(idx_red1), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% Plot second Gaussian at mean 1/T
y2 = exp(-((x - shifts(2)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h2 = plot(x, y2, 'Color',colors(2,:), 'LineWidth', 2);
pause(1); % Pause to visualize the second Gaussian

% Identify the correct border regions for red (first change)
idx_red1 = x >= midpoint & x <= right_limit;  % First Gaussian (1/2T to 1/T)
idx_red2 = x >= 0 & x <= midpoint;  % Second Gaussian (0 to 1/2T)


% Change only the correct border regions to red
%plot(x(idx_red1), y1(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y2(idx_red2), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% % Restore colors to blue
% plot(x(idx_red1), y1(idx_red1), 'Color', 'k', 'LineWidth', 2);
% plot(x(idx_red2), y2(idx_red2), 'Color', blue, 'LineWidth', 2);
% pause(1); % Pause before adding the third Gaussian

% Plot third Gaussian at -1/T
y3 = exp(-((x - shifts(3)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h3 = plot(x, y3, 'Color', colors(4,:), 'LineWidth', 2);
pause(1); % Pause to visualize the third Gaussian

% Identify the new red regions for second and third Gaussians
idx_red3 = x >= -midpoint & x <= 0;  % Second Gaussian (-1/2T to 0)
idx_red4 = x >= 0 & x <= midpoint;  % Third Gaussian (0 to 1/2T)

% Change these new parts to red
%plot(x(idx_red3), y2(idx_red3), 'Color', red, 'LineWidth', 2);
plot(x(idx_red4), y3(idx_red4), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% % Restore colors to blue
% plot(x(idx_red3), y2(idx_red3), 'Color', blue, 'LineWidth', 2);
% plot(x(idx_red4), y3(idx_red4), 'Color', blue, 'LineWidth', 2);

% Plot second Gaussian at mean 2/T
y4 = exp(-((x - shifts(4)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h4 = plot(x, y4, 'Color', colors(5,:), 'LineWidth', 2);
pause(1); % Pause to visualize the second Gaussian

% Identify the correct border regions for red (first change)
idx_red5 = x >= midpoint & x <= right_limit;  % First Gaussian (1/2T to 1/T)
idx_red6 = x >= 0 & x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
%plot(x(idx_red5), y3(idx_red5), 'Color', red, 'LineWidth', 2);
plot(x(idx_red6), y4(idx_red6), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% % Restore colors to blue
% plot(x(idx_red1), y3(idx_red1), 'Color', blue, 'LineWidth', 2);
% plot(x(idx_red2), y4(idx_red2), 'Color', blue, 'LineWidth', 2);
% pause(1); % Pause before adding the third Gaussian


% Plot second Gaussian at mean -2/T
y5 = exp(-((x - shifts(5)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h5 = plot(x, y5, 'Color', colors(6,:), 'LineWidth', 2);
pause(1); % Pause to visualize the second Gaussian

% Identify the new red regions for second and third Gaussians
idx_red7 = x >= -midpoint & x <= 0;  % Second Gaussian (-1/2T to 0)
idx_red8 = x >= 0 & x <= midpoint;  % Third Gaussian (0 to 1/2T)

% Change these new parts to red
%plot(x(idx_red7), y4(idx_red7), 'Color', red, 'LineWidth', 2);
plot(x(idx_red8), y5(idx_red8), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% % Restore colors to blue
% plot(x(idx_red3), y4(idx_red3), 'Color', blue, 'LineWidth', 2);
% plot(x(idx_red4), y5(idx_red4), 'Color', blue, 'LineWidth', 2);

% Plot second Gaussian at mean 3/T
y4 = exp(-((x - shifts(6)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h4 = plot(x, y4, 'Color', colors(7,:), 'LineWidth', 2);
pause(1); % Pause to visualize the second Gaussian

% Identify the correct border regions for red (first change)
idx_red5 = x >= midpoint & x <= right_limit;  % First Gaussian (1/2T to 1/T)
idx_red6 = x >= 0 & x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
%plot(x(idx_red5), y3(idx_red5), 'Color', red, 'LineWidth', 2);
plot(x(idx_red6), y4(idx_red6), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% % Restore colors to blue
% plot(x(idx_red1), y3(idx_red1), 'Color', blue, 'LineWidth', 2);
% plot(x(idx_red2), y4(idx_red2), 'Color', blue, 'LineWidth', 2);
% pause(1); % Pause before adding the third Gaussian


% Plot second Gaussian at mean -2/T
y5 = exp(-((x - shifts(7)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h5 = plot(x, y5, 'Color', colors(8,:), 'LineWidth', 2);
pause(1); % Pause to visualize the second Gaussian

% Identify the new red regions for second and third Gaussians
idx_red7 = x >= -midpoint & x <= 0;  % Second Gaussian (-1/2T to 0)
idx_red8 = x >= 0 & x <= midpoint;  % Third Gaussian (0 to 1/2T)

% Change these new parts to red
%plot(x(idx_red7), y4(idx_red7), 'Color', red, 'LineWidth', 2);
plot(x(idx_red8), y5(idx_red8), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% % Restore colors to blue
% plot(x(idx_red3), y4(idx_red3), 'Color', blue, 'LineWidth', 2);
% plot(x(idx_red4), y5(idx_red4), 'Color', blue, 'LineWidth', 2);

hold off;

%%---------------------------------------------------------------
% Create figure
figure; 
set(gcf, 'Position', [800, 100, 770, 800]); % Set size again
hold on;
grid on;
xlabel('x');
ylabel('Probability Density');
title('Nyquist Pulse Shaping Criteria');

% Sort shifts for x-ticks
shifts2 = [0, 0.5, 1, -1, 2, -2, 3, -3, 4, -4]; % First at 0, second at 1/T, third at -1/T, ...
xticks(sort(shifts2)); 
xticklabels(arrayfun(@(s) sprintf('%d/T', s), sort(shifts2), 'UniformOutput', false));
xticklabels(strrep(xticklabels, '0/T', '0')); % Change '0/T' to '0'
xticklabels(strrep(xticklabels, '5.000000e-01/T', '1/2T')); % Change '0/T' to '0'

% Plot first Gaussian at zero mean
y1 = exp(-((x - shifts(1)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));
h1 = plot(x, y1, 'Color', colors(1,:), 'LineWidth', 2);

% Compute key points
midpoint = (shifts(1) + shifts(2)) / 2; % 1/2T
right_limit = shifts(2); % 1/T
right_limit2 = shifts(4); % 2/T

% Draw vertical dashed line at 0 and midpoint
vline = plot([midpoint midpoint], [0 max(y1)], 'k--', 'LineWidth', 1.5);
vline1 = plot([0 0], [0 max(y1)], 'k--', 'LineWidth', 1.5);

pause(1); % Pause to visualize the first Gaussian

% Erase Previous parts 
plot(x(x <= 0), y1(x <= 0), 'Color',[1 1 1], 'LineWidth', 2);

% Identify the correct border regions for red (first change)
idx_red1 = x >=0  & x <= midpoint;  % First Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y1(idx_red1), 'Color', colors(1,:), 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% Plot second Gaussian at mean 1/T
y2 = exp(-((x - shifts(2)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));

% Identify the correct border regions for red (first change)
idx_red1 = x >= midpoint;  % First Gaussian (1/2T to 1/T)
idx_red2 = x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y1(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y2(idx_red2), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders
plot(x(idx_red1), y1(idx_red1), 'Color',[1 1 1], 'LineWidth', 2);
plot(x(idx_red2), y2(idx_red2), 'Color',colors(2,:), 'LineWidth', 2);
% Identify the correct border regions for red (first change)
idx_red1 = x >= midpoint & x <= right_limit;  % First Gaussian (1/2T to 1/T)
idx_red2 = x >= 0 & x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
%plot(x(idx_red1), y1(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y1(idx_red2), 'Color', colors(1,:), 'LineWidth', 2);
plot(x(idx_red2), y2(idx_red2), 'Color', colors(2,:), 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders


% Plot third Gaussian at -1/T
y3 = exp(-((x - shifts(3)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));

% Identify the correct border regions for red (first change)
idx_red1 = x <= 0;  % First Gaussian (0 to 1/2T)
idx_red2 = x >= 0;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y2(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y3(idx_red2), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

plot(x(idx_red1), y2(idx_red1), 'Color',[1 1 1], 'LineWidth', 2);
plot(x(idx_red2), y3(idx_red2), 'Color',colors(4,:), 'LineWidth', 2);
% Identify the correct border regions for red (first change)
idx_red1 = x >= -midpoint & x <= 0;  % First Gaussian (0 to -1/2T)
idx_red2 = x >= 0 & x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
%plot(x(idx_red1), y1(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y2(idx_red2), 'Color', colors(2,:), 'LineWidth', 2);
plot(x(idx_red2), y3(idx_red2), 'Color', colors(4,:), 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% Plot second Gaussian at mean 2/T
y4 = exp(-((x - shifts(4)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));

% Identify the correct border regions for red (first change)
idx_red1 = x >= midpoint;  % First Gaussian (1/2T to 1/T)
idx_red2 = x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y3(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y4(idx_red2), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

plot(x(idx_red1), y3(idx_red1), 'Color',[1 1 1], 'LineWidth', 2);
plot(x(idx_red2), y4(idx_red2), 'Color',colors(5,:), 'LineWidth', 2);


% Identify the correct border regions for red (first change)
idx_red1 = x >= midpoint & x <= right_limit;  % First Gaussian (1/2T to 1/T)
idx_red2 = x >= 0 & x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
%plot(x(idx_red1), y1(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y3(idx_red2), 'Color', colors(4,:), 'LineWidth', 2);
plot(x(idx_red2), y4(idx_red2), 'Color', colors(5,:), 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

% Plot third Gaussian at -1/T
y5 = exp(-((x - shifts(5)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));

% Identify the correct border regions for red (first change)
idx_red1 = x <= 0;  % First Gaussian (0 to 1/2T)
idx_red2 = x >= 0;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y4(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y5(idx_red2), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

plot(x(idx_red1), y4(idx_red1), 'Color',[1 1 1], 'LineWidth', 2);
plot(x(idx_red2), y5(idx_red2), 'Color',colors(6,:), 'LineWidth', 2);
pause(1.5)
% Plot second Gaussian at mean 3/T
y6 = exp(-((x - shifts(6)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));

% Identify the correct border regions for red (first change)
idx_red1 = x >= midpoint;  % First Gaussian (1/2T to 1/T)
idx_red2 = x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y5(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y6(idx_red2), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

plot(x(idx_red1), y5(idx_red1), 'Color',[1 1 1], 'LineWidth', 2);
plot(x(idx_red2), y6(idx_red2), 'Color',colors(7,:), 'LineWidth', 2);

% Identify the correct border regions for red (first change)
idx_red2 = x <= 0;  % Second Gaussian (0 to 1/2T)

%plot(x(idx_red2), y6(idx_red2), 'Color', [1 1 1], 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders


% Plot third Gaussian at -1/T
y7 = exp(-((x - shifts(7)).^2) / (2 * sigma^2)) / (sigma * sqrt(2 * pi));

% Identify the correct border regions for red (first change)
idx_red1 = x <= 0;  % First Gaussian (0 to 1/2T)
idx_red2 = x >= 0;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
plot(x(idx_red1), y6(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y7(idx_red2), 'Color', red, 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

plot(x(idx_red1), y6(idx_red1), 'Color',[1 1 1], 'LineWidth', 2);
plot(x(idx_red2), y7(idx_red2), 'Color',colors(7,:), 'LineWidth', 2);
% Identify the correct border regions for red (first change)
idx_red1 = x >= -midpoint & x <= 0;  % First Gaussian (0 to -1/2T)
idx_red2 = x >= 0 & x <= midpoint;  % Second Gaussian (0 to 1/2T)

% Change only the correct border regions to red
%plot(x(idx_red1), y1(idx_red1), 'Color', red, 'LineWidth', 2);
plot(x(idx_red2), y6(idx_red2), 'Color', colors(7,:), 'LineWidth', 2);
plot(x(idx_red2), y7(idx_red2), 'Color', colors(8,:), 'LineWidth', 2);
plot(x(x >= midpoint), y7(x >= midpoint), 'Color', [1 1 1], 'LineWidth', 2);
pause(1.5); % Pause to highlight the red borders

grid on
hold off;
