function H = vsb_filter(Fc, beta, steepness, f)
    %% Define Colors
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Compute Corrected Vestigial Sideband Component
    H_beta = 0.5 * tanh(steepness * f / beta); % Odd function
    H_beta(abs(f) > beta) = 0;  % Zero outside |f| > beta

    %% Compute Corrected Full VSB Filter Response
    H = 0.5 * (1 + tanh(steepness * (abs(f) - Fc) / beta));  % Smooth transition
    H = H + flip(H);
    H = H / max(H); 

    %% Plot Results
%     figure;
% 
%     % (1) Full Filter Response (Smooth Step)
%     subplot(2,1,1);
%     plot(f, H, 'Color', colors(2,:), 'LineWidth', 2);
%     xlabel('f');
%     ylabel('H(f)');
%     grid on;
%     xlim([0, 1.5*Fc]); 
%     ylim([-0.1, 1.1]); 
%     xline(Fc, '--k', 'Fc', 'LineWidth', 2,'Color', colors(3,:));
%     xline(Fc - beta, '--k', 'Fc-\beta', 'LineWidth', 2,'Color', colors(3,:));
%     xline(Fc + beta, '--k', 'Fc+\beta', 'LineWidth', 2,'Color', colors(3,:));
% 
% 
%     % (2) Vestigial Sideband Component (Odd Symmetry)
%     subplot(2,1,2);
%     plot(f, H_beta, 'Color', colors(2,:), 'LineWidth', 2);
%     xlabel('f');
%     ylabel('H_{\beta}(f)');
%     grid on;
%     xlim([-beta*1.5, beta*1.5]);
%     ylim([-0.6, 0.6]);
%     xline(-beta, '--k', '-\beta', 'LineWidth', 2,'Color', colors(3,:));
%     xline(beta, '--k', '\beta', 'LineWidth', 2,'Color', colors(3,:));
%     yline(0, 'k--');
%     hold on; % Keep existing plots
%     plot([min(f), max(f)], [0, 0], 'k', 'LineWidth', 1.5); % Bold y = 0 (x-axis)
%     plot([0, 0], ylim, 'k', 'LineWidth', 1.5); % Bold x = 0 (y-axis)
%     hold off;
%     %% Save the figure
%     saveas(gcf, 'vsb_filter_response.png');  % Save as PNG
%     saveas(gcf, 'vsb_filter_response.fig');  % Save as MATLAB .fig file


end
