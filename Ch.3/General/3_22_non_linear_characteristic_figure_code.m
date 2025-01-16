figure;
hold on;
ylim([-1, 1]); % Set the y-axis range from -1 to 1
xlim([-12, 12]); % Set the x-axis range from -12 to 12

% Plot the vertical line (Y Axis)
x_shaft = [0, 0]; % x-coordinates
y_shaft = [-0.75, 0.73]; % Shifted y-coordinates down by 0.5
grayColor = [0.5, 0.5, 0.5];
plot(x_shaft, y_shaft, 'k-', 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the vertical axis
arrow_x = [-0.2, 0, 0.2]; % x-coordinates of the triangle (base from -0.2 to 0.2)
arrow_y = [0.65, 0.75, 0.65]; % Shifted y-coordinates down by 0.5
p = fill(arrow_x, arrow_y, grayColor); % Fill the triangle with gray color
p.EdgeColor = grayColor;

% Plot the horizontal line (X Axis)
x_shaft1 = [-10, 10]; % x-coordinates
y_shaft1 = [0, 0]; % Shifted y-coordinates down by 0.5
plot(x_shaft1, y_shaft1, 'LineWidth', 2.5, 'Color', grayColor);

% Plot the triangular arrowhead for the horizontal axis
arrow_y1 = [-0.04, 0, 0.04]; % Shifted y-coordinates down by 0.5
arrow_x1 = [9.85, 10.3, 9.85]; % x-coordinates of the triangle (tip at x = 10.3)
p1 = fill(arrow_x1, arrow_y1, grayColor); % Fill the triangle with gray color
p1.EdgeColor = grayColor;

% Add "x(t)" and "y(t)" labels near the arrowheads
text(10.5, 0.01, 'X(f)', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k'); % Label for x-axis
text(-0.2, 0.85, 'Y(f)', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k'); % Label for y-axis

% Define the x range and sigmoid function
x = linspace(-10, 10, 500); % x values
f = 1 ./ (1 + exp(-x)) - 0.5; % Shifted sigmoid function down by 0.5

% Compute the slope (derivative)
df_dx = gradient(f, x); % Numerical derivative using finite differences

% Plot the sigmoid function
plot(x, f, 'b-', 'LineWidth', 4); % Plot shifted sigmoid function

% Define a specific point of interest for the tangent line
x_point = 0; % Point where the tangent is computed
[~, idx] = min(abs(x - x_point)); % Find the closest index to x_point
slope_value = df_dx(idx); % Slope at x_point
f_value = f(idx); % Function value at x_point

% Define the interval for the tangent line
x_interval = [-2, 2.1]; % Interval for tangent line
x_tangent = linspace(x_interval(1), x_interval(2), 100); % x values in the interval

% Compute the tangent line in the interval
tangent_line = f_value + slope_value * (x_tangent - x_point); % Tangent equation

% Plot the tangent line within the interval
plot(x_tangent, tangent_line, 'r-', 'LineWidth', 2.25); % Tangent line

% Define the interval for the top horizontal line
x_interval1 = [2.1, 10]; % Interval for the top horizontal line
x_tangent1 = linspace(x_interval1(1), x_interval1(2), 100); % x values in the interval
y_top = ones(size(x_tangent1)) * 0.51; % Shifted horizontal line at the top
plot(x_tangent1, y_top, 'r-', 'LineWidth', 2.25); % Horizontal line

% Define the interval for the bottom horizontal line
x_interval2 = [-10, -2]; % Interval for the bottom horizontal line
x_tangent2 = linspace(x_interval2(1), x_interval2(2), 100); % x values in the interval
y_bottom = zeros(size(x_tangent2)) - 0.51; % Shifted horizontal line at the bottom
plot(x_tangent2, y_bottom, 'r-', 'LineWidth', 2.25); % Horizontal line

% Add axis labels
xlabel('X(f)');
ylabel('Y(f)');
grid on;
