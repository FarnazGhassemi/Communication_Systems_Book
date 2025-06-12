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

% Define the data points
x = [1, 3, 5, 7, 9, 11]; % n values (odd numbers)
x1 = [1, 1/3, 1/5, 1/7, 1/9, 1/11]; % Code rate, r

p_values = [0.01, 0.0001, 0.25, 0.5]; % Different p's to explore
colors=[
        0,0,0.75;                    %2-Blue
        214/255,39/255,40/255;       %3-Red
        15/255,133/255,84/255;       %4-Green
        118/255,78/255,159/255;     %5-Purple

        ];
markers = ['o'];

% Create a finer x-grid for interpolation
%xq = linspace(min(x1), max(x1), 1000);
xq = logspace(log10(min(x1)), log10(max(x1)), 1000);

figure;
hold on; grid on;

% Decide which index gets %.4f (e.g., the first one)
special_idx = 2;

for idx = 1:length(p_values)
    p = p_values(idx);
    
    % Initialize y
    y = zeros(size(x));
    
    % Compute y[i] = sum of binomial probabilities from (n+1)/2 to n
    for i = 1:length(x)
        n = x(i);
        k_start = (n + 1)/2; % starting value of k (majority)
        
        % Initialize the sum for the current n
        y_sum = 0;
        
        % Compute the binomial probabilities for k_start to n
        for k = k_start:n
            y_sum = y_sum + nchoosek(n, k) * p^k * (1 - p)^(n - k);
        end
        
        % Assign the result to y(i)
        y(i) = y_sum;
    end
    
    % Interpolate using makima
    %y_interp = interp1(x1, y, xq, 'makima');
    % Interpolate in log-log space
    y_log = log10(y);
    y_interp_log = interp1(log10(x1), y_log, log10(xq), 'makima');
    y_interp = 10.^y_interp_log;

    %y_interp = max(y_interp, 1e-8); % Clip to minimum value

    % Choose format based on index
    if idx == special_idx
        label_str = sprintf('p = %.4f', p);
    else
        label_str = sprintf('p = %.2f', p);
    end
    
    % Plot the interpolated curve
    %plot(xq, y_interp, 'LineWidth', 2.25, 'Color', colors(idx, :), 'DisplayName', label_str);
    loglog(xq, y_interp, 'LineWidth', 2.25,'Color', colors(idx, :), 'DisplayName', label_str);

    % Plot the original data points
    %plot(x1, y, 'ro', 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
    loglog(x1, y, 'ro', 'MarkerFaceColor', 'r', 'HandleVisibility', 'off'); 
    hold on;
end

% Set axis properties
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
%xlim([0.01, 10]);
%ylim([1e-8, 1e-1]);

% Labels and title
xlabel('Code rate, r');
ylabel('Average probability of error, P_\epsilon');

% Legend and grid
legend('Location', 'southeast');
grid on;
