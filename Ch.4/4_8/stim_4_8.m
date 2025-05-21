% MATLAB Code to Plot the Function 1 / (t - lambda)
% MATLAB Code to Plot Hilbert Transform in Time and Frequency Domains
figure;
subplot(2,1,1);
hold on;
ylim([-15, 15]); % Set the y-axis range from -1 to 1
xlim([-2, 3.2]); % Set the x-axis range from -12 to 12

% Plot the vertical line (Y Axis)
x_shaft = [0, 0]; % Shifted x-coordinates
y_shaft = [-12, 12]; % Shifted y-coordinates down by 0.5
grayColor = [0.5, 0.5, 0.5];
plot(x_shaft, y_shaft, 'k-', 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the vertical axis
arrow_x = [- 0.04, 0, 0.04];
arrow_y = [12, 13, 12]; 
p = fill(arrow_x, arrow_y, grayColor); % Fill the triangle with gray color
p.EdgeColor = grayColor;

% Parameters
A = 5;         % Amplitude of the rectangular pulse
tau = 2;       % Duration of the rectangular pulse
t = linspace(-2, 2.5, 1000); % Time vector limited to [-1, 2]

% Define the rectangular pulse x(t)
x = A * (t >= 0 & t <= tau); 
plot(t, x, 'r', 'LineWidth', 2.25); % Plot x(t)

% Plot the horizontal line (X Axis)
x_shaft1 = [-1.5 - 0.7, 3.5 - 0.7]; % Shifted x-coordinates
y_shaft1 = [0, 0]; % Shifted y-coordinates down by 0.5
plot(x_shaft1, y_shaft1, 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the horizontal axis
arrow_y1 = [-0.5, 0, 0.5]; % Shifted y-coordinates down by 0.5
arrow_x1 = [3.5 - 0.7, 3.6 - 0.7, 3.5 - 0.7]; % Shifted x-coordinates of the triangle (tip at x = 10.3)
p1 = fill(arrow_x1, arrow_y1, grayColor); % Fill the triangle with gray color
p1.EdgeColor = grayColor;


%plot([lambda - 0.7 lambda - 0.7], [-11 11], 'k--', 'LineWidth', 1);
h1 = plot(NaN, NaN, 'b', 'LineWidth', 2.25);
h2 = plot(NaN, NaN, 'k--', 'LineWidth', 1); % Pulse signal
lambda_values = linspace(-2, 3, 1000); % Gradually change lambda over time (slower animation)



text(3, 0.5, '\lambda', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k'); % Label for x-axis
text(1.95, -1.5, '\tau', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k'); % Label for y-axis
text(1, 8, 'x(t)', 'FontSize', 14, 'Color', 'k'); % Label for y-axis
text(-0.15, -1.6, '0', 'FontSize', 14, 'Color', 'k'); % Label for y-axis
text(-0.15, 5, 'A', 'FontSize', 14, 'Color', 'k'); % Label for y-axis
text(-1.5, 8, '^{1}/_{t-\lambda}', 'FontSize', 18, 'Color', 'k'); % Label for y-axis


% Add labels and grid
xlabel('t');
ylabel('1 / (t - \lambda)');
grid on;
hold off;

subplot(2,1,2);
hold on;
grid on
ylim([-16, 16]); % Set the y-axis range from -1 to 1
xlim([-2, 3.5]); % Set the x-axis range from -12 to 12

% Plot the vertical line (Y Axis)
x_shaft = [0, 0]; 
y_shaft = [-14, 14]; % Adjusted for larger amplitude
grayColor = [0.5, 0.5, 0.5];
plot(x_shaft, y_shaft, 'k-', 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the vertical axis
arrow_x = [-0.04, 0, 0.04 ]; 
arrow_y = [14, 15, 14]; % Adjusted arrow size
p = fill(arrow_x, arrow_y, grayColor); 
p.EdgeColor = grayColor;

% Parameters
A = 5;         % Increased amplitude of the rectangular pulse
tau = 2;       % Duration of the rectangular pulse
t = linspace(-2, 3, 1000); % Extended time range

% Define the rectangular pulse x(t)
x = A * (t >= 0 & t <= tau); 

% Define the Hilbert transform impulse response h(t)
h = 1 ./ (pi * t); 
h(t == 0) = 0; 

% Convolve x(t) with h(t) to get \tilde{x}(t)
%xtilde = conv(x, h, 'same') * (t(2) - t(1)); 

xtilde = A ./ pi * log(abs(t ./ (t - tau))); % Take absolute value to avoid complex numbers

% Plot the rectangular pulse x(t)
plot(t, x, 'r', 'LineWidth', 2.25); 

% Plot the horizontal line (X Axis)
x_shaft1 = [-2.5, 3.2]; 
y_shaft1 = [0, 0]; 
plot(x_shaft1, y_shaft1, 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the horizontal axis
arrow_y1 = [-0.5, 0, 0.5]; % Adjusted arrow size
arrow_x1 = [3.2, 3.3, 3.2]; 
p1 = fill(arrow_x1, arrow_y1, grayColor); 
p1.EdgeColor = grayColor;

% Plot \tilde{x}(t)
%plot(t, xtilde, 'b', 'LineWidth', 2.25); 
h4 = plot(nan, nan, 'b', 'LineWidth', 2.25); % For Hilbert Transform
% Update text annotations
text(3.35, 0.15, 't', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k'); 
text(1.95, -1.5, '\tau', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k'); % Label for y-axis
text(-0.15, -1.6, '0', 'FontSize', 14, 'Color', 'k'); % Label for y-axis
text(-0.15, 5, 'A', 'FontSize', 14, 'Color', 'k'); % Label for y-axis
text(1, 8, 'x(t)', 'FontSize', 14, 'Color', 'k'); % Moved to match new amplitude


numPoints = length(t);
for i = 1:5:numPoints
    lambda = lambda_values(i);
    y = -1 ./ (t - lambda);
    y(abs(y) > 11) = NaN; % Avoid extreme values
    set(h1, 'XData', t, 'YData', y);
    set(h2, 'XData', [lambda, lambda], 'YData', [-11, 11]); % Show pulse at lambda
    % Update second subplot
    set(h4, 'XData', t(1:i), 'YData', xtilde(1:i)); % Hilbert transform   

    % Force MATLAB to update the figure window immediately
    pause(0.05); % Slower animation
end

xlabel('t');
ylabel('Amplitude');
grid on;
hold off;
text(0.95, -3, '^{\tau}/_{2}', 'FontSize', 14, 'Color', 'k'); 
text(2.2, 6.5, '$\tilde{x}(t)$', 'Interpreter', 'latex', 'FontSize', 14, 'Color', 'k');
