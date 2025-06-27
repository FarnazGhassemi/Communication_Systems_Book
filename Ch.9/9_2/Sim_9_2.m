function PAM_Sinc_GUI
close all
clear all
clc
    % Create figure
    hFig = figure('Name', 'PAM Sinc Visualizer', ...
        'NumberTitle', 'off', ...
        'Resize', 'on', ...
        'Position', [100, 100, 800, 600]);

    % Input panel
    uicontrol('Style', 'text', ...
        'String', 'Enter PAM sequence (e.g. [1 -1 0.5 -0.5]):', ...
        'Units', 'normalized', ...
        'Position', [0.05, 0.93, 0.4, 0.05], ...
        'FontSize', 10);

    hEdit = uicontrol('Style', 'edit', ...
        'String', '[1 -1 0.5 -0.5]', ...
        'Units', 'normalized', ...
        'Position', [0.45, 0.935, 0.4, 0.05], ...
        'FontSize', 10);

    uicontrol('Style', 'pushbutton', ...
        'String', 'Plot', ...
        'Units', 'normalized', ...
        'Position', [0.87, 0.935, 0.08, 0.05], ...
        'Callback', @(src, event) plotSinc(hEdit), ...
        'FontSize', 10);

    % Axes for plots
    hAx1 = axes('Units', 'normalized', ...
        'Position', [0.08, 0.53, 0.88, 0.35]);

    hAx2 = axes('Units', 'normalized', ...
        'Position', [0.08, 0.1, 0.88, 0.35]);

    function plotSinc(hEdit)
        cla(hAx1);
        cla(hAx2);

        try
            a = str2num(get(hEdit, 'String')); %#ok<ST2NM>
            if isempty(a)
                error('Invalid input.');
            end
        catch
            errordlg('Invalid PAM sequence. Please enter a valid vector.', 'Error');
            return;
        end

        N = length(a);
        T = 1;              % Symbol duration
        t = linspace(-2, N, (N+2) * 100);
        y_total = zeros(size(t));
        z_total = [];
        colors = lines(N);  % Distinct colors

        % Plot each sinc
        axes(hAx1); hold on;
        for i = 1:N
            t_shift = t - (i-1)*T;
            y = a(i) * sinc(t_shift/T);
            plot(t, y, 'Color', colors(i,:), 'LineWidth', 2);
            y_total = y_total + y;
            z = a(i) .* ones(1,100);
            size(z)
            t2=[i-1.5:0.01:i-0.5];
            t2=t2(1,1:100);
            size(t2)
            plot(t2, z, 'Color', colors(i,:), 'LineWidth', 2); % original PAM
             if i==1
                line([-2 -0.5], [0 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
                aa=0;
                t2=[-0.5 -0.5];
            else
                aa=a(i-1);
                t2=[(i-1.5) (i-1.5)];
            end
            bb=a(i);
            line(t2, [aa bb], 'Color', colors(i,:), 'LineStyle', '--', 'LineWidth', 2);
            text(i-1, a(i) + 0.1, num2str(a(i)), 'FontSize', 10, 'FontWeight', 'bold', 'Color', colors(i, :), 'HorizontalAlignment', 'center');
        end
        line(t2+1, [a(i) 0], 'Color', colors(i,:), 'LineStyle', '--', 'LineWidth', 2);
        line([i-0.5 i], [0 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
        title('Individual Sinc Functions for Each PAM Symbol');
        xlabel('Time'); ylabel('Amplitude');
        grid on; hold off;

        % Plot superposition
        axes(hAx2); hold on;
        plot(t, y_total, 'k-', 'LineWidth', 2); % combined signal
        for i = 1:N
            z = a(i) .* ones(1,100);
            size(z)
            t2=[i-1.5:0.01:i-0.5];
            t2=t2(1,1:100);
            size(t2)
            plot(t2, z, 'Color', colors(i,:), 'LineWidth', 2); % original PAM
            if i==1
                line([-2 -0.5], [0 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
                aa=0;
                t2=[-0.5 -0.5];
            else
                aa=a(i-1);
                t2=[(i-1.5) (i-1.5)];
            end
            bb=a(i);
            line(t2, [aa bb], 'Color', colors(i,:), 'LineStyle', '--', 'LineWidth', 2);
            text(i-1, a(i) + 0.1, num2str(a(i)), 'FontSize', 10, 'FontWeight', 'bold', 'Color', colors(i, :), 'HorizontalAlignment', 'center');

        end
        line(t2+1, [a(i) 0], 'Color', colors(i,:), 'LineStyle', '--', 'LineWidth', 2);
        line([i-0.5 i], [0 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);

        title('Superposition of Sincs and Reconstructed PAM Signal');
        xlabel('Time'); ylabel('Amplitude');
        legend('Sincs', 'Reconstructed PAM');
        grid on; hold off;
    end
end

