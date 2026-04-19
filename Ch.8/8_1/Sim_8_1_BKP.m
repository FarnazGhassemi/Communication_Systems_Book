%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 8_1:               %
%                        PulseModulations                      %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 8-Section                        %
%                                                              %
%                                                              %
%   Version.1:             04/03/03---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Sim_8_1
    close all
    clc
    % GUI
    fig = figure('Name', 'Pulse Modulation', 'NumberTitle', 'off', 'Position', [100 100 500 300]);
    
    uicontrol('Style', 'text', 'Position', [20 250 120 20], 'String', 'Binary String: (Max: 10 Bits)');
    binaryInput = uicontrol('Style', 'edit', 'Position', [150 250 100 25], 'String', '101');
    
    uicontrol('Style', 'text', 'Position', [20 210 120 20], 'String', 'Modulation Type:');
    modTypes = {'PAM-UniPolar', 'PAM-BBipolar', 'PDM', 'PPM'};
    modMenu = uicontrol('Style', 'popupmenu', 'Position', [150 210 150 25], 'String', modTypes);
    
    uicontrol('Style', 'pushbutton', 'Position', [150 170 100 30], 'String', 'Modulate', 'Callback', @modulateSignal);
    
    axesHandle = axes('Units', 'pixels', 'Position', [50 50 400 100]);
    
    function modulateSignal(~, ~)
        bits = get(binaryInput, 'String');
        if any(bits ~= '0' & bits ~= '1') || length(bits) > 10
            errordlg('Binary string must contain only 0 and 1, with a maximum of 10 bits!', 'Error');
            return;
        end
        bits = bits - '0'; % Convert string to numeric array
        modType = get(modMenu, 'Value');
        t = linspace(0, length(bits), length(bits) * 100);
        signal = zeros(size(t));
        colors = lines(length(bits));
        
        hold(axesHandle, 'off');
        switch modType
            case 1 % Unipolar PAM
                for i = 1:length(bits)
                    signal((i-1)*100+1:i*100) = bits(i);
                    plot(axesHandle, t((i-1)*100+1:i*100), signal((i-1)*100+1:i*100), 'Color', colors(i, :), 'LineWidth', 2);
                    line([t(i*100) t(i*100)], [0 1], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
                    text(mean(t((i-1)*100+1:i*100)), bits(i) + 0.1, num2str(bits(i)), 'FontSize', 10, 'FontWeight', 'bold', 'Color', colors(i, :), 'HorizontalAlignment', 'center');
                    hold(axesHandle, 'on');
                end
            case 2 % Bipolar PAM
                for i = 1:length(bits)
                    signal((i-1)*100+1:i*100) = 2*bits(i) - 1;
                    plot(axesHandle, t((i-1)*100+1:i*100), signal((i-1)*100+1:i*100), 'Color', colors(i, :), 'LineWidth', 2);
                    line([t(i*100) t(i*100)], [-1 1], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
                    text(mean(t((i-1)*100+1:i*100)), bits(i)*2-1 + 0.1, num2str(bits(i)), 'FontSize', 10, 'FontWeight', 'bold', 'Color', colors(i, :), 'HorizontalAlignment', 'center');
                    hold(axesHandle, 'on');
                end
            case 3 % PDM
                for i = 1:length(bits)
                    duty = bits(i) * 50 + 10;
                    signal((i-1)*100+1:(i-1)*100 + duty) = 1;
                    plot(axesHandle, t((i-1)*100+1:i*100), signal((i-1)*100+1:i*100), 'Color', colors(i, :), 'LineWidth', 2);
                    line([t(i*100) t(i*100)], [0 1], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
                    text(mean(t((i-1)*100+1:i*100)), bits(i) + 0.1, num2str(bits(i)), 'FontSize', 10, 'FontWeight', 'bold', 'Color', colors(i, :), 'HorizontalAlignment', 'center');
                    hold(axesHandle, 'on');
                end
            case 4 % PPM
                for i = 1:length(bits)
                    delay = bits(i) * 50;
                    signal((i-1)*100+delay+1:(i-1)*100+delay+10) = 1;
                    plot(axesHandle, t((i-1)*100+1:i*100), signal((i-1)*100+1:i*100), 'Color', colors(i, :), 'LineWidth', 2);
                    line([t(i*100) t(i*100)], [0 1], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1);
                    text(mean(t((i-1)*100+1:i*100)), bits(i) + 0.1, num2str(bits(i)), 'FontSize', 10, 'FontWeight', 'bold', 'Color', colors(i, :), 'HorizontalAlignment', 'center');
                    hold(axesHandle, 'on');
                end
        end
        grid(axesHandle, 'on');
        title(axesHandle, 'Modulated Signal');
        xlabel(axesHandle, 'Time');
        ylabel(axesHandle, 'Amplitude');
    end
end