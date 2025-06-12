%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 9-2:               %
%           Entropy of Biosignals comparing to noise           %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 9-Section                        %
%                                                              %
%                                                              %
%   Version.1:             04/03/03---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sinc_modulation_GUI
    % Create the GUI figure first
    fig = figure('Name', 'Sinc Modulation GUI', 'NumberTitle', 'off', 'Position', [100 100 600 400]);
    
    % UI Components
    binStrLabel = uicontrol('Style', 'text', 'String', 'Binary String (1-10 bits):', 'HorizontalAlignment', 'left');
    binStrEdit = uicontrol('Style', 'edit', 'String', '');
    modulateButton = uicontrol('Style', 'pushbutton', 'String', 'Generate', 'Callback', @generateSinc);
    ax = axes('Parent', fig);
    
    % Set SizeChangedFcn after defining fig
    set(fig, 'SizeChangedFcn', @resizeGUI);
    % 
    % % Initial layout setup
    % resizeGUI();
    % 
    % function resizeGUI(~, ~)
        % Get figure size
        figPos = get(fig, 'Position');
        width = figPos(3);
        height = figPos(4);

        % Adjust UI component positions dynamically
        set(binStrLabel, 'Position', [20, height - 40, 150, 20]);
        set(binStrEdit, 'Position', [180, height - 40, 100, 25]);
        set(modulateButton, 'Position', [300, height - 40, 100, 30]);
        set(ax, 'Position', [50, 50, width - 100, height - 120]);
    % end
    
    % function generateSinc(~, ~)
        binStr = get(binStrEdit, 'String');
        if isempty(binStr) || ~all(ismember(binStr, '01')) || length(binStr) > 10
            errordlg('Enter a valid binary string (1-10 bits).', 'Error');
            return;
        end
        binSeq = binStr - '0';
        
        t = -10:0.01:10;
        signal = zeros(size(t));
        colors = lines(length(binSeq));
        hold off;
        
        for i = 1:length(binSeq)
            if binSeq(i) == 1
                sincWave = sinc(t - i);
                signal = signal + sincWave;
                plot(t, sincWave, 'Color', colors(i, :), 'LineWidth', 2);
                hold on;
            end
        end
        
        plot(t, signal, 'k', 'LineWidth', 2); % Summed signal in black
        grid on;
        title('Sinc Modulated Signal');
        xlabel('Time');
        ylabel('Amplitude');
        hold off;
    end
% end