%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 10-2:              %
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
% Generate alpha values
a = linspace(0, 1, 1000);

% Compute entropy function
H = -(a.*log2(a)+(1-a).*log2(1-a));

% Handle NaNs caused by log2(0)
H(isnan(H)) = 0;

%% new figure
% Plot
figure;
hold on;

%% axis
ylim([-0.1, 1.2]);
xlim([-0.1, 1.2]); 

% Define the gray color for the axes and arrowheads
grayColor = [0.5, 0.5, 0.5];

% Plot the vertical line (Y Axis)
x_shaft = [0, 0]; % x-coordinates
y_shaft = [0, 1.1]; % y-coordinates
plot(x_shaft, y_shaft, 'k-', 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the vertical axis
arrow_x = [-0.02, 0, 0.02]; % x-coordinates of the triangle (base from -20 to 20)
arrow_y = [1.1, 1.15, 1.1]; % y-coordinates of the triangle (top at y = 600)
p = fill(arrow_x, arrow_y, grayColor); % Fill the triangle with gray color
p.EdgeColor = grayColor;

% Plot the horizontal line (X Axis)
x_shaft1 = [0, 1.1]; % x-coordinates
y_shaft1 = [0, 0]; % y-coordinates
plot(x_shaft1, y_shaft1, 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the horizontal axis
arrow_y1 = [-0.02, 0, 0.02]; % y-coordinates of the triangle (base from -10 to 10)
arrow_x1 = [1.1, 1.15, 1.1]; % x-coordinates of the triangle (tip at x = 2050)
p1 = fill(arrow_x1, arrow_y1, grayColor); % Fill the triangle with gray color
p1.EdgeColor = grayColor;

%% plot
plot(a, H, 'b', 'LineWidth', 2.25);       % Entropy function

% Add vertical line at alpha = 0.5 from y = 0 to y = 1
line([0.5 0.5], [0 1], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

% Add horizontal line at H = 1 from alpha = 0 to 0.5
line([0 0.5], [1 1], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

% Labels and title
xlabel('Symbol probability, \alpha');
ylabel('H(\alpha)');
title('Entropy function H(\alpha)');

% Legend and grid
grid on;

%% new figure
% Plot
figure;
hold on;

%% Axis
ylim([-0.1, 1.2]);
xlim([-0.1, 1.2]); 

% Define the gray color for the axes and arrowheads
grayColor = [0.5, 0.5, 0.5];

% Plot the vertical line (Y Axis)
x_shaft = [0, 0]; % x-coordinates
y_shaft = [0, 1.1]; % y-coordinates
plot(x_shaft, y_shaft, 'k-', 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the vertical axis
arrow_x = [-0.02, 0, 0.02]; % x-coordinates of the triangle (base from -20 to 20)
arrow_y = [1.1, 1.15, 1.1]; % y-coordinates of the triangle (top at y = 600)
p = fill(arrow_x, arrow_y, grayColor); % Fill the triangle with gray color
p.EdgeColor = grayColor;

% Plot the horizontal line (X Axis)
x_shaft1 = [0, 1.1]; % x-coordinates
y_shaft1 = [0, 0]; % y-coordinates
plot(x_shaft1, y_shaft1, 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the horizontal axis
arrow_y1 = [-0.02, 0, 0.02]; % y-coordinates of the triangle (base from -10 to 10)
arrow_x1 = [1.1, 1.15, 1.1]; % x-coordinates of the triangle (tip at x = 2050)
p1 = fill(arrow_x1, arrow_y1, grayColor); % Fill the triangle with gray color
p1.EdgeColor = grayColor;

%% plot
plot(a, 1 - H, 'b', 'LineWidth', 2.25);       % Channel capacity

% Labels and title
xlabel('Transition probability \alpha');
ylabel('Channel capacity C');
title('Channel capacity C');

% Legend and grid
grid on;
