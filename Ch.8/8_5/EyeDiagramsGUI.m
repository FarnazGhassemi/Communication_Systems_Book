%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               GUI for Generating Eye Diagram                 %
%               for Various Modulation Schemes                 %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 9 - Section                        %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by Meysam        %
%   Farahai and Bahar Farahnak as an activity for the          %
%   related course.                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  The code provides a graphical user interface (GUI) to generate and 
%    display eye diagrams for different modulation schemes, including PAM, 
%    PSK, and PWM. It allows users to specify parameters such as 
%    signal-to-noise ratio (SNR), modulation type, and modulation order (M), 
%    and includes an option to add Gaussian noise to the signal for analysis.
%    Before generating the eye diagram, it applies a Raised Cosine filter, 
%    reducing inter-symbol interference (ISI) and ensuring smoother 
%    transitions for a clearer eye diagram.
%
%   GUI Components:
%       Edit Field (Enter SNR (dB)): An input field where the user can 
%        enter the SNR value.
%       Edit Field (Enter M): An input field where the user can enter the
%        modulation order (M).
%       Drop Down (Modulation Type): A dropdown menu that allows the user 
%        to choose between PAM, PSK, or PWM modulation types.
%       Check Box (Add AWGN): A checkbox that allows the user to select 
%        whether Gaussian noise should be added to the signal.
%       Button (Generate Eye Diagram): A button that triggers the 
%        generation of the eye diagram when clicked. It first clears the
%        plot window the proceeds to generate the eye digram.
%       Figure Window: A figure for displaying the eye diagram.
%
%%---------------------------------------------------------------
%%

function EyeDiagramsGUI
    % Create a figure
    fig = figure('Name', 'Eye Diagram Generator', 'Position', [100, 100, 600, 400]);
    
    % Create SNR label
    uicontrol('Style', 'text', 'String', 'Enter SNR (dB):', 'Position', [50, 350, 100, 20]);
    
    % Create SNR edit field
    snrEdit = uicontrol('Style', 'edit', 'Position', [160, 350, 100, 20]);
    
    % Create modulation type label
    uicontrol('Style', 'text', 'String', 'Modulation Type:', 'Position', [280, 350, 100, 20]);
    
    % Create modulation type popup menu
    modTypePopup = uicontrol('Style', 'popupmenu', 'String', {'PAM', 'PSK', 'PWM'}, 'Position', [400, 350, 100, 20]);
    
    % Create M value label
    uicontrol('Style', 'text', 'String', 'Enter M:', 'Position', [50, 320, 100, 20]);
    
    % Create M value edit field
    MEdit = uicontrol('Style', 'edit', 'Position', [160, 320, 100, 20]);
    
    % Create noise checkbox
    noiseCheckbox = uicontrol('Style', 'checkbox', 'String', 'Add AWGN', 'Position', [280, 320, 100, 20]);
    
    % Create generate button
    uicontrol('Style', 'pushbutton', 'String', 'Generate Eye Diagram', 'Position', [50, 280, 150, 30], 'Callback', @generateEyeDiagram);
    
    % Create axes for eye diagram
    axesEye = axes('Units', 'pixels', 'Position', [5000, 50, 500, 200]);
    
    function generateEyeDiagram(~, ~)
        % Clear previous plot
        cla(axesEye);
        
        % Get SNR value from edit field
        SNR_dB = str2double(get(snrEdit, 'String'));
        
        % Get modulation type
        modType = get(modTypePopup, 'Value');
        modulation = '';
        switch modType
            case 1
                modulation = 'PAM';
            case 2
                modulation = 'PSK';
            case 3
                modulation = 'PWM';
        end
        
        % Get M value
        M = str2double(get(MEdit, 'String'));
        
        % Generate random data
        N = 1000; % Number of symbols
        data = randi([0 M-1], N, 1);
        
        % Modulation
        switch modulation
            case 'PAM'
                signal = pammod(data, M);
            case 'PSK'
                signal = pskmod(data, M);
            case 'PWM'
                Fs = 1000; % Sampling frequency
                dutyCycle = 0.5; % Duty cycle for PWM
                signal = pwmMod(data, Fs, dutyCycle, M);
        end
        
        % Add noise if checkbox is checked
        if get(noiseCheckbox, 'Value') == 1
            signal = awgn(signal, SNR_dB, 'measured');
        end
        
        % Separate real part for PAM to avoid quadrature component issue
        if strcmp(modulation, 'PAM')
            signal = real(signal);
        end
        
        % Upsample the signal
        Rb = 1000; % Bit rate in bits per second
        Fs = 10 * Rb; % Sampling frequency
        upsampleFactor = Fs / Rb;
        txSignal = upsample(signal, upsampleFactor);

        % Design a Raised Cosine filter
        span = 10; % Filter span in symbols
        rolloff = 0.5; % Rolloff factor
        rcFilter = rcosdesign(rolloff, span, upsampleFactor);

        % Apply the Raised Cosine filter to the transmitted signal
        filteredSignal = filter(rcFilter, 1, txSignal);

        % Parameters for the eye diagrams
        samplesPerSymbol = upsampleFactor;
        
        % Plot eye diagram
        axes(axesEye); % Set the current axes
        eyediagram(filteredSignal, samplesPerSymbol);
        title(['Eye Diagram (', modulation, ' with M=', num2str(M), ', SNR = ', num2str(SNR_dB), ' dB)']);
    end
end

function pwmSignal = pwmMod(data, Fs, dutyCycle, M)
    % PWM Modulation with M levels
    % data: input data (0 to M-1)
    % Fs: sampling frequency
    % dutyCycle: duty cycle for the PWM signal (between 0 and 1)
    % M: number of modulation levels
    
    % Number of samples per symbol
    samplesPerSymbol = round(Fs / length(data));
    
    % Initialize the PWM signal
    pwmSignal = zeros(1, length(data) * samplesPerSymbol);
        
    for i = 1:length(data)
        % Create a PWM pulse for each symbol in data
        pulseWidth = dutyCycle * data(i) / (M - 1); % Scale pulse width according to symbol value
        pwmSignal((i-1)*samplesPerSymbol + 1 : (i-1)*samplesPerSymbol + round(samplesPerSymbol * pulseWidth)) = 1;
    end
end
